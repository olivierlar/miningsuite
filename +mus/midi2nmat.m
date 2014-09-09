function [nmat tempo] = midi2nmat(varargin)
% [nmat tempo] = mus.midi2nmat(filename,<microton>)
% Based on Ken Schutte's m-files (readmidi, midiInfo, getTempoChanges)
% This beta might replace the mex-files used in the previous version of 
% [MIDItoolbox] as 
% newer versions of Matlab (7.4+) and various OS's need new compilations 
% of the mex files. Using the C sources and the compiled mex files provides
% faster reading of midi files but because the compatibility is limited, this 
% simple workaround is offered. This beta version is very primitive,
% though. - Tuomas Eerola
%
% KNOWN PROBLEMS: - Tempo changes are handled in a simple way
%                 - Extra messages are not retained  
%                 - Channels may not be handled correctly    
% 
% For more information on Ken Schutte's functions, see 
% http://www.kenschutte.com/software
%
% CREATED ON 31.12.2007 BY Tuomas Eerola (MATLAB 7.4 MacOSX 10.4)
%
% 17.12.2012 by Olivier Lartillot. Adding the possibility of representing
% microtonality using MIDI pitch-bend data stored in the MIDI file.

if isnumeric(varargin{1})
    return
end

if nargin<2
    microt = 0;
else
    microt = varargin{2};
end

%% USE KEN SCHUTTE'S FUNCTIONS
m = readmidi(varargin{1});
n = midiInfo(m,0,[],microt);
[tempos, tempos_time] = getTempoChanges(m);

%% CONVERT OUTPUT INTO MIDI TOOLBOX NMAT FORMAT
nmat(:,6) = n(:,5);
nmat(:,7) = n(:,6)-n(:,5); % duration
nmat(:,3) = n(:,2);
nmat(:,4) = n(:,3);
nmat(:,5) = n(:,4);

%% CHECK IF MULTIPLE TEMPI
if isempty(tempos), tempos=500000;end % some files may not contain the tempo, use default in that case
if length(tempos)>1
	% here for diff tempi....

	disp('WARNING: Multiple tempi detected, simple recoding of timing (seconds, not beats!)');
    disp(num2str(60./(tempos./1000000)))

    
    tc_ind=0;
    starttime=0;
	for i=1:length(tempos_time)-1
	   	tempo_begin = (tempos_time(i+1)-tempos_time(i))/m.ticks_per_quarter_note*tempos(i)/1000000;
        tempo_begin = tempo_begin+starttime;
        starttime = tempo_begin;
        tc_ind=[tc_ind tempo_begin];
		end
	nmat2=nmat;
	for i=1:length(tc_ind)
		if i==length(tc_ind)
			time_index = nmat(:,6)>=tc_ind(i);
		else
			time_index = nmat(:,6)>=tc_ind(i); %& nmat(:,6)<=tc_ind(i+1);
		end
		
		timeratio = tempos(i)/tempos(1);

% realign timing after tempo changes
		tmp1 = nmat2(time_index,:);
		tmp2 = n(time_index,5).*timeratio; tmp2=tmp2(1);
		realign = tmp1(1,6)-tmp2; % previous onset time
		nmat2(time_index,6) = (n(time_index,5).*timeratio)+realign;
		nmat2(time_index,7) = nmat2(time_index,7).*timeratio;
    end
	nmat(:,1) = n(:,5)/(tempos(1)/1000000); % beats are not modified according to tempi
	nmat(:,2) = (n(:,6)-n(:,5))/(tempos(1)/1000000);

else
	nmat(:,1) = n(:,5)/(tempos(1)/1000000);
	nmat(:,2) = (n(:,6)-n(:,5))/(tempos(1)/1000000);
end

tempo = tempos(1)/1000000;


%% FUNCTIONS


