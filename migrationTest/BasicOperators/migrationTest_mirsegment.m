
testfile = 'ragtime.wav'


%% testing mirsegment: mirsegment(...) -> sig.segment(...)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(...) -> sig.segment(...)</strong>'); 
clearvars -except testfile ;

a = miraudio(testfile);
e = mirenvelope(a);
p = mirpeaks(e);
s1 = mirsegment(a,p);

b = sig.signal(testfile,'Mix');
e = sig.envelope(b);
p = sig.peaks(e);
s2 = sig.segment(b,p);

x = get(s1, 'Data');
y = s2.getdata;

tf = isequal(x,y);

x = (mirgetdata(a));
x2 = get(a,'Data');
y = squeeze(b.getdata);


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   debugFail(x,y);
end

return


%%
% using mirpitch



%% testing mirsegment: mirsegment(... , v) -> sig.segment(... , v)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., v) -> sig.segment(..., v)</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

v = 2;

a = mirsegment(a,v);
b = sig.segment(b, v);

% add the test routine here



%% testing mirsegment: mirsegment(... , 'Novelty') -> sig.segment(... , 'Novelty')
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., ''Novelty'') -> sig.segment(..., ''Novelty'')</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

a = mirsegment(a,'Novelty');
b = sig.segment(b, 'Novelty');


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   debugFail(x,y);
end

% %% testing mirsegment: mirsegment(... , 'HCDF') -> sig.segment(... , 'HCDF')
% clearvars -except testfile ;
% 
% disp('<strong>testing migration: miregment(..., ''HCDF'') -> sig.segment(..., ''HCDF'')</strong>'); 
% a = miraudio(testfile);
% b = sig.signal(testfile,'Mix');
% 
% m = mirsegment(a,'HCDF');
% n = sig.segment(b, 'HCDF');
% 
% 
% tf = isequal(mirgetdata(a),b.getdata);
% 
% x = mirgetdata(a);
% y = b.getdata;
% 
% if tf == 1
%    cprintf('*green', 'test SUCCESS!\n'); 
% else
%    debugFail(x,y);
% end


%% testing mirsegment: mirsegment(... , 'RMS') -> sig.segment(... , 'RMS')
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., ''RMS'') -> sig.segment(..., ''RMS'')</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

a = mirsegment(a,'RMS');
b = sig.segment(b, 'RMS');


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   debugFail(x,y);
end
