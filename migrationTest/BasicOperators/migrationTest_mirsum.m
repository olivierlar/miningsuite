
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
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
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
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
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


x = mirgetdata(a);
y = b.getdata;


tf = isequal(x,y);


if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end

