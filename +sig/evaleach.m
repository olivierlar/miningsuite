% SIG.EVALEACH performs the top-down traversal of the design flowchart, at 
% the beginning of the evaluation phase.
% This is during that traversal that we check whether a chunk decomposition
% needs to be performed or not, and carry out that chunk decomposition.
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function y = evaleach(design,filename,window,sr,nargout,frame,chunking,nbsamples) %,single,name
% The last three arguments are not used when sig.evaleach is called for the
% first time, by sig.design.eval.
if nargin<6
    frame = [];
end
if nargin<7
    chunking = 0;
end
if nargin<8 && length(window) > 1
    nbsamples = window(2)-window(1)+1;
end

if isstruct(design(1).tmpfile) && isfield(design(1).tmpfile,'fid') ...
        && design(1).tmpfile.fid
    % The input can be read from the temporary file
    design(2) = [];
    y = {design.tmpfile.data};
    channels = y{1}.fbchannels;
    if isempty(channels)
        channels = 1;
    else
        channels = length(channels);
    end
    current = ftell(design.tmpfile.fid);
    origin = current-nbsamples*channels*8;
    if origin < 0
        nbsamples = nbsamples + origin/channels/8;
        origin = 0;
    end
    fseek(design.tmpfile.fid,origin,'bof');
    [data count] = fread(design.tmpfile.fid,[nbsamples,channels],'double');
    data = reshape(data,[nbsamples,1,channels]);
    fseek(design.tmpfile.fid,current-nbsamples*channels*8,'bof');
    y{1}.Ydata.content = data;
    %a.Sstart = 
    if window(3)
        fclose(design.tmpfile.fid);
        delete(design.tmpfile.filename);
    end
    %argin{i} = a;
    return
end

%chan = d.channel;

%sg = d.segment;
%if ischar(sg)
%    error('ERROR in MIREVAL: mirsegment of design object accepts only array of numbers as second argument.');
%end
if 0 %not(isempty(sg))
    if ~isnumeric(sg)
        sg = sort(mirgetdata(sg));
        sg = [0 sg';sg' len];
    end
    over = find(sg(2,:) > len);
    if not(isempty(over))
        sg = sg(:,1:over-1);
    end
end

%specif = d.specif;
if 0 %isaverage(specif)
    specif.eachchunk = 'Normal';
end

if isempty(design(1).main)
    % The top-down traversal of the design flowchart now reaches the lowest
    % layer, i.e., file loading.
    % Now the actual evaluation will be carried out bottom-up.
    
    if isempty(sr)
        y = mus.midi2nmat(filename);
    else
        data = sig.read(filename,window);
        
        if strcmpi(design.duringoptions.mix,'Pre')
            data = data.sum('channel');
        end
        
        %if frame.inner
        %    warning('Inner frame has not been executed.');
        %end
        
        if ~isempty(frame) && frame.toggle
            frate = sig.compute(@sig.getfrate,sr,frame);
            data = data.frame(frame,sr);
            y = {sig.signal(data,'Xsampling',1/sr,'Name','audio',...
                'Sstart',(window(1)-1)/sr,'Srate',sr,...
                'Ssize',data.size('sample'),...
                'Frate',frate,'fnumber',data.size('frame'))};
        else
            y = {sig.signal(data,'Name','audio',...
                'Sstart',(window(1)-1)/sr,'Srate',sr,...
                'Ssize',data.size('sample'))};
        end
        
        
        %if not(isempty(d.postoption)) && d.postoption.mono
        %    y = miraudio(y,'Mono',1);
        %end
        %y = set(y,'AcrossChunks',get(d,'AcrossChunks'));
    end
    