function [Notes,endtime] = midiInfo(midi,outputFormat,tracklist,microt)
% [Notes,endtime] = midiInfo(midi,outputFormat,tracklist)
%
% Takes a midi structre and generates info on notes and messages
% Can return a matrix of note parameters and/or output/display 
%   formatted table of messages
%
% Inputs:
%  midi - Matlab structure (created by readmidi.m)
%  tracklist - which tracks to show ([] for all)
%  outputFormat
%   - if it's a string write the formated output to the file
%   - if 0, don't display or write formatted output
%   - if 1, just display (default)
% 
% outputs:
%   Notes - a matrix containing a list of notes, ordered by start time
%     column values are:
%      1     2    3  4   5  6  7       8
%     [track chan nn vel t1 t2 msgNum1 msgNum2]
%   endtime - time of end of track message
%
%---------------------------------------------------------------
% Subversion Revision: 14 (2006-11-28)
%  minor alterations by TE 2.1.2008
%  microtonality management + minor alterations by OL 17.12.2012
% This software can be used freely for non-commercial use.
% Visit http://www.kenschutte.com/software for more
%   documentation, copyright info, and updates.
%---------------------------------------------------------------


if nargin<3
  tracklist=[];
  if nargin<2
    outputFormat=1;
  end
end
if (isempty(tracklist))
  tracklist = 1:length(midi.track);
end

[tempos, tempos_time] = getTempoChanges(midi);

current_tempo = 500000;  % default tempo

fid = -1;
if (ischar(outputFormat))
  fid = fopen(outputFormat,'w');
end

endtime = -1;

% each row:
%  1     2    3  4   5  6  7       8
% [track chan nn vel t1 t2 msgNum1 msgNum2]
Notes = zeros(0,8);

for i=1:length(tracklist)
  tracknum = tracklist(i);
  cumtime=0;
  seconds=0;

  Msg = cell(0);
  Msg{1,1} = 'chan';
  Msg{1,2} = 'deltatime';
  Msg{1,3} = 'time';
  Msg{1,4} = 'name';
  Msg{1,5} = 'data';

  runnro=1;
  pitchbend = 0;

  for msgNum=1:length(midi.track(tracknum).messages)

    currMsg = midi.track(tracknum).messages(msgNum);
    
    midimeta  = currMsg.midimeta;
    deltatime = currMsg.deltatime;
    data      = currMsg.data;
    type      = currMsg.type;
    chan      = currMsg.chan;

    cumtime = cumtime + deltatime;
    %current_tempo/midi.ticks_per_quarter_note;
    %debug = deltatime*1e-6*current_tempo/midi.ticks_per_quarter_note;

    seconds = seconds + deltatime*1e-6*current_tempo/midi.ticks_per_quarter_note;
    [mx ind] = max(find(cumtime >= tempos_time));
    
    %% % ADDED BY TE 1.1.2008
    if isempty(ind)
        % do nothing
    else
        current_tempo = tempos(ind);
    end
    %% end
    
    % find start/stop of notes:
    %    if (strcmp(name,'Note on') && (data(2)>0))
    % note on with vel>0:
    if (midimeta==1 && type==144 && data(2)>0)
      % note on:
      
     pitch = data(1) + pitchbend;
     pitchbend = 0;
     Notes(end+1,:) = [tracknum chan pitch data(2) seconds 0 runnro -1];
     runnro=runnro+1;
  
    elseif (midimeta==1 && ( (type==144 && data(2)==0) || type==128 ))
      
      % note off:
      %      % find index, wther tr,chan,and nn match, and not complete
      
      ind = find((Notes(:,1)==tracknum) & ...
                 (Notes(:,2)==chan) & ...
                 (Notes(:,3)==pitch) & ...
                 (Notes(:,6)==0) & ... % Remove previous non-terminated note of same pitch (O.Lartillot 20.9.2012)
                 (Notes(:,8)==-1));
      
      if (length(ind)==0)
	%warning('ending non-open note?, trying ending another note instead');
    % Remove previous non-terminated of different pitch (O.Lartillot 20.9.2012)
    ind = find((Notes(:,1)==tracknum) & ...
                 (Notes(:,2)==chan) & ...
                 (Notes(:,6)==0) & ... % Remove previous note of same pitch (O.Lartillot 20.9.2012)
                 (Notes(:,8)==-1));
             ind = ind(end)
      elseif (length(ind)>1)
	%disp('warning: found multiple matches in endNote, taking first...');
	ind = ind(end);
      end
      
      % set info on ending:
      Notes(ind,6) = seconds;
      Notes(ind,8) = -1; %msgNum;
      
      % pitch bend (exclusivity The MiningSuite)
    elseif microt && midimeta==1 && type==224
      pitchbend = (data(2)*128+data(1) - 8192)/8192;
      % end of track:
    elseif midimeta==0 && type==47
      if (endtime == -1)
	endtime = seconds;
      else
	%disp('two "end of track" messages?');
	endtime(end+1) = seconds;
      end
    
    
    end
    
    % we could check to make sure it ends with
    %  'end of track'

    
    if (outputFormat ~= 0)
      % get some specific descriptions:
      name = num2str(type);
      dataStr = num2str(data);

      if (isempty(chan))
	Msg{msgNum,1} = '-';
      else
	Msg{msgNum,1} = num2str(chan);
      end
      
      Msg{msgNum,2} = num2str(deltatime);
      Msg{msgNum,3} = formatTime(seconds);
      
      if (midimeta==0)
	Msg{msgNum,4} = 'meta';
      else
	Msg{msgNum,4} = '';
      end
      
      [name,dataStr] = getMsgInfo(midimeta, type, data);
      Msg{msgNum,5} = name;
      Msg{msgNum,6} = dataStr;
    end
    
    
  end
  
  if (outputFormat ~= 0)
    printTrackInfo(Msg,tracknum,fid);
  end
  
