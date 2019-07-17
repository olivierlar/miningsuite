testfile = 'ragtime.wav'


%% testing migration: mirspectrum with sig.spectrum
clearvars -except testfile ;

disp('testing migration: mirspectrum with sig.spectrum'); 
a = mirspectrum(testfile);
b = sig.spectrum(testfile);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
