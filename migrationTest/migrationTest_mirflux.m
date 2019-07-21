testfile = 'ragtime.wav'


%% testing migration: mirflux with sigflux on mirspectrum and sig.spectrum
clearvars -except testfile ;
disp('testing migration: mirflux with sigflux on mirspectrum and sig.spectrum'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');


a = mirflux(s1);
b = sig.flux(s2);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: mirflux with sigflux on mircepstrum and sig.cepstrum
% clearvars -except testfile ;
% disp('testing migration: mirflux with sigflux on mircepstrum and sig.cepstrum'); 
% 
% s1 = mircepstrum(testfile, 'Frame');
% s2 = sig.cepstrum (testfile, 'Frame', 'Mix');
% 
% 
% a = mirflux(s1);
% b = sig.flux(s2);
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    disp('test fail!');
% end


%% testing migration: mirflux with sigflux with Dist
clearvars -except testfile ;
disp('testing migration: mirflux with sigflux with Dist'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');

d = 'Euclidean';

a = mirflux(s1, 'Dist', d);
b = sig.flux(s2, 'Dist', d);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mirflux with sigflux with Inc
clearvars -except testfile ;
disp('testing migration: mirflux with sigflux with Inc'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');


a = mirflux(s1, 'Inc');
b = sig.flux(s2, 'Inc');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mirflux with sigflux with Complex
clearvars -except testfile ;
disp('testing migration: mirflux with sigflux with Complex'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');


a = mirflux(s1, 'Complex');
b = sig.flux(s2, 'Complex');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