else
    if isempty(frame) || ~frame.toggle
        % Not already in a frame decomposition process
        frame = design.frame;
    end    
    if chunking % Already in a chunk decomposition process
        y = sig.evaleach(design.input(1),filename,window,sr,1,frame,chunking);
        switch chunking 
            case 1
                after = design.afteroptions;
            case 2
                after = [];
        end
        main = design.main;
        if iscell(main)
            main = main{1};
        end
        y = main(y,design.duringoptions,after);
    elseif isempty(sr)
        if length(design.input) == 2
            y = sig.evaleach(design.input(2),filename,window,sr,1,[],chunking);
            y = design.main{2}(y,design.duringoptions,design.afteroptions);
        else
            y = sig.evaleach(design.input,filename,window,sr,1,[],chunking);
            y = design.main(y,design.duringoptions,design.afteroptions);
        end
    else
        design = design(1);
        if design.nochunk
            y = sig.evaleach(design.input,filename,window,sr,1,[],chunking);
            main = design.main;
            if iscell(main)
                main = main{1};
            end
            y = design.main(y,design.duringoptions,design.afteroptions);
        else
            %frnochunk = isfield(d.frame,'dontchunk');
            %frchunkbefore = isfield(d.frame,'chunkbefore');
            if ~isempty(frame) && frame.toggle % && ~frame.inner
                chunks = compute_frames(frame,sr,window,nbsamples,sig.chunklim,0);
            else
                if nbsamples > sig.chunklim
                    % The required memory exceed the max memory threshold.
                    nch = ceil(nbsamples/sig.chunklim);
                    chunks = max(0,nbsamples-sig.chunklim*(nch:-1:1))+window(1);
                    chunks(2,:) = nbsamples-sig.chunklim*(nch-1:-1:0)+window(1)-1;
                else
                    chunks = [];
                end
            end
            
            if not(isempty(chunks))
                % The chunk decomposition is performed.
                nch = size(chunks,2);
                %d = callbeforechunk(d,d,w,lsz); % Some optional initialisation
                %tmp = [];
                if 1%mirwaitbar
                    h = waitbar(0,['Computing ' design.name]);
                else
                    h = [];
                end
                if not(isempty(design.tmpfile)) && design.tmpfile.fid == 0
                    % When applicable, a new temporary file is created.
                    tmpname = [design.files '.sig.tmp'];
                    design.tmpfile.fid = fopen(tmpname,'w');
                    if design.tmpfile.fid == -1
                        error('Error in SigMinr: Cannot write a temporary file on the Current Directory. Please select a Current Directory with write access.');
                    end
                    chunks = fliplr(chunks);
                end
                
                %afterpostoption = d.postoption; % Used only when:
                % - eachchunk is set to 'Normal',
                % - combinechunk is not set to 'Average', and
                % - no afterchunk field has been specified.
                % afterpostoption will be used for the final call
                % to the method after the chunk decomposition.
                main = design.main;
                if 0 %~isfield(specif,'eachchunk')
                    specif.eachchunk = 'Normal';
                end
                if 1 %ischar(specif.eachchunk) && strcmpi(specif.eachchunk,'Normal')
                    if 0 %not(isempty(d.postoption))
                        pof = fieldnames(d.postoption);
                        for o = 1:length(pof)
                            if isfield(specif.option.(pof{o}),'chunkcombine')
                                afterpostoption = rmfield(afterpostoption,pof{o});
                            else
                                d.postoption = rmfield(d.postoption,pof{o});
                            end
                        end
                    end
                else
                    main = specif.eachchunk;
                end
                
                y = {};
                options = design.duringoptions;
                options.tmp = [];
                for i = 1:size(chunks,2)
                    disp(['Chunk ',num2str(i),'/',num2str(nch),'...'])
                    window = [chunks(1,i) chunks(2,i) (i == size(chunks,2))];
                    
                    if 0 %not(ischar(specif.eachchunk) && ...
                        %strcmpi(specif.eachchunk,'Normal'))
                        if frnochunk
                            d2.postoption = 0;
                        else
                            diffchunks = diff(chunks); % Usual chunk size
                            d2.postoption = max(diffchunks) -  diffchunks(i);
                            % Reduction of the current chunk size to be taken into
                            % consideration in mirspectrum, for instance, using
                            % zeropadding
                        end
                    end
                    
                    chunking = 1;
                    ss = sig.evaleach(design.input,filename,window,sr,1,...
                        frame,chunking,nbsamples);
                    if length(ss)>1 && isstruct(ss{2})
                        design.input.tmpfile = ss{2};
                        chunking = 2;
                        nbsamples = chunks(2,end)-chunks(1,end)+1;
                    end
                    
                    main = design.main;
                    if iscell(main)
                        main = main{1};
                    end
                    ss = main(ss,options,[]);
                    
                    if length(ss)>1
                        options.tmp = ss{2};
                    end
                    
                    y = combinechunks(y,ss,i,design,chunks,nargout);
                    
                    clear ss
                    if ~isempty(h)
                        if 0 %not(d.ascending)
                            close(h)
                            h = waitbar((chunks(1,i)-chunks(1,end))/chunks(2,1),...
                                ['Computing ' func2str(d.method) ' (backward)']);
                        else
                            waitbar((chunks(2,i)-chunks(1))/chunks(end),h)
                        end
                    end
                end
                
                if isempty(design.tmpfile)
                    main = design.main;
                    if iscell(main)
                        main = main{1};
                    end
                    y = main(y,[],design.afteroptions);
                else
                    % Final operations to be executed after the chunk decomposition
                    adr = ftell(design.tmpfile.fid);
                    fclose(design.tmpfile.fid);
                    ytmpfile.fid = fopen(tmpname);
                    fseek(ytmpfile.fid,adr,'bof');
                    ytmpfile.data = y{1};
                    ytmpfile.layer = 0;
                    ytmpfile.filename = tmpname;
                    y{2} = ytmpfile;
                end
                
                if 0 %isa(d,'mirstruct') && ...
                    (isempty(d.frame) || isfield(d.frame,'dontchunk'))
                    y = evalbranches(d,y);
                end
                if ~isempty(h)
                    close(h)
                end
                drawnow
                
            else
                % No chunk decomposition
                if design.extensive
                    innerframe = [];
                else
                    innerframe = frame;
                end
                y = sig.evaleach(design.input,filename,window,sr,1,innerframe);
                design.afteroptions.extract = [];
                main = design.main;
                if iscell(main)
                    main = main{1};
                end
                y = main(y,design.duringoptions,design.afteroptions);
                if 0 %isa(d,'mirstruct') && isfield(d.frame,'dontchunk')
                    y = evalbranches(d,y);
                end
            end
        end
    end
    if isa(y,'seq.Sequence')
        return
    end
    if design.nochunk && ...
            ~isempty(frame) && frame.toggle
        frate = sig.compute(@sig.getfrate,y{1}.Srate,frame);
        y{1}.Ydata = y{1}.Ydata.frame(frame,y{1}.Srate);
        y{1}.Frate = frate;
    end
