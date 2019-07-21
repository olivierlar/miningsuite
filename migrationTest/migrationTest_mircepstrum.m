testfile = 'ragtime.wav'

%% testing migration: mircepstrum with sig.cepstrum with Frame
clearvars -except testfile ;
disp('testing migration: mircepstrum with sig.cepstrum with Frame'); 

a = mircepstrum(testfile, 'Frame');
b = sig.cepstrum(testfile, 'Frame', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: mircepstrum with sig.cepstrum with Freq
clearvars -except testfile ;
disp('testing migration: mircepstrum with sig.cepstrum with Freq'); 

a = mircepstrum(testfile, 'Freq');
b = sig.cepstrum(testfile, 'Freq', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end




%% testing migration: mircepstrum with sig.cepstrum with Min
clearvars -except testfile ;
disp('testing migration: mircepstrum with sig.cepstrum with Min'); 

min = 1000; %minimum frequency 

a = mircepstrum(testfile, 'Min', min);
b = sig.cepstrum(testfile, 'Min', min, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: mircepstrum with sig.cepstrum with Max
clearvars -except testfile ;
disp('testing migration: mircepstrum with sig.cepstrum with Max'); 

max = 1000; %maximum frequency 

a = mircepstrum(testfile, 'Max', max);
b = sig.cepstrum(testfile, 'Max', max, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mircepstrum with sig.cepstrum with Complex
clearvars -except testfile ;
disp('testing migration: mircepstrum with sig.cepstrum with Complex'); 

a = mircepstrum(testfile, 'Complex');
b = sig.cepstrum(testfile, 'Complex', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

