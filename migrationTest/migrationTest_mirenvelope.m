
testfile = 'ragtime.wav'

%% testing migration: mirenvelope(..., 'Filter') -> sig.envelope(..., 'Filter') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Filter'') -> sig.envelope(..., ''Filter'') </strong> '); 

a = mirenvelope(testfile, 'Filter');
b = sig.envelope(testfile, 'Filter', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Hilbert') -> sig.envelope(..., 'Hilbert') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Hilbert'') -> sig.envelope(..., ''Hilbert'') </strong> '); 
a = mirenvelope(testfile, 'Hilbert');
b = sig.envelope(testfile, 'Hilbert', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'PreDecim', n) -> sig.envelope(..., 'PreDecim', n) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''PreDecim'', n) -> sig.envelope(..., ''PreDecim'', n) </strong> '); 

n = 2;

a = mirenvelope(testfile, 'PreDecim', n);
b = sig.envelope(testfile, 'PreDecim', n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Filtertype', 'IIR') -> sig.envelope(..., 'Filtertype', 'IIR') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Filtertype'', ''IIR'') -> sig.envelope(..., ''Filtertype'', ''IIR'') </strong> '); 


a = mirenvelope(testfile, 'Filtertype', 'IIR');
b = sig.envelope(testfile, 'Filtertype', 'IIR', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Tau', t) -> sig.envelope(..., 'Tau', t) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Tau'', t) -> sig.envelope(..., ''Tau'', t) </strong> '); 


t = 0.02;
a = mirenvelope(testfile, 'Tau', t);
b = sig.envelope(testfile, 'Tau', t, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Filtertype', 'HalfHann') -> sig.envelope(..., 'Filtertype', 'HalfHann') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Filtertype'', ''HalfHann'') -> sig.envelope(..., ''Filtertype'', ''HalfHann'') </strong> '); 



a = mirenvelope(testfile, 'Filtertype', 'HalfHann');
b = sig.envelope(testfile, 'Filtertype', 'HalfHann', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Filtertype', 'Butter') -> sig.envelope(..., 'Filtertype', 'Butter') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Filtertype'', ''Butter'') -> sig.envelope(..., ''Filtertype'', ''Butter'') </strong> '); 

a = mirenvelope(testfile, 'Filtertype', 'Butter');
b = sig.envelope(testfile, 'Filtertype', 'Butter', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Filtertype', 'Butter','CutOff', c) -> sig.envelope(..., 'Filtertype', 'Butter','CutOff', c) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(...,''Filtertype'', ''Butter'',''CutOff'', c) -> sig.envelope(..., ''Filtertype'', ''Butter'',''CutOff'', c) </strong> '); 

c = 1500;

a = mirenvelope(testfile, 'Filtertype', 'Butter','CutOff', c);
b = sig.envelope(testfile, 'Filtertype', 'Butter','CutOff', c, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirenvelope(..., 'PostDecim',N) -> sig.envelope(..., 'PostDecim', N) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''PostDecim'', N) -> sig.envelope(..., ''PostDecim'', N) </strong> '); 


N = 16;

a = mirenvelope(testfile, 'PostDecim', N);
b = sig.envelope(testfile, 'PostDecim', N, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);


if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Spectro') -> sig.envelope(..., 'Spectro') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Spectro'') -> sig.envelope(..., ''Spectro'') </strong> '); 

a = mirenvelope(testfile, 'Spectro');
b = sig.envelope(testfile, 'Spectro', 'Mix');
tf = isequal(squeeze(mirgetdata(a)),b.getdata');

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Spectro', 'Mel') -> sig.envelope(..., 'Spectro', 'Mel') 

clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Spectro'', ''Mel'') -> sig.envelope(..., ''Spectro'', ''Mel'') </strong> '); 

a = mirenvelope(testfile, 'Spectro', 'Mel');
b = sig.envelope(testfile, 'Spectro', 'Mel','Mix');
tf = isequal(squeeze(mirgetdata(a)),b.getdata');

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Frame') -> sig.envelope(..., 'Frame') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Frame'') -> sig.envelope(..., ''Frame'') </strong> '); 

clearvars -except testfile ;
disp('testing migration: mirenvelope with sig.envelope with Frame');

a = mirenvelope(testfile, 'Frame');
b = aud.envelope(testfile, 'Frame', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirenvelope(..., 'UpSample', N) -> sig.envelope(..., 'UpSample', N) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''UpSample'', N) -> sig.envelope(..., ''UpSample'', N) </strong> '); 

N = 2;

a = mirenvelope(testfile, 'UpSample',N);
b = sig.envelope(testfile, 'UpSample',N, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Complex') -> sig.envelope(..., 'Complex') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Complex'') -> sig.envelope(..., ''Complex'') </strong> '); 

a = mirenvelope(testfile, 'Complex');
b = sig.envelope(testfile, 'Complex', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirenvelope(..., 'PowerSpectrum') -> sig.envelope(..., 'PowerSpectrum') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''PowerSpectrum'') -> sig.envelope(..., ''PowerSpectrum'') </strong> '); 

a = mirenvelope(testfile, 'PowerSpectrum');
b = sig.envelope(testfile, 'PowerSpectrum', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'TimeSmooth', n) -> sig.envelope(..., 'TimeSmooth', n) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''TimeSmooth'', n) -> sig.envelope(..., ''TimeSmooth'', n) </strong> '); 