end

% make this an option!!!
% - I'm not sure why it's needed...
% remove start silence:

%_ removed by TE 
%_first_t = min(Notes(:,5));
%_Notes(:,5) = Notes(:,5) - first_t;
%_Notes(:,6) = Notes(:,6) - first_t;

% sort Notes by start time:
[junk,ord] = sort(Notes(:,5));
Notes = Notes(ord,:);


if (fid ~= -1)
  fclose(fid);
end











function printTrackInfo(Msg,tracknum,fid)


% make cols same length instead of just using \t
for i=1:size(Msg,2)
  maxLen(i)=0;
  for j=1:size(Msg,1)
    if (length(Msg{j,i})>maxLen(i))
      maxLen(i) = length(Msg{j,i});
    end
  end
end


s='';
s=[s sprintf('--------------------------------------------------\n')];
s=[s sprintf('Track %d\n',tracknum)];
s=[s sprintf('--------------------------------------------------\n')];

if (fid == -1)
  disp(s)
else
  fprintf(fid,'%s',s);
end


for i=1:size(Msg,1)
  line='';
  for j=1:size(Msg,2)
    sp = repmat(' ',1,5+maxLen(j)-length(Msg{i,j}));
    m = Msg{i,j};
    m = m(:)';  % ensure column vector
%    line = [line Msg{i,j} sp];
    line = [line m sp];
  end
  
  if (fid == -1)
    disp(line)
  else
    fprintf(fid,'%s\n',line);
  end

end



function s=formatTime(seconds)

minutes = floor(seconds/60);
secs = seconds - 60*minutes;

s = sprintf('%d:%2.3f',minutes,secs);



function [name,dataStr]=getMsgInfo(midimeta, type, data)

