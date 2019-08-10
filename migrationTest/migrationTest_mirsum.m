
testfile = 'ragtime.wav'

%% testing migration: mirsum(mirenvelope(mirfilterbank(...))) -> sig.sum(sig.envelope(sig.filterbank(...)))
clearvars -except testfile ;
disp('testing migration: mirsum(mirenvelope(mirfilterbank(...))) -> sig.sum(sig.envelope(sig.filterbank(...)))'); 


f1 = mirfilterbank(testfile);
f2 = aud.filterbank(testfile, 'Mix');


e1 = squeeze(mirenvelope(f1));
e2 = sig.envelope(f2);


a = mirsum(e1);
b = sig.sum(e2);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirsum(mirenvelope(mirfilterbank(...)), 'Mean') -> sig.sum(sig.envelope(sig.filterbank(...)), 'Mean')
clearvars -except testfile ;
disp('testing migration: mirsum(mirenvelope(mirfilterbank(...)), ''Mean'') -> sig.sum(sig.envelope(sig.filterbank(...)), ''Mean'')'); 


f1 = mirfilterbank(testfile);
f2 = aud.filterbank(testfile, 'Mix');

e1 = mirenvelope(f1);
e2 = sig.envelope(f2);

a = mirsum(e1, 'Mean');
b = sig.sum(e2, 'Mean');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirsum(mirenvelope(mirautocor(...)), 'Mean') -> sig.sum(sig.envelope(sig.autocor(...)), 'Mean')
clearvars -except testfile ;
disp('testing migration: mirsum(mirenvelope(mirfilterbank(...)), ''Mean'') -> sig.sum(sig.envelope(sig.filterbank(...)), ''Mean'')'); 


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
   fprintf(2,'test fail!\n');
end

