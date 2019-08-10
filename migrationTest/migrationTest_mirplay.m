testfile = 'ragtime.wav'


%% testing migration: mirplay(miraudio(...)) -> sig.play(sig.signal(...))
clearvars -except testfile ;

disp('testing migration: mirplay(miraudio(...)) -> sig.play(sig.signal(...))'); 


a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

m = mirplay(a);
n = sig.play(b);

tf = isequal(mirgetdata(m),n.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


