
testfile = 'voice.wav'



%%
%
%------------------------------------------------------------------------
%
%
mirgetdata_vs_objgetdata
%mirframe_vs_sigframe
mirfilterbank_vs_sigfilterbank

%% testing migration: mirspectrum with sig.spectrum

disp('testing migration: mirspectrum with sig.spectrum'); 
a = mirspectrum(testfile);
b = sig.spectrum(testfile);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;





