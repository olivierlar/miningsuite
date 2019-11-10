
testfile = 'ragtime.wav'


%% testing mirsegment: mirsegment(...) -> sig.segment(...)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(...) -> sig.segment(...)</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

m = mirsegment(a);
n = sig.segment(b );


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   cprintf('*red', 'test FAIL!\n');
end

%% testing mirsegment: mirsegment(... , p) -> sig.segment(... , p)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., p) -> sig.segment(..., p)</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

p1 = mirpeaks(testfile);
p2 = sig.peaks(testfile, 'Mix');

m = mirsegment(a,p1);
n = sig.segment(b, p2);


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   cprintf('*red', 'test FAIL!\n');
end

%% testing mirsegment: mirsegment(... , v) -> sig.segment(... , v)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., v) -> sig.segment(..., v)</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

v = 5;

m = mirsegment(a,v);
n = sig.segment(b, v);


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   cprintf('*red', 'test FAIL!\n');
end

%% testing mirsegment: mirsegment(... , 'Novelty') -> sig.segment(... , 'Novelty')
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., ''Novelty'') -> sig.segment(..., ''Novelty'')</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

m = mirsegment(a,'Novelty');
n = sig.segment(b, 'Novelty');


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   cprintf('*red', 'test FAIL!\n');
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
%    cprintf('*red', 'test FAIL!\n');
% end


%% testing mirsegment: mirsegment(... , 'RMS') -> sig.segment(... , 'RMS')
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., ''RMS'') -> sig.segment(..., ''RMS'')</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

m = mirsegment(a,'RMS');
n = sig.segment(b, 'RMS');


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end