n = 0;

a = mirenvelope(testfile, 'TimeSmooth', n);
b = sig.envelope(testfile, 'TimeSmooth', n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Sampling', r) -> sig.envelope(..., 'Sampling', r) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Sampling'', r) -> sig.envelope(..., ''Sampling'', r) </strong> '); 


r = 2000; %rate in Hz

a = mirenvelope(testfile, 'Sampling', r);
b = sig.envelope(testfile, 'Sampling', r, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Halfwave') -> sig.envelope(..., 'Halfwave') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Halfwave'') -> sig.envelope(..., ''Halfwave'') </strong> '); 

a = mirenvelope(testfile, 'Halfwave');
b = sig.envelope(testfile, 'Halfwave', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Center') -> sig.envelope(..., 'Center') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Center'') -> sig.envelope(..., ''Center'') </strong> '); 

a = mirenvelope(testfile, 'Center');
b = sig.envelope(testfile, 'Center', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'HalfwaveCenter') -> sig.envelope(..., 'HalfwaveCenter') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''HalfwaveCenter'') -> sig.envelope(..., ''HalfwaveCenter'') </strong> '); 

a = mirenvelope(testfile, 'HalfwaveCenter');
b = sig.envelope(testfile, 'HalfwaveCenter', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Log') -> sig.envelope(..., 'Log') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Log'') -> sig.envelope(..., ''Log'') </strong> '); 

a = mirenvelope(testfile, 'Log');
b = sig.envelope(testfile, 'Log', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'MinLog', ml) -> sig.envelope(..., 'MinLog', ml) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''MinLog'', ml) -> sig.envelope(..., ''MinLog'', ml) </strong> '); 

ml = -24; %dB

a = mirenvelope(testfile, 'MinLog', ml);
b = sig.envelope(testfile, 'MinLog', ml, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Mu', mu) -> sig.envelope(..., 'Mu', mu) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Mu'', mu) -> sig.envelope(..., ''Mu'', mu) </strong> '); 

mu = 100; %default = 100

a = mirenvelope(testfile, 'Mu', mu);
b = aud.envelope(testfile, 'Mu', mu, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Power') -> sig.envelope(..., 'Power') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Power'') -> sig.envelope(..., ''Power'') </strong> '); 


a = mirenvelope(testfile, 'Power');
b = sig.envelope(testfile, 'Power', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirenvelope(..., 'Diff') -> sig.envelope(..., 'Diff') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Diff'') -> sig.envelope(..., ''Diff'') </strong> '); 


a = mirenvelope(testfile, 'Diff');
b = sig.envelope(testfile, 'Diff', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'HalfwaveDiff') -> sig.envelope(..., 'HalfwaveDiff') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''HalfwaveDiff'') -> sig.envelope(..., ''HalfwaveDiff'') </strong> '); 


a = mirenvelope(testfile, 'HalfwaveDiff');
b = sig.envelope(testfile, 'HalfwaveDiff', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Normal') -> sig.envelope(..., 'Normal') 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Normal'') -> sig.envelope(..., ''Normal'') </strong> '); 


a = mirenvelope(testfile, 'Normal');
b = sig.envelope(testfile, 'Normal', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Normal', 'AcrossSegments') -> sig.envelope(..., 'Normal', 'AcrossSegments') 
clearvars -except testfile ;
disp( '<strong> testing migration: mirenvelope(..., ''Normal'', ''AcrossSegments'') -> sig.envelope(..., ''Normal'', ''AcrossSegments'') </strong> '); 


a = mirenvelope(testfile, 'Normal' , 'AcrossSegments');
b = sig.envelope(testfile, 'Normal', 'AcrossSegments', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirenvelope(..., 'Lambda', o) -> sig.envelope(..., 'Lambda', o) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Lambda'', l) -> sig.envelope(..., ''Lambda'', l) </strong> '); 

l = 0.2 ; % 0 < l < 1

a = mirenvelope(testfile, 'Lambda', l );
b = aud.envelope(testfile,  'Lambda', l ,  'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end



%% testing migration: mirenvelope(..., 'Smooth', o) -> sig.envelope(..., 'Smooth', o) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Smooth'', o) -> sig.envelope(..., ''Smooth'', o) </strong> '); 

o = 30; %default is 30

a = mirenvelope(testfile, 'Smooth' , o);
b = sig.envelope(testfile, 'Smooth', o, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Gauss', o) -> sig.envelope(..., 'Gauss', o) 
clearvars -except testfile ;
disp('<strong> testing migration: mirenvelope(..., ''Gauss'', o) -> sig.envelope(..., ''Gauss'', o) </strong> '); 

o = 30; %default is 30

a = mirenvelope(testfile, 'Gauss' , o);
b = sig.envelope(testfile, 'Gauss', o, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirenvelope(..., 'Klapuri06') -> sig.envelope(..., 'Klapuri06') 
% clearvars -except testfile ;
% disp('<strong> testing migration: mirenvelope(..., ''Klapuri06'') -> sig.envelope(..., ''Klapuri06'') </strong> '); 
% 
% 
% a = mirenvelope(testfile, 'Spectro',  'Klapuri06' );
% b = aud.envelope(testfile, 'Spectro','Klapuri06', 'Mix');
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    cprintf('*green', 'test SUCCESS!\n'); 
% else
%    cprintf('*red', 'test FAIL!\n');
% end