end



if iscell(y)
    for i = 1:length(y)
        if isa(y{i},'sig.signal')
            if ischar(design)
                y{i}.design = {filename};
            else
                y{i}.design = design;
                y{i}.design.evaluated = 1;
                y{i}.design.files = filename;
            end
        end
    end
end
 
if 0 %iscell(y)
    for i = 1:length(y)
        if not(isempty(y{i}) || isstruct(y{i}))
            if iscell(y{i})
                for j = 1:length(y{i})
                    y{i}{j} = set(y{i}{j},'InterChunk',[]);
                end
            else
                y{i} = set(y{i},'InterChunk',[]);
            end
        end
    end
end


function chunks = compute_frames(fr,sr,w,lsz,CHUNKLIM,frov)
if strcmpi(fr.size.unit,'s')
    fl = fr.size.value*sr;
elseif strcmpi(fr.size.unit,'sp')
    fl = fr.size.value;
end
if strcmpi(fr.hop.unit,'/1')
    h = fr.hop.value*fl;
elseif strcmpi(fr.hop.unit,'%')
    h = fr.hop.value*fl*.01;
elseif strcmpi(fr.hop.unit,'s')
    h = fr.hop.value*sr;
elseif strcmpi(fr.hop.unit,'sp')
    h = fr.hop.value;