% meta events:
if (midimeta==0)
  if     (type==0);  name = 'Sequence Number';            len=2;  dataStr = num2str(data);
  elseif (type==1);  name = 'Text Events';                len=-1; dataStr = char(data);
  elseif (type==2);  name = 'Copyright Notice';           len=-1; dataStr = char(data);
  elseif (type==3);  name = 'Sequence/Track Name';        len=-1; dataStr = char(data);
  elseif (type==4);  name = 'Instrument Name';            len=-1; dataStr = char(data);
  elseif (type==5);  name = 'Lyric';                      len=-1; dataStr = char(data);
  elseif (type==6);  name = 'Marker';                     len=-1; dataStr = char(data);
  elseif (type==7);  name = 'Cue Point';                  len=-1; dataStr = char(data);
  elseif (type==32); name = 'MIDI Channel Prefix';        len=1;  dataStr = num2str(data);
  elseif (type==47); name = 'End of Track';               len=0;  dataStr = '';
  elseif (type==81); name = 'Set Tempo';                  len=3;   
    val = data(1)*16^4+data(2)*16^2+data(3); dataStr = ['microsec per quarter note: ' num2str(val)];
  elseif (type==84); name = 'SMPTE Offset';               len=5;   
      if size(data)==5
      dataStr = ['[hh mm ss fr ff]=' num2str(data)];
      else
     dataStr = ['[hh mm ss fr ff]=' num2str(data')];
      end
  elseif (type==88); name = 'Time Signature';             len=4;   
    dataStr = [num2str(data(1)) '/' num2str(data(2)) ', clock ticks and notated 32nd notes=' num2str(data(3)) '/' num2str(data(4))];
  elseif (type==89); name = 'Key Signature';              len=2;   
    % num sharps/flats (flats negative)
    if (data(1)>=0)
       %       1   2    3    4   5     6    7   
      ss={'C','G','D', 'A', 'E','B',  'F#', 'C#'};
        if data(1)>7
        dataStr='C'; % ADDED BY TE 1.1.2008
        else
      dataStr = ss{data(1)+1};
        end
      
    else
       %    1   2    3    4   5     6    7   
       ss={'F','Bb','Eb','Ab','Db','Gb','Cb'};
       dataStr = ss{abs(data(1))};
    end
    if (data(2)==0)
      dataStr = [dataStr ' Major'];
    else
      dataStr = [dataStr ' Minor'];
    end
    
  elseif (type==89); name = 'Sequencer-Specific Meta-event';   len=-1;  
    dataStr = char(data);
    % !! last two conflict...
  
  else
    name = ['UNKNOWN META EVENT: ' num2str(type)]; dataStr = num2str(data);
  end
  
% meta 0x21 = MIDI port number, length 1 (? perhaps)
else

  % channel voice messages:  
  %  (from event byte with chan removed, eg 0x8n -> 0x80 = 128 for
  %  note off)
  if     (type==128);  name = 'Note off';                 len=2; dataStr = ['nn=' num2str(data(1)) '  vel=' num2str(data(2))];
  elseif (type==144);  name = 'Note on';                  len=2; dataStr = ['nn=' num2str(data(1)) '  vel=' num2str(data(2))];
  elseif (type==160); name = 'Polyphonic Key Pressure';   len=2; dataStr = ['nn=' num2str(data(1)) '  vel=' num2str(data(2))];
  elseif (type==176); name = 'Controller Change';         len=2; dataStr = ['ctrl=' controllers(data(1)) '  value=' num2str(data(2))];
  elseif (type==192); name = 'Program Change';            len=1; dataStr = ['instr=' num2str(data)];
  elseif (type==208); name = 'Channel Key Pressure';      len=1; dataStr = ['vel=' num2str(data)];
  elseif (type==224); name = 'Pitch Bend';                len=2; 
    val = data(1)+data(2)*256;
    val = base2dec('2000',16) - val;
    dataStr = ['change=' num2str(val) '?'];
  
  % channel mode messages:
  %  ... unsure about data for these... (do some have a data byte and
  %  others not?)
  %
  % 0xC1 .. 0xC8
  elseif (type==193);  name = 'All Sounds Off';            dataStr = num2str(data);
  elseif (type==194);  name = 'Reset All Controllers';     dataStr = num2str(data);
  elseif (type==195); name = 'Local Control';             dataStr = num2str(data);
  elseif (type==196); name = 'All Notes Off';             dataStr = num2str(data);
  elseif (type==197); name = 'Omni Mode Off';             dataStr = num2str(data);
  elseif (type==198); name = 'Omni Mode On';              dataStr = num2str(data);
  elseif (type==199); name = 'Mono Mode On';              dataStr = num2str(data);
  elseif (type==200); name = 'Poly Mode On';              dataStr = num2str(data);
  
    % sysex, F0->F7
  elseif (type==240); name = 'Sysex 0xF0';              dataStr = num2str(data);
  elseif (type==241); name = 'Sysex 0xF1';              dataStr = num2str(data);
  elseif (type==242); name = 'Sysex 0xF2';              dataStr = num2str(data);
  elseif (type==243); name = 'Sysex 0xF3';              dataStr = num2str(data);
  elseif (type==244); name = 'Sysex 0xF4';              dataStr = num2str(data);
  elseif (type==245); name = 'Sysex 0xF5';              dataStr = num2str(data);
  elseif (type==246); name = 'Sysex 0xF6';              dataStr = num2str(data);
  elseif (type==247); name = 'Sysex 0xF7';              dataStr = num2str(data);
    
    % realtime
    % (i think have no data..?)
  elseif (type==248); name = 'Real-time 0xF8 - Timing clock';              dataStr = num2str(data);
  elseif (type==249); name = 'Real-time 0xF9';              dataStr = num2str(data);
  elseif (type==250); name = 'Real-time 0xFA - Start a sequence';              dataStr = num2str(data);
  elseif (type==251); name = 'Real-time 0xFB - Continue a sequence';              dataStr = num2str(data);
  elseif (type==252); name = 'Real-time 0xFC - Stop a sequence';              dataStr = num2str(data);
  elseif (type==253); name = 'Real-time 0xFD';              dataStr = num2str(data);
  elseif (type==254); name = 'Real-time 0xFE';              dataStr = num2str(data);
  elseif (type==255); name = 'Real-time 0xFF';              dataStr = num2str(data);
  

  else
    name = ['UNKNOWN MIDI EVENT: ' num2str(type)]; dataStr = num2str(data);
  end


end

function s=controllers(n)
if (n==1); s='Mod Wheel';
elseif (n==2); s='Breath Controllery';
elseif (n==4); s='Foot Controller';
elseif (n==5); s='Portamento Time';
elseif (n==6); s='Data Entry MSB';
elseif (n==7); s='Volume';
elseif (n==8); s='Balance';
elseif (n==10); s='Pan';
elseif (n==11); s='Expression Controller';
elseif (n==16); s='General Purpose 1';
elseif (n==17); s='General Purpose 2';
elseif (n==18); s='General Purpose 3';
elseif (n==19); s='General Purpose 4';
elseif (n==64); s='Sustain';
elseif (n==65); s='Portamento';
elseif (n==66); s='Sustenuto';
elseif (n==67); s='Soft Pedal';
elseif (n==69); s='Hold 2';
elseif (n==80); s='General Purpose 5';
elseif (n==81); s='Temp Change (General Purpose 6)';
elseif (n==82); s='General Purpose 7';
elseif (n==83); s='General Purpose 8';
elseif (n==91); s='Ext Effects Depth';
elseif (n==92); s='Tremelo Depthy';
elseif (n==93); s='Chorus Depth';
elseif (n==94); s='Detune Depth (Celeste Depth)';
elseif (n==95); s='Phaser Depth';
elseif (n==96); s='Data Increment (Data Entry +1)';
elseif (n==97); s='Data Decrement (Data Entry -1)';
elseif (n==98); s='Non-Registered Param LSB';
elseif (n==99); s='Non-Registered Param MSB';
elseif (n==100); s='Registered Param LSB';
elseif (n==101); s='Registered Param MSB';
else
  s='UNKNOWN CONTROLLER';
end

%Channel mode message values
%Reset All Controllers 	79 	121 	Val ??
%Local Control 	7A 	122 	Val 0 = off, 7F (127) = on
%All Notes Off 	7B 	123 	Val must be 0
%Omni Mode Off 	7C 	124 	Val must be 0
%Omni Mode On 	7D 	125 	Val must be 0
%Mono Mode On 	7E 	126 	Val = # of channels, or 0 if # channels equals # voices in receiver
%Poly Mode On 	7F 	127 	Val must be 0


function [tempos,tempos_time]=getTempoChanges(midi)
% [tempos,tempos_time]=getTempoChanges(midi)
%
% input: a midi struct from readmidi.m
% output:
%  tempos = tempo values indexed by tempos_time
%    tempos_time is in units of ticks
%
% should tempo changes effect across tracks? across channels?
%
%---------------------------------------------------------------
% Subversion Revision: 14 (2006-01-24)
%
% This software can be used freely for non-commerical use.
% Visit http://www.kenschutte.com/software for more
%   documentation, copyright info, and updates.
%---------------------------------------------------------------


tempos = [];
tempos_time = [];
%tempos_index = [];
for i=1:length(midi.track)
  cumtime=0;
  for j=1:length(midi.track(i).messages)
    cumtime = cumtime+midi.track(i).messages(j).deltatime;
%    if (strcmp(midi.track(i).messages(j).name,'Set Tempo'))
    if (midi.track(i).messages(j).midimeta==0 && midi.track(i).messages(j).type==81)
        
      tempos_time(end+1) = cumtime;
      d = midi.track(i).messages(j).data;
      tempos(end+1) =  d(1)*16^4 + d(2)*16^2 + d(3);
    end
  end
end


function midi = readmidi(filename, rawbytes)
% midi = readmidi(filename, rawbytes)
% midi = readmidi(filename)
%
% Read MIDI file and store in a Matlab structure
% (use midiInfo.m to see structure detail)
%
% Inputs:
%  filename - input MIDI file
%  rawbytes - 0 or 1: Include raw bytes in structure
%             This info is redundant, but can be
%             useful for debugging. default=0
%
%---------------------------------------------------------------
% Subversion Revision: 14 (2006-12-03)
%
% This software can be used freely for non-commerical use.
% Visit http://www.kenschutte.com/software for more
%   documentation, copyright info, and updates.
%---------------------------------------------------------------



if (nargin<2)
  rawbytes=0;
end

fid = fopen(filename);
%[A count] = fread(fid,'char');
[A count] = fread(fid,'uint8');
fclose(fid);

midi.filename = filename;
if (rawbytes) midi.rawbytes_all = A; end


% realtime events: status: [F8, FF].  no data bytes
%clock, undefined, start, continue, stop, undefined, active
%sensing, systerm reset

% file consists of "header chunk" and "track chunks"
%   4B  'MThd' (header) or 'MTrk' (track)
%   4B  32-bit unsigned int = number of bytes in chunk, not
%       counting these first 8


% HEADER CHUNK --------------------------------------------------------
% 4B 'Mthd'
% 4B length
% 2B file format
%    0=single track, 1=multitrack synchronous, 2=multitrack asynchronous
%    Synchronous formats start all tracks at the same time, while asynchronous formats can start and end any track at any time during the score.
% 2B track cout (must be 1 for format 0)
% 2B num delta-time ticks per quarter note
%

if ~isequal(A(1:4)',[77 84 104 100])  % double('MThd')
    error('File does not begin with header ID (MThd)');
end

header_len = decode_int(A(5:8));
if (header_len == 6)
else
    error('Header length != 6 bytes.');
end

format = decode_int(A(9:10));
if (format==0 || format==1 || format==2)
     midi.format = format;
else    
    error('Format does not equal 0,1,or 2');
end

num_tracks = decode_int(A(11:12));
if (format==0 && num_tracks~=1)
    error('File is format 0, but num_tracks != 1');
end

time_unit = decode_int(A(13:14));
if (bitand(time_unit,2^15)==0)
  midi.ticks_per_quarter_note = time_unit;
else
  error('Header: SMPTE time format found - not currently supported');
end

if (rawbytes), midi.rawbytes_header = A(1:14); end

% end header parse ----------------------------------------------------






% BREAK INTO SEPARATE TRACKS ------------------------------------------
% midi.track(1).data = [byte byte byte ...];
% midi.track(2).date = ...
% ...
%
% Track Chunks---------
% 4B 'MTrk'
% 4B length (after first 8B)
%
ctr = 15;
for i=1:num_tracks
  
  if ~isequal(A(ctr:ctr+3)',[77 84 114 107])  % double('MTrk')
    error(['Track ' num2str(i) ' does not begin with track ID=MTrk']);
  end
  ctr = ctr+4;
  
  track_len = decode_int(A(ctr:ctr+3));
  ctr = ctr+4;
  
  % have track.rawbytes hold initial 8B also...
  track_rawbytes{i} = A((ctr-8):(ctr+track_len-1));
  
  if (rawbytes)
    midi.track(i).rawbytes_header = A(ctr-8:ctr-1);
  end
  
  ctr = ctr+track_len;
end
% ----------------------------------------------------------------------






% Events:
%  - meta events: start with 'FF'
%  - MIDI events: all others

% MIDI events:
%  optional command byte + 0,1,or 2 bytes of parameters
%  "running mode": command byte omitted.
%
% all midi command bytes have MSB=1
% all data for inside midi command have value <= 127 (ie MSB=0)
% -> so can determine running mode
% 
% meta events' data may have any values (meta events have to set
% len)
%



% 'Fn' MIDI commands:
%  no chan. control the entire system
%F8 Timing Clock
%FA start a sequence
%FB continue a sequence
%FC stop a sequence

% Meta events:
%  1B 0xFF
%  1B event type
%  1B length of additional data
%  ?? additional data
%


% "channel mode messages"
% have same code as "control change": 0xBn
%  but uses reserved controller numbers 120-127
%


%Midi events consist of an optional command byte 
% followed by zero, one or two bytes of parameters.
% In running mode, the command can be omitted, in 
% which case the last MIDI command specified is 
% assumed.  The first bit of a command byte is 1, 
% while the first bit of a parameter is always 0. 
%   In addition, the last 4 bits of a command 
%   indicate the channel to which the event should 
%   be sent; therefore, there are 6 possible 
%   commands (really 7, but we will discuss the x'Fn' 
%   commands later) that can be specified.  They are:


% parse tracks -----------------------------------------
for i=1:num_tracks
  
  track = track_rawbytes{i};

  if (rawbytes); midi.track(i).rawbytes = track; end
  
  msgCtr = 1;
  ctr=9;  % first 8B were MTrk and length
  while (ctr < length(track_rawbytes{i}))

    clear currMsg;
    currMsg.used_running_mode = 0;
    % note:
    %  .used_running_mode is necessary only to 
    %  be able to reconstruct a file _exactly_ from 
    %  the 'midi' structure.  this is helpful for 
    %  debugging since write(read(filename)) can be 
    %  tested for exact replication...
    %
    
    ctr_start_msg = ctr;
    
    [deltatime,ctr] = decode_var_length(track, ctr);
    
    % ?
    %if (rawbytes)
    %  currMsg.rawbytes_deltatime = track(ctr_start_msg:ctr-1);
    %end
    
    % deltaime must be 1-4 bytes long.
    % could check here...
    
    
    % CHECK FOR META EVENTS ------------------------
    % 'FF'
    if track(ctr)==255

      type = track(ctr+1);
      
      ctr = ctr+2;

      % get variable length 'length' field
      [len,ctr] = decode_var_length(track, ctr);

      % note: some meta events have pre-determined lengths...
      %  we could try verifiying they are correct here.

      thedata = track(ctr:ctr+len-1);
      chan = [];
      
      ctr = ctr + len;      

      midimeta = 0;
    
    else 
      midimeta = 1;
      % MIDI EVENT ---------------------------
      


      
      % check for running mode:
      if (track(ctr)<128)

	% make it re-do last command:
	%ctr = ctr - 1;
	%track(ctr) = last_byte;
	currMsg.used_running_mode = 1;
	
	B = last_byte;
	nB = track(ctr); % ?
	
      else
      
	B  = track(ctr);
	nB = track(ctr+1);

	ctr = ctr + 1;

      end
      
      % nibbles:
      %B  = track(ctr);
      %nB = track(ctr+1);

      
      Hn = bitshift(B,-4);
      Ln = bitand(B,15);

      chan = [];
      
      msg_type = midi_msg_type(B,nB);

      % DEBUG:
      if (i==2)
	  if (msgCtr==1)
	    disp(msg_type);
	  end
      end
      
      
      switch msg_type
      
       case 'channel_mode'
	
	% UNSURE: if all channel mode messages have 2 data byes (?)
	type = bitshift(Hn,4) + (nB-120+1);
	thedata = track(ctr:ctr+1);
	chan = Ln;
	
	ctr = ctr + 2;
	
	% ---- channel voice messages:
       case 'channel_voice'
	
	type = bitshift(Hn,4);
	len = channel_voice_msg_len(type); % var length data:
	thedata = track(ctr:ctr+len-1);
	chan = Ln;

	% DEBUG:
	if (i==2)
	  if (msgCtr==1)
	    disp([999  Hn type])
	  end
	end
	
	ctr = ctr + len;
	
       case 'sysex'
	
	% UNSURE: do sysex events (F0-F7) have 
	%  variable length 'length' field?
	
	[len,ctr] = decode_var_length(track, ctr);
	
	type = B;
	thedata = track(ctr:ctr+len-1);
	chan = [];
	
	ctr = ctr + len;
	
       case 'sys_realtime'
	
	% UNSURE: I think these are all just one byte
	type = B;
	thedata = [];
	chan = [];
	
      end
      
      last_byte = Ln + bitshift(Hn,4);
      
    end % end midi event 'if'

    
    currMsg.deltatime = deltatime;
    currMsg.midimeta = midimeta;
    currMsg.type = type;
    currMsg.data = thedata;
    currMsg.chan = chan;
    
    if (rawbytes)
      currMsg.rawbytes = track(ctr_start_msg:ctr-1);
    end
    
    midi.track(i).messages(msgCtr) = currMsg;
    msgCtr = msgCtr + 1;

    
  end % end loop over rawbytes
end % end loop over tracks


function val=decode_int(A)

val = 0;
for i=1:length(A)
  val = val + bitshift(A(length(A)-i+1), 8*(i-1));
end


function len=channel_voice_msg_len(type)

if     (type==128); len=2;
elseif (type==144); len=2;
elseif (type==160); len=2;
elseif (type==176); len=2;
elseif (type==192); len=1;
elseif (type==208); len=1;
elseif (type==224); len=2;
else
  disp(type); error('bad channel voice message type');
end


%
% decode variable length field (often deltatime)
%
%  return value and new position of pointer into 'bytes'
%
function [val,ptr] = decode_var_length(bytes, ptr)

keepgoing=1;
binarystring = '';
while (keepgoing)
  % check MSB:
  %  if MSB=1, then delta-time continues into next byte...
  if(~bitand(bytes(ptr),128))
    keepgoing=0;
  end
  % keep appending last 7 bits from each byte in the deltatime:
  binbyte = ['00000000' dec2base(bytes(ptr),2)];
  binarystring = [binarystring binbyte(end-6:end)];
  ptr=ptr+1;
end
val = base2dec(binarystring,2);




%
% Read first 2 bytes of msg and 
%  determine the type
%  (most require only 1st byte)
%
% str is one of:
%  'channel_mode'
%  'channel_voice'
%  'sysex'
%  'sys_realtime'
%
function str=midi_msg_type(B,nB)

Hn = bitshift(B,-4);
Ln = bitand(B,7);

% ---- channel mode messages:
%if (Hn==11 && nB>=120 && nB<=127)
if (Hn==11 && nB>=122 && nB<=127)
  str = 'channel_mode';

  % ---- channel voice messages:
elseif (Hn>=8 && Hn<=14)
  str = 'channel_voice';
  
  %  ---- sysex events:
elseif (Hn==15 && Ln>=0 && Ln<=7)
  str = 'sysex';

  % system real-time messages
elseif (Hn==15 && Ln>=8 && Ln<=15)
  % UNSURE: how can you tell between 0xFF system real-time
  %   message and 0xFF meta event?
  %   (now, it will always be processed by meta)
  str = 'sys_realtime';
  
else
  % don't think it can get here...
  error('bad midi message');
end