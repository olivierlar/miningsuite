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
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Window
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Window'); 

w = 0; %windowing function (default = 'hanning')


a = mirspectrum(testfile, 'Window', w);
b = sig.spectrum(testfile, 'Window', w, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Phase
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Phase'); 


a = mirspectrum(testfile);
b = sig.spectrum(testfile,'Mix','Phase'); 
x = get(a,'Phase'); 
x = x{1}{1};
y = get(b,'Phase'); 
y = y.content;
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
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
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with MinRes with OctaveRatio
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with MinRes with OctaveRatio'); 

r = 2; %minimal frequency resolution
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
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Res
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Res'); 

r = 2; % frequency resolution

a = mirspectrum(testfile, 'Res', r);
b = sig.spectrum(testfile, 'Res', r, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with Length
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with Length'); 

l = 2000; %if length is not a power of 2, the FFT routine will not be used

a = mirspectrum(testfile, 'Length', l);
b = sig.spectrum(testfile, 'Length', l, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with ZeroPad
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with ZeroPad'); 

s = 100;%zero padding of s samples

a = mirspectrum(testfile, 'ZeroPad', s);
b = sig.spectrum(testfile, 'ZeroPad', s, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end


%% testing migration: mirspectrum with sig.spectrum with WarningRes
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with WarningRes'); 

mr = .1;%required frequency resolution in Hz

a = mirspectrum(testfile, 'WarningRes', mr);
b = sig.spectrum(testfile, 'WarningRes', mr, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
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
   debugFail(x,y);
end


%% testing migration: mirspectrum with aud.spectrum with Terhardt
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Terhardt'); 

a = mirspectrum(testfile, 'Terhardt');
b = aud.spectrum(testfile, 'Terhardt', 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
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
   debugFail(x,y);
end

%% testing migration: mirspectrum with mus.spectrum with ToiviainenSnyder
clearvars -except testfile ;
disp('testing migration: mirspectrum with mus.spectrum with ToiviainenSnyder'); 

sa = mirenvelope(testfile);
a = mirspectrum(sa, 'Resonance', 'ToiviainenSnyder');
sb = sig.envelope(testfile, 'Mix');
b = mus.spectrum(sb, 'Resonance', 'ToiviainenSnyder');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end

%% testing migration: mirspectrum with mus.spectrum with Fluctuation
clearvars -except testfile ;
disp('testing migration: mirspectrum with mus.spectrum with Fluctuation'); 

sa = mirenvelope(testfile);
a = mirspectrum(sa, 'Resonance', 'Fluctuation');
sb = sig.envelope(testfile, 'Mix');
b = mus.spectrum(sb, 'Resonance', 'Fluctuation');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
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
   debugFail(x,y);
end

%% testing migration: mirspectrum with sig.spectrum with TimeSmooth
clearvars -except testfile ;
disp('testing migration: mirspectrum with sig.spectrum with TimeSmooth'); 

o = 10; %moving average order (default = 10)

a = mirspectrum(testfile, 'Frame', 'TimeSmooth', o);
b = sig.spectrum(testfile, 'Frame', 'TimeSmooth', o, 'Mix');
x = mirgetdata(a); 
y = b.getdata; 
tf = isequal(x,y);

x = mirgetdata(a);
y = b.getdata;
z = [x,y,abs(x-y)];


if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end

%% testing migration: mirspectrum with aud.spectrum with Cents
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Cents'); 

a = mirspectrum(testfile, 'Cents');
b = mus.spectrum(testfile, 'Cents', 'Mix');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end

%% testing migration: mirspectrum with aud.spectrum with Collapsed
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Collapsed'); 

a = mirspectrum(testfile, 'Collapsed');
b = mus.spectrum(testfile, 'Collapsed', 'Mix');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end




%% testing migration: mirspectrum with aud.spectrum with Mel
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Mel'); 

a = mirspectrum(testfile, 'Mel');
b = aud.spectrum(testfile, 'Mel', 'Mix');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end



%% testing migration: mirspectrum with aud.spectrum with Bands
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Bands'); 

b = 40;

a = mirspectrum(testfile, 'Bands',b);
b = aud.spectrum(testfile, 'Bands', b, 'Mix');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end


%% testing migration: mirspectrum with aud.spectrum with Mel and AlongBands
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Mel and AlongBands'); 

sa = mirspectrum(testfile, 'Mel', 'Frame');
a = mirspectrum(sa, 'AlongBands');
sb = aud.spectrum(testfile, 'Mel', 'Frame', 'Mix');
b = aud.spectrum(sb, 'AlongBands');
x = squeeze(mirgetdata(a)); 
y = b.getdata;
y = y';
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end


%% testing migration: mirspectrum with aud.spectrum with Bark
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Bark'); 

a = mirspectrum(testfile, 'Bark');
b = aud.spectrum(testfile, 'Bark', 'Mix');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end

%% testing migration: mirspectrum with aud.spectrum with Mask
clearvars -except testfile ;
disp('testing migration: mirspectrum with aud.spectrum with Mask'); 

a = mirspectrum(testfile, 'Mask');
b = aud.spectrum(testfile, 'Mask', 'Mix');
x = squeeze(mirgetdata(a)); 
y = b.getdata; 
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
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
   debugFail(x,y);
end


