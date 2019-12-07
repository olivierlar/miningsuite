
testfile = 'ragtime.wav'


%% testing mirsegment: mirsegment(...) -> sig.segment(...)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(...) -> sig.segment(...)</strong>'); 
clearvars -except testfile ;

a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

a = mirsegment(a);
b = sig.segment(b);

x = mirgetdata(a);
%x = get(a, 'Data');
y = b.getdata;

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
%% testing mirsegment: mirsegment(... , p) -> sig.segment(... , p)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., p) -> sig.segment(..., p)</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

p1 = mirpeaks(testfile);
p2 = sig.peaks(testfile, 'Mix');

a = mirsegment(a,p1);
b = sig.segment(b, p2);

x = mirgetdata(a);
y = b.getdata;

tf = isequal(x,y);

x = (mirgetdata(a));
y = squeeze(b.getdata);


col = (size(x));
col = col(1);
row = size(x);
row = row(2);
z = [];
for i = 1:row
    firstNaN = find(isnan( (x(:,i) )));

    if(isempty(firstNaN) == 1 )
       z{i} = x(1:col,i);
    else
        size = firstNaN(1)-1;
        z{i} = x(1:size-1,i);
    end

end

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 

else
   debugFail(x,y);
end


%% testing mirsegment: mirsegment(... , v) -> sig.segment(... , v)
clearvars -except testfile ;

disp('<strong>testing migration: miregment(..., v) -> sig.segment(..., v)</strong>'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');

v = 5;

a = mirsegment(a,v);
b = sig.segment(b, v);


tf = isequal(mirgetdata(a),b.getdata);

x = mirgetdata(a);
y = b.getdata;


if tf == 1
    
   cprintf('*green', 'test SUCCESS!\n'); 

else
   debugFail(x,y);
end

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
