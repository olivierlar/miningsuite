testfile = 'ragtime.wav'


%% testing migration: mirflux(...) -> sig.flux(...)
clearvars -except testfile ;
disp('testing migration: mirflux(...) -> sig.flux(...)'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');


a = mirflux(s1);
b = sig.flux(s2);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirspectrum(..., 'Frame') -> sig.spectrum(..., 'Frame')
%clearvars -except testfile ;
%disp('testing migration: mirflux(..., ''Frame'') -> sig.spectrum(..., ''Frame'')'); 
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
%    cprintf('*green', 'test SUCCESS!\n'); 
% else
%    cprintf('*red', 'test FAIL!\n');
% end


%% testing migration: mirflux(..., 'Dist') -> sig.flux(..., 'Dist')
clearvars -except testfile ;
disp('testing migration: mirflux(..., ''Dist'') -> sig.flux(..., ''Dist'')'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');

d = 'Euclidean';

a = mirflux(s1, 'Dist', d);
b = sig.flux(s2, 'Dist', d);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirflux(..., 'Inc') -> sig.flux(..., 'Inc')
clearvars -except testfile ;
disp('testing migration: mirflux(..., ''Inc'') -> sig.flux(..., ''Inc'')'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');


a = mirflux(s1, 'Inc');
b = sig.flux(s2, 'Inc');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirflux(..., 'Complex') -> sig.flux(..., 'Complex')
clearvars -except testfile ;
disp('testing migration: mirflux(..., ''Complex'') -> sig.flux(..., ''Complex'')'); 

s1 = mirspectrum(testfile, 'Frame');
s2 = sig.spectrum (testfile, 'Frame', 'Mix');


a = mirflux(s1, 'Complex');
b = sig.flux(s2, 'Complex');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