elseif strcmpi(fr.hop.unit,'Hz')
    h = sr/fr.hop.value;
end
n = floor((lsz-fl)/h)+1;   % Number of frames
if n < 1
    %warning('WARNING IN MIRFRAME: Frame length longer than total sequence size. No frame decomposition.');
    fp = w;
else
    st = floor(((1:n)-1)*h)+w(1);
    fp = [st; floor(st+fl-1)];
    fp(:,fp(2,:)>w(2)) = [];
end
fpsz = (fp(2,1)-fp(1,1)) * n;      % Total number of samples
if fpsz > CHUNKLIM
    % The required memory exceed the max memory threshold.
    nfr = size(fp,2);                     % Total number of frames
    frch = max(ceil(CHUNKLIM/(fp(2,1)-fp(1,1))),2); % Number of frames per chunk
    frch = max(frch,frov*2);
    nch = ceil((nfr-frch)/(frch-frov))+1; % Number of chunks
    chbeg = (frch-frov)*(0:nch-1)+1;    % First frame in the chunk
    chend = (frch-frov)*(0:nch-1)+frch; % Last frame in the chunk
    chend = min(chend,nfr);
    if frov > 1
        chbeg = chend-frch+1;
    end
    chunks = [fp(1,chbeg) ; fp(2,chend)+1]; % After resampling, one sample may be missing, leading to a complete frame drop.
    chunks(end) = min(chunks(end),fp(end)); % Last chunk should not extend beyond audio size.
else
    chunks = [];
end


%%
function res = combinechunks(old,new,i,design,chunks,nargout) %,sg,single)
if ~isempty(design.tmpfile) && design.tmpfile.fid > 0
    if i < size(chunks,2)
        fwrite(design.tmpfile.fid,new{1}.Ydata.content,'double');
    end
    res = new;
    return
end

if i == 1
    res = new;
else
    if iscell(old{1})
        old{1} = old{1}{1}; % This needs to be properly studied..
    end
    if iscell(new{1})
        new{1} = new{1}{1};
    end
    
    if old{1}.Frate
        res = combineframes(old,new);
    elseif old{1}.Srate
        res = combinesamples(old,new,nargout);
    else
        res = old;
        for z = 1:length(old)
            %if 0 %isframed(old{z})
            %    res(z) = combineframes(old{z},new{z});
            %else
            if ischar(design.combine)
                %if strcmpi(design.combine,'Concat')
                %    res{z} = concatchunk(old{z},new{z},d2.ascending);
                %elseif strcmpi(design.combine,'Sum')
                res{z}.Ydata = old{z}.Ydata.(design.combine)(new{z}.Ydata);
                %else
                %    error(['SYNTAX ERROR: ',design.combine,...
                %           ' is not a known keyword for combinechunk.']);
                %end
            else
                res{z} = design.combine(old{z},new{z});
            end
        end
    end
end


function old = combineframes(old,new)
old{1}.Ydata = old{1}.Ydata.concat(new{1}.Ydata,'frame');
if ~isempty(old{1}.peak)
    old{1}.peak = old{1}.peak.concat(new{1}.peak,'frame');
end


function old = combinesamples(old,new,nargout)
% We can use the nargout parameter to avoid concatenating unused output
for i = 1:length(new)
    if ~isa(old{i},'sig.signal')
        continue
    end
    old{i}.Ydata = old{i}.Ydata.concat(new{i}.Ydata,'sample');
    if ~isempty(old{i}.peak)
        old{i}.peak = old{i}.peak.concat(new{i}.peak,'sample');
    end
end


function z = evalbranches(d,y)
% For complex flowcharts, now that the first temporary variable (y) has been
% computed, the dependent features (d) should be evaluated as well.
branch = get(d,'Data');

for i = 1:length(branch)
    if isa(branch{i},'mirdesign') && get(branch{i},'NoChunk') == 1 
                                        % if the value is 2, it is OK.
        %mirerror('mireval','Flowchart badly designed: mirstruct should not be used if one or several final variables do not accept chunk decomposition.');
    end
