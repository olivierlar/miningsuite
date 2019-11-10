testfile = 'ragtime.wav'


%% testing migration: mirspectrum with sig.spectrum
clearvars -except testfile ;

disp('testing migration: mirspectrum with sig.spectrum'); 
a = mirspectrum(testfile);
b = sig.spectrum(testfile, 'Mix');

x = mirgetdata(a);
y = b.getdata;

tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); debugFail(x,y);
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Frame
clearvars -except testfile ;

disp('testing migration: mirspectrum with sig.spectrum with Frame'); 
a = mirspectrum(testfile, 'Frame');
b = sig.spectrum(testfile, 'Frame', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with Min
clearvars -except testfile ;

mi = 100; %lowest frequency (default 0 Hz)

disp('testing migration: mirspectrum with sig.spectrum with Min'); 
a = mirspectrum(testfile, 'Min', mi);
b = sig.spectrum(testfile, 'Min', mi, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Max
clearvars -except testfile ;

ma = 100; %lowest frequency (default 0 Hz)

disp('testing migration: mirspectrum with sig.spectrum with Max'); 
a = mirspectrum(testfile, 'Max', ma);
b = sig.spectrum(testfile, 'Max', ma, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Window
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Window'); 

w = 'hanning'; %windowing function (default = 'hanning')


a = mirspectrum(testfile, 'Window', w);
b = sig.spectrum(testfile, 'Window', w, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Phase
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Phase'); 


a = mirspectrum(testfile, 'Phase');
b = sig.spectrum(testfile, 'Phase', 'No', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with MinRes
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with MinRes'); 

mr = 100; %minimal frequency resolution

a = mirspectrum(testfile, 'MinRes', mr);
b = sig.spectrum(testfile, 'MinRes', mr, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with MinRes with OctaveRatio
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with MinRes with OctaveRatio'); 

r = 100; %minimal frequency resolution
tol = 0.75;% constraining multiplicative factor (default = 0.75)

a = mirspectrum(testfile, 'MinRes', r, 'OctaveRatio', tol);
b = sig.spectrum(testfile, 'MinRes', r, 'OctaveRatio', tol,'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

x = mirgetdata(a);
y = b.getdata;

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Res
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Res'); 

r = 100; %minimal frequency resolution

a = mirspectrum(testfile, 'Res', r);
b = sig.spectrum(testfile, 'Res', r, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Length
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Length'); 

l = 8; %if length is not a power of 2, the FFT routine will not be used

a = mirspectrum(testfile, 'Length', l);
b = sig.spectrum(testfile, 'Length', l, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with ZeroPad
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with ZeroPad'); 

s = 4;%zero padding of s samples

a = mirspectrum(testfile, 'ZeroPad', s);
b = sig.spectrum(testfile, 'ZeroPad', s, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with WarningRes
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with WarningRes'); 

mr = 500;%required frequency resolution in Hz

a = mirspectrum(testfile, 'WarningRes', mr);
b = sig.spectrum(testfile, 'WarningRes', mr, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end



%% testing migration: mirspectrum with sig.spectrum with ConstantQ
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with ConstantQ'); 

nb = 12; %default nb = 12 bins per octave

a = mirspectrum(testfile, 'ConstantQ', nb);
b = sig.spectrum(testfile, 'ConstantQ', nb, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with Normal
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Normal'); 

a = mirspectrum(testfile, 'Normal');
b = sig.spectrum(testfile, 'Normal', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with NormalLength
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with NormalLength'); 

a = mirspectrum(testfile, 'NormalLength');
b = sig.spectrum(testfile, 'NormalLength', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Power
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Power'); 

a = mirspectrum(testfile, 'Power');
b = sig.spectrum(testfile, 'Power', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with dB
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with dB'); 

a = mirspectrum(testfile, 'dB');
b = sig.spectrum(testfile, 'dB', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Smooth
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Smooth'); 

o = 10; %moving average order (default = 10)

a = mirspectrum(testfile, 'Smooth', o);
b = sig.spectrum(testfile, 'Smooth',o, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);


if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with Gauss
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Gauss'); 

o = 10; %gaussian of SD (default = 10)

a = mirspectrum(testfile, 'Gauss', o);
b = sig.spectrum(testfile, 'Gauss',o, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with TimeSmooth
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with TimeSmooth'); 

o = 10; %moving average order (default = 10)

a = mirspectrum(testfile, 'TimeSmooth', o);
b = sig.spectrum(testfile, 'TimeSmooth',o, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

x = mirgetdata(a);
y = b.getdata;
z = [x,y,abs(x-y)];


if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Prod
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Prod'); 

m = 1:6; %list of factors (default m = 1:6)

a = mirspectrum(testfile, 'Prod', m);
b = sig.spectrum(testfile, 'Prod',m, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with Sum
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Sum'); 

m = 1:6; %list of factors (default m = 1:6)

a = mirspectrum(testfile, 'Sum', m);
b = sig.spectrum(testfile, 'Sum',m, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n'); 
   debugFail(x,y);
end


