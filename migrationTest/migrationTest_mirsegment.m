
testfile = 'ragtime.wav'


%% testing mirsegment: miraudio(...) -> sig.segment(...)
clearvars -except testfile ;

disp('testing migration: miraudio(...) -> sig.signal(...)'); 
a = mirsegment(testfile);
b = sig.segment(testfile,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   disp('test OK!'); 

else
   fprintf(2,'test fail!\n');
end