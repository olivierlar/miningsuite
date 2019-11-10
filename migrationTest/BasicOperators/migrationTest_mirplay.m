testfile = 'ragtime.wav'


%% testing migration: mirplay(miraudio(...)) -> sig.play(sig.signal(...))
clearvars -except testfile ;

disp('testing migration: mirplay(miraudio(...)) -> sig.play(sig.signal(...))'); 




a = miraudio(testfile);
b = sig.signal(testfile, 'Mix');

m = mirplay(a);
n = sig.play(b);

x = mirgetdata(m);
y = n.getdata;


tf = isequal(mirgetdata(m),n.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


