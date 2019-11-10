testfile = 'ragtime.wav'

%% testing migration: mircepstrum (..., 'Frame') -> sig.cepstrum(..., 'Frame')
clearvars -except testfile ;
disp('<strong> testing migration: mircepstrum (..., ''Frame'') -> sig.cepstrum(..., ''Frame'')</strong>'); 

a = mircepstrum(testfile, 'Frame');
b = sig.cepstrum(testfile, 'Frame', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
   debugFail(x,y);
end


%% testing migration: mircepstrum (..., 'Freq') -> sig.cepstrum(..., 'Freq')
clearvars -except testfile ;
disp('<strong>testing migration: mircepstrum (..., ''Freq'') -> sig.cepstrum(..., ''Freq'')</strong>'); 

a = mircepstrum(testfile, 'Freq');
b = sig.cepstrum(testfile, 'Freq', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
   debugFail(x,y);
end




%% testing migration: mircepstrum (..., 'Min', min) -> sig.cepstrum(..., 'Min', min)
clearvars -except testfile ;
disp('<strong>testing migration: mircepstrum (..., ''Min'', min) -> sig.cepstrum(..., ''Min'', min)</strong>'); 


min = 100; %minimum frequency 

a = mircepstrum(testfile, 'Min', min);
b = sig.cepstrum(testfile, 'Min', min, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
   debugFail(x,y);
end


%% testing migration: mircepstrum (..., 'Max', max) -> sig.cepstrum(..., 'Max', max)
clearvars -except testfile ;
disp('<strong>testing migration: mircepstrum (..., ''Max'', max) -> sig.cepstrum(..., ''Max'', max)</strong>'); 

max = 1000; %maximum frequency 

a = mircepstrum(testfile, 'Max', max);
b = sig.cepstrum(testfile, 'Max', max, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
   debugFail(x,y);
end

%% testing migration: mircepstrum (..., 'Complex') -> sig.cepstrum(..., 'Complex')
clearvars -except testfile ;
disp('<strong>testing migration: mircepstrum (..., ''Complex'') -> sig.cepstrum(..., ''Complex'')</strong>'); 


a = mircepstrum(testfile, 'Complex');
b = sig.cepstrum(testfile, 'Complex', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
   debugFail(x,y);
end

