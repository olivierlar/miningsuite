
testfile = 'ragtime.wav'

%% testing migration: mirsum with sig.sum on summation of filterbank channels
clearvars -except testfile ;
disp('testing migration:  mirsum with sig.sum on filterbank channels'); 


f1 = mirfilterbank(testfile);
f2 = sig.filterbank(testfile, 'Mix');

e1 = mirenvelope(f1);
e2 = sig.envelope(f2);

a = mirsum(e1);
b = sig.sum(e2);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirsum with sig.sum on summation of filterbank channels with Mean 
clearvars -except testfile ;
disp('testing migration:  mirsum with sig.sum on filterbank channels with Mean'); 


f1 = mirfilterbank(testfile);
f2 = sig.filterbank(testfile, 'Mix');

e1 = mirenvelope(f1);
e2 = sig.envelope(f2);

a = mirsum(e1, 'Mean');
b = sig.sum(e2, 'Mean');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: mirsum with sig.sum on Summary of filterbank channels
clearvars -except testfile ;
disp('testing migration:  mirsum with sig.sum on filterbank channels with Mean'); 


f1 = mirautocor(testfile);
f2 = sig.autocor(testfile, 'Mix');

e1 = mirenvelope(f1);
e2 = sig.envelope(f2);

a = mirsum(e1, 'Mean');
b = sig.sum(e2, 'Mean');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

