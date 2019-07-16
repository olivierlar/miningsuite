
testfile = 'voice.wav'
%testfile = 'ragtime.wav'

%% testing migration: mirenvelope with sig.envelope with Filter
% TEST FAIL: for the file ragtime.wav,mirenvelope returns a 11517x1 double array wheras sig.envelope returns 11517x2 double array
% The data when inspected are same for elements initially, but different down the index
disp('testing migration: mirenvelope with sig.envelope with Filter'); 
a = mirenvelope(testfile, 'Filter');
b = sig.envelope(testfile, 'Filter', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Hilbert

disp('testing migration: mirenvelope with sig.envelope with Hilbert');
a = mirenvelope(testfile, 'Hilbert');
b = sig.envelope(testfile, 'Hilbert', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;



%% testing migration: mirenvelope with sig.envelope with PreDecim
disp('testing migration: mirenvelope with sig.envelope with PreDecim');

n = 2;

a = mirenvelope(testfile, 'PreDecim', n);
b = sig.envelope(testfile, 'PreDecim', n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Filtertype: IIR
disp('testing migration: mirenvelope with sig.envelope with Filtertype: IIR');


a = mirenvelope(testfile, 'Filtertype', 'IIR');
b = sig.envelope(testfile, 'Filtertype', 'IIR', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;



%% testing migration: mirenvelope with sig.envelope with Tau
disp('testing migration: mirenvelope with sig.envelope with Tau');

t = 0.02;
a = mirenvelope(testfile, 'Tau', t);
b = sig.envelope(testfile, 'Tau', t, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Filtertype: HalfHann
disp('testing migration: mirenvelope with sig.envelope with Filtertype: HalfHann');


a = mirenvelope(testfile, 'Filtertype', 'HalfHann');
b = sig.envelope(testfile, 'Filtertype', 'HalfHann', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Filtertype: Butter

disp('testing migration: mirenvelope with sig.envelope with Filtertype: Butter');


a = mirenvelope(testfile, 'Filtertype', 'Butter');
b = sig.envelope(testfile, 'Filtertype', 'Butter', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with CutOff

disp('testing migration: mirenvelope with sig.envelope with Filtertype: CutOff');

c = 1500;

a = mirenvelope(testfile, 'CutOff', c);
b = sig.envelope(testfile, 'CutOff', c, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with PostDecim
disp('testing migration: mirenvelope with sig.envelope with PostDecim');

N = 16;

a = mirenvelope(testfile, 'PostDecim', N);
b = sig.envelope(testfile, 'PostDecim', N, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);


if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Spectro
disp('testing migration: mirenvelope with sig.envelope with Spectro');

a = mirenvelope(testfile, 'Spectro');
b = sig.envelope(testfile, 'Spectro', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Frame, b='Freq'
% disp('testing migration: mirenvelope with sig.envelope with Frame, b=''Freq''');
% 
% b = 'Freq';
% 
% a = mirenvelope(testfile, 'Frame', .1, 's', .1, '/1','Window','hanning',b);
% b = sig.envelope(testfile, 'Frame', 1, 's', 1, '/1','Window','hanning',b, 'Power');
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    disp('test fail!');
% end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with Frame
disp('testing migration: mirenvelope with sig.envelope with Frame');

a = mirenvelope(testfile, 'Frame');
b = sig.envelope(testfile, 'Frame', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with UpSample
disp('testing migration: mirenvelope with sig.envelope with UpSample');

N = 2;

a = mirenvelope(testfile, 'UpSample',N);
b = sig.envelope(testfile, 'UpSample',N, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;



%% testing migration: mirenvelope with sig.envelope with Complex
disp('testing migration: mirenvelope with sig.envelope with Complex');

a = mirenvelope(testfile, 'Complex');
b = sig.envelope(testfile, 'Complex', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with PowerSpectrum
disp('testing migration: mirenvelope with sig.envelope with PowerSpectrum');

a = mirenvelope(testfile, 'PowerSpectrum');
b = sig.envelope(testfile, 'PowerSpectrum', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with TimeSmooth
disp('testing migration: mirenvelope with sig.envelope with TimeSmooth');

n = 0;

a = mirenvelope(testfile, 'TimeSmooth', n);
b = sig.envelope(testfile, 'TimeSmooth', n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Sampling
disp('testing migration: mirenvelope with sig.envelope with Sampling');

r = 2000; %rate in Hz

a = mirenvelope(testfile, 'Sampling', r);
b = sig.envelope(testfile, 'Sampling', r, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;



%% testing migration: mirenvelope with sig.envelope with Halfwave
disp('testing migration: mirenvelope with sig.envelope with Halfwave');

a = mirenvelope(testfile, 'Halfwave');
b = sig.envelope(testfile, 'Halfwave', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with Center
disp('testing migration: mirenvelope with sig.envelope with Center');

a = mirenvelope(testfile, 'Center');
b = sig.envelope(testfile, 'Center', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with HalfwaveCenter
disp('testing migration: mirenvelope with sig.envelope with HalfwaveCenter');

a = mirenvelope(testfile, 'HalfwaveCenter');
b = sig.envelope(testfile, 'HalfwaveCenter', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with Log
disp('testing migration: mirenvelope with sig.envelope with Log');

a = mirenvelope(testfile, 'Log');
b = sig.envelope(testfile, 'Log', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with MinLog
disp('testing migration: mirenvelope with sig.envelope with MinLog');

ml = -24; %dB

a = mirenvelope(testfile, 'MinLog', ml);
b = sig.envelope(testfile, 'MinLog', ml, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with Mu
disp('testing migration: mirenvelope with sig.envelope with Mu');

mu = -10; %need to confirm a reasonable value for test

a = mirenvelope(testfile, 'Mu',mu);
b = sig.envelope(testfile, 'Mu',mu, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Power
disp('testing migration: mirenvelope with sig.envelope with Power');


a = mirenvelope(testfile, 'Power');
b = sig.envelope(testfile, 'Power', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Diff
disp('testing migration: mirenvelope with sig.envelope with Diff');


a = mirenvelope(testfile, 'Diff');
b = sig.envelope(testfile, 'Diff', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with HalfwaveDiff
disp('testing migration: mirenvelope with sig.envelope with HalfwaveDiff');


a = mirenvelope(testfile, 'HalfwaveDiff');
b = sig.envelope(testfile, 'HalfwaveDiff', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Normal
disp('testing migration: mirenvelope with sig.envelope with Normal');


a = mirenvelope(testfile, 'Normal');
b = sig.envelope(testfile, 'Normal', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with Normal, AcrossSegments
disp('testing migration: mirenvelope with sig.envelope with Normal, AcrossSegments');


a = mirenvelope(testfile, 'Normal' , 'AcrossSegments');
b = sig.envelope(testfile, 'Normal', 'AcrossSegments', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


%% testing migration: mirenvelope with sig.envelope with Smooth
disp('testing migration: mirenvelope with sig.envelope with Smooth');

o = 30; %default is 30

a = mirenvelope(testfile, 'Smooth' , o);
b = sig.envelope(testfile, 'Smooth', o, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;

%% testing migration: mirenvelope with sig.envelope with Gauss
disp('testing migration: mirenvelope with sig.envelope with Gauss');

o = 30; %default is 30

a = mirenvelope(testfile, 'Gauss' , o);
b = sig.envelope(testfile, 'Gauss', o, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
%clearvars -except testfile ;


