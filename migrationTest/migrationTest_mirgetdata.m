
testfile = 'ragtime.wav'


%% testing migration: mirgetdata with obj.getdata
clearvars -except testfile ;

disp('testing migration: mirgetdata with obj.getdata'); 
a = miraudio(testfile);
b = sig.signal(testfile,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 

else
   disp('test fail!');
end


%% testing migration: mirgetdata (Mono) with obj.getdata (Mix)
clearvars -except testfile ;

disp('testing migration: mirgetdata (Mono) with obj.getdata (Mix)'); 
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

%% testing migration: mirgetdata (Center) with obj.getdata (Center)
clearvars -except testfile ;

disp('testing migration: mirgetdata (Center) with obj.getdata (Center)'); 
a = miraudio(testfile, 'Center');
b = sig.signal(testfile, 'Center','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mirgetdata (Sampling) with obj.getdata (Sampling)
clearvars -except testfile ;

disp('testing migration: mirgetdata (Sampling) with obj.getdata (Sampling)'); 
samplingRate = 10000;
a = miraudio(testfile, 'Sampling', samplingRate);
b = sig.signal(testfile, 'Sampling', samplingRate,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mirgetdata (Extract) with obj.getdata (Extract) by
%seconds
clearvars -except testfile ;

disp('testing migration: mirgetdata (center) with obj.getdata (center)'); 
t1 = 0;
t2 = 2;
u = 's';
a = miraudio(testfile, 'Extract', t1,t2,u);
b = sig.signal(testfile, 'Extract',  t1,t2,u,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirgetdata (Extract) with obj.getdata (Extract)by
%sampling index
clearvars -except testfile ;

disp('testing migration: mirgetdata (Extract) with obj.getdata (Extract) by index'); 
t1 = 0;
t2 = 2;
u = 'sp';
a = miraudio(testfile, 'Extract', t1,t2,u);
b = sig.signal(testfile, 'Extract',  t1,t2,u,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: mirgetdata (Trim) with obj.getdata (Trim)
clearvars -except testfile ;

disp('testing migration: mirgetdata (Trim) with obj.getdata (Trim)'); 
a = miraudio(testfile, 'Trim');
b = sig.signal(testfile, 'Trim','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)
clearvars -except testfile ;

disp('testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)'); 
t = 0.06;
a = miraudio(testfile, 'TrimThreshold', t);
b = sig.signal(testfile, 'TrimThreshold', t,'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% >>>> INCOMPLETE: need to find out if TrimStart in miraudio is same as JustStart in sig.signal
% also, if the parameter 'Trim' is required before 'JustStart' in sig.signal
%testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)
clearvars -except testfile ;

disp('testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)'); 
t = 0.06;
a = miraudio(testfile, 'TrimStart');
b = sig.signal(testfile, 'Trim', 'JustStart','Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
