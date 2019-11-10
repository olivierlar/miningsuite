
testfile = 'ragtime.wav'

%% testing migration: mirrms(...) -> sig.rms(...)
clearvars -except testfile ;
disp('<strong>mirrms(...) -> sig.rms(...)</strong>'); 


a = mirrms(testfile);
b = sig.rms(testfile,'Mix');

x = mirgetdata(a);
y = sig.getdata(b);

tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
   debugFail(x,y);
end

