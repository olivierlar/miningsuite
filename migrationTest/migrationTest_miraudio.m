
testfile = 'ragtime.wav'


%% testing migration: miraudio(...) -> sig.signal(...)
clearvars -except testfile ;

disp('testing migration: miraudio(...) -> sig.signal(...)'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 

else
   disp('test fail!');
end


%% testing migration: miraudio (..., 'Mono') with sig.signal (...)
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Mono'') with sig.signal (..., ''Mix'')'); 
a = miraudio(testfile, 'Mono',0);
b = sig.signal(testfile);
da = squeeze(mirgetdata(a));
db = b.getdata;
tf = isequal(da,db);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: miraudio (..., 'Center') with sig.signal (..., 'Center')
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Center'') with sig.signal (..., ''Center)'''); 
a = miraudio(testfile, 'Center');
b = sig.signal(testfile, 'Center','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: miraudio (..., 'Sampling', r) with sig.signal (..., 'Sampling', r)
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Sampling'',r) with sig.signal (..., ''Sampling'',r)'); 
samplingRate = 10000;
a = miraudio(testfile, 'Sampling', samplingRate);
b = sig.signal(testfile, 'Sampling', samplingRate,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: miraudio (..., 'FWR') with sig.signal (..., 'FWR')
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''FWR'') with sig.signal (..., ''FWR'')'); 
a = miraudio(testfile, 'FWR');
b = sig.signal(testfile, 'FWR','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: miraudio (..., 'Frame',..) with sig.signal (..., 'Frame', ...)
%seconds
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Frame'',...) with sig.signal (..., ''Frame'',...)'); 

w = 'FrameLength';
wu = 2;
h = 'FrameHop';
hu = .5;

a = miraudio(testfile, 'Frame',wu,hu);
b = sig.signal(testfile, 'Frame',w,wu,h,hu,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: miraudio (..., 'Extract',t1,t2,'s') with sig.signal (..., 'Extract',t1,t2,'s')
%sampling index
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Extract'',t1,t2,''s'') with sig.signal (..., ''Extract'',t1,t2,''s'')'); 
t1 = 0;
t2 = 88200;
u = 's';
a = miraudio(testfile, 'Extract', t1,t2,u);
b = sig.signal(testfile, 'Extract',  t1,t2,u,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: miraudio (..., 'Extract',t1,t2,'sp') with sig.signal (..., 'Extract',t1,t2,'sp')
%sampling index
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Extract'',t1,t2,''sp'') with sig.signal (..., ''Extract'',t1,t2,''sp'')'); 
t1 = 0;
t2 = 88200;
u = 'sp';
a = miraudio(testfile, 'Extract', t1,t2,u);
b = sig.signal(testfile, 'Extract',  t1,t2,u,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: miraudio (..., 'Trim') with sig.signal (..., 'Trim')
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Trim'') with sig.signal (..., ''Trim'')'); 
a = miraudio(testfile, 'Trim');
b = sig.signal(testfile, 'Trim','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: miraudio (..., 'Trim','TrimThreshold', t) with sig.signal (...,'Trim', 'TrimThreshold',t )
clearvars -except testfile ;

disp('testing migration: miraudio (...,''Trim'', ''TrimThreshold'', t) with sig.signal (..., ''Trim'',''TrimThreshold'', t)'); 
t = 0.03;
a = miraudio(testfile,'Trim', 'TrimThreshold', t);
b = sig.signal(testfile,'Trim', 'TrimThreshold', t,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: miraudio (..., 'Trim', 'TrimStart') -> sig.signal (..., 'Trim', 'JustStart')
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Trim'', ''TrimStart'') -> sig.signal (..., ''Trim'', ''JustStart'')'); 
t = 0.06;
a = miraudio(testfile, 'Trim', 'TrimStart');
b = sig.signal(testfile, 'Trim', 'JustStart','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: miraudio (..., 'Trim', 'TrimStart') -> sig.signal (..., 'Trim', 'JustEnd')
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Trim'', ''TrimStart'') -> sig.signal (..., ''Trim'', ''JustEnd'')'); 
t = 0.06;
a = miraudio(testfile, 'Trim', 'TrimEnd');
b = sig.signal(testfile, 'Trim', 'JustEnd','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: miraudio (..., 'Channel', c) with sig.signal (..., 'Channel',c)
clearvars -except testfile ;

disp('testing migration: miraudio (..., ''Channel'',c) with sig.signal (..., ''Channel'',c)'); 

c = 1; %channel selection by integer;

a = miraudio(testfile, 'Channel',c);
b = sig.signal(testfile, 'Channel',c,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

