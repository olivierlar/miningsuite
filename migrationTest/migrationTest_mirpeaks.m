
testfile = 'ragtime.wav'

%% testing migration: mirpeaks(...) -> sig.peaks(...)
clearvars -except testfile ;
disp('testing migration: mirpeaks(...) -> sig.peaks(...)'); 

a = mirpeaks(testfile);
b = sig.peaks (testfile, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Total', m) -> sig.peaks(..., 'Total', m)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Total'', m) -> sig.peaks(..., ''Total'', m)'); 

m = 100; %total number of peaks (default is infinite)

a = mirpeaks(testfile, 'Total', m);
b = sig.peaks (testfile, 'Total', m, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Total', m, 'NoBegin') -> sig.peaks(..., 'Total', m, 'NoBegin')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Total'', m, ''NoBegin'') -> sig.peaks(..., ''Total'', m, ''NoBegin'')'); 

m = 100; %total number of peaks (default is infinite)

a = mirpeaks(testfile, 'Total', m,'NoBegin');
b = sig.peaks (testfile, 'Total', m, 'NoBegin', 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Total', m, 'NoEnd') -> sig.peaks(..., 'Total', m, 'NoEnd')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Total'', m, ''NoEnd'') -> sig.peaks(..., ''Total'', m, ''NoEnd'')'); 

m = 100; %total number of peaks (default is infinite)

a = mirpeaks(testfile, 'Total', m,'NoEnd');
b = sig.peaks (testfile, 'Total', m, 'NoEnd', 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Order', 'Amplitude') -> sig.peaks(..., 'Order', 'Amplitude')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Order'', ''Amplitude'') -> sig.peaks(..., ''Order'', ''Amplitude'')'); 

o = 'Amplitude';

a = mirpeaks(testfile, 'Order', o);
b = sig.peaks (testfile, 'Order', o, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Order', 'Abscissa') -> sig.peaks(..., 'Order', 'Abscissa')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Order'', ''Abscissa'') -> sig.peaks(..., ''Order'', ''Abscissa'')'); 

o = 'Abscissa';

a = mirpeaks(testfile, 'Order', o);
b = sig.peaks (testfile, 'Order', o, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Valleys') -> sig.peaks(..., 'Valleys')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Valleys'') -> sig.peaks(..., ''Valleys'')'); 

a = mirpeaks(testfile, 'Valleys');
b = sig.peaks (testfile, 'Valleys', 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Contrast', cthr) -> sig.peaks(..., 'Contrast', cthr)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Contrast'', cthr) -> sig.peaks(..., ''Contrast'', cthr)'); 

cthr = 0.1; %(default cthr = 0.1)

a = mirpeaks(testfile, 'Contrast', cthr);
b = sig.peaks (testfile, 'Contrast', cthr, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'SelectFirst', fthr) -> sig.peaks(..., 'SelectFirst', fthr)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''SelectFirst'', fthr) -> sig.peaks(..., ''SelectFirst'', fthr)'); 

fthr = 0.1/2; %(default fthr = cthr/2)

a = mirpeaks(testfile, 'SelectFirst', fthr);
b = sig.peaks (testfile, 'SelectFirst', fthr, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end



%% testing migration: mirpeaks(..., 'Contrast', cthr, 'SelectFirst', fthr) -> sig.peaks(..., 'Contrast', cthr, 'SelectFirst', fthr)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Contrast'', cthr,''SelectFirst'', fthr) -> sig.peaks(..., ''Contrast'', cthr, ''SelectFirst'', fthr)'); 

cthr = 0.1; %(default cthr = 0.1)
fthr = cthr/2; %(default fthr = cthr/2)

a = mirpeaks(testfile, 'Contrast', cthr, 'SelectFirst', fthr);
b = sig.peaks (testfile, 'Contrast', cthr, 'SelectFirst', fthr, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Threshold', thr) -> sig.peaks(..., 'Threshold', thr)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Threshold'', thr) -> sig.peaks(..., ''Threshold'', thr)'); 

thr = 0; %(default = 0 for peaks and 1 for valleys)

a = mirpeaks(testfile, 'Threshold', thr);
b = sig.peaks (testfile, 'Threshold', thr, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Valleys'. 'Threshold', thr) -> sig.peaks(...,'Valleys', 'Threshold', thr)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Valleys'',''Threshold'', thr) -> sig.peaks(..., ''Valleys'',''Threshold'', thr)'); 

thr = 1; %(default = 0 for peaks and 1 for valleys)

a = mirpeaks(testfile,'Valleys', 'Threshold', thr);
b = sig.peaks (testfile,'Valleys', 'Threshold', thr, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Interpol', 'no') -> sig.peaks(..., 'Interpol', 'no')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Interpol'',''no'') -> sig.peaks(..., ''Interpol'', ''no'')'); 

i= 'no';

a = mirpeaks(testfile, 'Interpol', i);
b = sig.peaks (testfile, 'Interpol', i, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Interpol', 'Quadratic') -> sig.peaks(..., 'Interpol', 'Quadratic')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Interpol'',''Quadratic'') -> sig.peaks(..., ''Interpol'', ''Quadratic'')'); 

i= 'Quadratic';

a = mirpeaks(testfile, 'Interpol', i);
b = sig.peaks (testfile, 'Interpol', i, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirpeaks(..., 'Reso', r ) -> sig.peaks(..., 'Reso',r)
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Reso'',r) -> sig.peaks(..., ''Reso'',r)'); 

r= 1;

a = mirpeaks(testfile, 'Reso', r);
b = sig.peaks (testfile, 'Reso', r, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Reso', r, 'First') -> sig.peaks(..., 'Reso',r,'First')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Reso'',r, ''First'') -> sig.peaks(..., ''Reso'',r, ''First'')'); 

r= 1;

a = mirpeaks(testfile, 'Reso', r,'First');
b = sig.peaks (testfile, 'Reso', r, 'First', 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Normalize', 'Global' ) -> sig.peaks(..., 'Normalize','Global')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Normalize'',''Global'') -> sig.peaks(..., ''Normalize'', ''Global'')'); 

n= 'Global';

a = mirpeaks(testfile, 'Normalize', n);
b = sig.peaks (testfile, 'Normalize', n, 'Mix');


m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirpeaks(..., 'Normalize', 'Local' ) -> sig.peaks(..., 'Normalize','Local')
clearvars -except testfile ;
disp('testing migration: mirpeaks(..., ''Normalize'',''Local'') -> sig.peaks(..., ''Normalize'', ''Local'')'); 

n= 'Local';

a = mirpeaks(testfile, 'Normalize', n);
b = sig.peaks (testfile, 'Normalize', n, 'Mix');

m = get(a, 'PeakPos');
n = get(b, 'PeakIndex');

x = m{1,1}{1,1}{1,1};
y = n.content{1,1};

tf = isequal(x,y);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end