end

fields = get(d,'Fields');
z = struct;
tmp = get(d,'Tmp');
for i = 1:length(branch)
    z.(fields{i}) = evalbranch(branch{i},tmp,y);
end
if get(d,'Stat') && isempty(get(d,'Chunk'))
    z = mirstat(z,'FileNames',0);
end


function b = evalbranch(b,d,y)
% We need to evaluate the branch reaching the current node (b) from the parent 
% corresponding to the temporary variable (d),

if iscell(b)
    mirerror('MIREVAL','Sorry, forked branching of temporary variable cannnot be evaluated in current version of MIRtoolbox.');
end
if isstruct(b)
    % Subtrees are evaluated branch after branch.
    f = fields(b);
    for i = 1:length(f)
        b.(f{i}) = evalbranch(b.(f{i}),d,y);
    end
    return
end
if isequal(b,d)
    %% Does it happen ever??
    b = y;
    return
end
if not(isa(b,'mirdesign'))
    mirerror('MIRSTRUCT','In the mirstruct object you defined, the final output should only depend on ''tmp'' variables, and should not therefore reuse the ''Design'' keyword.');
end
v = get(b,'Stored');
if length(v)>1 && ischar(v{2})
    % 
    f = fields(d);
    for i = 1:length(f)
        if strcmpi(v{2},f)
            b = y; % OK, now the temporary variable has been found.
                   % End of recursion.
            return
        end
    end
end

argin = evalbranch(get(b,'Argin'),d,y); % Recursion one parent up

% The operation corresponding to the branch from the parent to the node
% is finally evaluated.
if iscell(b.postoption)
    b = b.method(argin,b.option,b.postoption{:});
else
    b = b.method(argin,b.option,b.postoption);
end


function res = isaverage(specif)
res = isfield(specif,'combinechunk') && ...
        ((ischar(specif.combinechunk) && ...
          strcmpi(specif.combinechunk,'Average')) || ...
         (iscell(specif.combinechunk) && ...
          ischar(specif.combinechunk{1}) && ...
          strcmpi(specif.combinechunk{1},'Average')));
      

function d0 = callbeforechunk(d0,d,w,lsz)
% If necessary, the chunk decomposition is performed a first time for
% initialisation purposes.
% Currently used only for miraudio(...,'Normal')
if not(ischar(d)) && not(iscell(d))
    specif = d.specif;
    CHUNKLIM = mirchunklim;
    nch = ceil(lsz/CHUNKLIM); 
    if isfield(specif,'beforechunk') ...
            && ((isfield(d.option,specif.beforechunk{2}) ...
                    && d.option.(specif.beforechunk{2})) ...
             || (isfield(d.postoption,specif.beforechunk{2}) ...
                    && d.postoption.(specif.beforechunk{2})) )
        if mirwaitbar
            h = waitbar(0,['Preparing ' func2str(d.method)]);
        else
            h = 0;
        end
        for i = 1:nch
            disp(['Chunk ',num2str(i),'/',num2str(nch),'...'])
            chbeg = CHUNKLIM*(i-1);
            chend = CHUNKLIM*i-1;
            d2 = set(d,'Size',d0.size,'File',d0.file,...
                       'Chunk',[chbeg+w(1) min(chend,lsz-1)+w(1)]);
            d2.method = specif.beforechunk{1};
            d2.postoption = {chend-lsz};
            d2.chunkdecomposed = 1;
            [tmp d] = evalnow(d2);
            d0 = set(d0,'AcrossChunks',tmp);
            if h
                waitbar(chend/lsz,h)
            end
        end
        if h
            close(h);
        end
        drawnow
    else
        d0 = callbeforechunk(d0,d.argin,w,lsz);
    end
end


function y = combinesegment(old,new)
do = get(old,'Data');
to = get(old,'Pos');
fpo = get(old,'FramePos');
ppo = get(old,'PeakPos');
pppo = get(old,'PeakPrecisePos');
pvo = get(old,'PeakVal');
ppvo = get(old,'PeakPreciseVal');
pmo = get(old,'PeakMode');
apo = get(old,'AttackPos');
rpo = get(old,'ReleasePos');
tpo = get(old,'TrackPos');
tvo = get(old,'TrackVal');

dn = get(new,'Data');
tn = get(new,'Pos');
fpn = get(new,'FramePos');
ppn = get(new,'PeakPos');
pppn = get(new,'PeakPrecisePos');
pvn = get(new,'PeakVal');
ppvn = get(new,'PeakPreciseVal');
pmn = get(new,'PeakMode');
apn = get(new,'AttackPos');
rpn = get(new,'ReleasePos');
tpn = get(new,'TrackPos');
tvn = get(new,'TrackVal');

y = old;

if not(isempty(do))
    y = set(y,'Data',{{do{1}{:},dn{1}{:}}});
end

y = set(y,'FramePos',{{fpo{1}{:},fpn{1}{:}}}); 
        
if not(isempty(to)) && size(do{1},2) == size(to{1},2)
    y = set(y,'Pos',{{to{1}{:},tn{1}{:}}}); 
end

if not(isempty(ppo))
    y = set(y,'PeakPos',{{ppo{1}{:},ppn{1}{:}}},...
                'PeakVal',{{pvo{1}{:},pvn{1}{:}}},...
                'PeakMode',{{pmo{1}{:},pmn{1}{:}}});
end

if not(isempty(pppn))
    y = set(y,'PeakPrecisePos',{[pppo{1},pppn{1}{1}]},...
                'PeakPreciseVal',{[ppvo{1},ppvn{1}{1}]});
end

if not(isempty(apn))
    y = set(y,'AttackPos',{[apo{1},apn{1}{1}]});
end

if not(isempty(rpn))
    y = set(y,'ReleasePos',{[rpo{1},rpn{1}{1}]});
end

if not(isempty(tpn))
    y = set(y,'TrackPos',{[tpo{1},tpn{1}{1}]});
end

if not(isempty(tvn))
    y = set(y,'TrackVal',{[tvo{1},tvn{1}{1}]});
end

if isa(old,'miremotion')
    deo = get(old,'DimData');
    ceo = get(old,'ClassData');
    den = get(new,'DimData');
    cen = get(new,'ClassData');
    afo = get(old,'ActivityFactors');
    vfo = get(old,'ValenceFactors');
    tfo = get(old,'TensionFactors');
    hfo = get(old,'HappyFactors');
    sfo = get(old,'SadFactors');
    tdo = get(old,'TenderFactors');
    ago = get(old,'AngerFactors');
    ffo = get(old,'FearFactors');
    afn = get(new,'ActivityFactors');
    vfn = get(new,'ValenceFactors');
    tfn = get(new,'TensionFactors');
    hfn = get(new,'HappyFactors');
    sfn = get(new,'SadFactors');
    tdn = get(new,'TenderFactors');
    agn = get(new,'AngerFactors');
    ffn = get(new,'FearFactors');
    y = set(y,'DimData',{[deo{1},den{1}{1}]},...
            'ClassData',{[ceo{1},cen{1}{1}]},...
            'ActivityFactors',{[afo{1},afn{1}{1}]},...
            'ValenceFactors',{[vfo{1},vfn{1}{1}]},...
            'TensionFactors',{[tfo{1},tfn{1}{1}]},...
            'HappyFactors',{[hfo{1},hfn{1}{1}]},...
            'SadFactors',{[sfo{1},sfn{1}{1}]},...
            'TenderFactors',{[tdo{1},tdn{1}{1}]},...
            'AngerFactors',{[ago{1},agn{1}{1}]},...
            'FearFactors',{[ffo{1},ffn{1}{1}]}...
        );
end
 

function y = divideweightchunk(orig,length)
d = get(orig,'Data');
if isempty(d)
    y = orig;
else
    v = mircompute(@divideweight,d,length);
    y = set(orig,'Data',v);
end

function e = multweight(d,length)
e = d*length;

function e = divideweight(d,length)
e = d/length;