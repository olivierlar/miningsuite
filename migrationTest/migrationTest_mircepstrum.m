testfile = 'ragtime.wav'

%% testing migration: mircepstrum (..., 'Frame') -> sig.cepstrum(..., 'Frame')
clearvars -except testfile ;
disp('testing migration: mircepstrum (..., ''Frame'') -> sig.cepstrum(..., ''Frame'')'); 

a = mircepstrum(testfile, 'Frame');
b = sig.cepstrum(testfile, 'Frame', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

%x = mirgetdata(a);
% y = b.getdata;
% z = [1:338474];
% 
% zSize = 2039 * 166
% 
% for i = 1:338474
%    z(i) = x(i)-y(i);
% end


if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%return;

%% testing migration: mircepstrum (..., 'Freq') -> sig.cepstrum(..., 'Freq')
clearvars -except testfile ;
disp('testing migration: mircepstrum (..., ''Freq'') -> sig.cepstrum(..., ''Freq'')'); 

a = mircepstrum(testfile, 'Freq');
b = sig.cepstrum(testfile, 'Freq', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end




%% testing migration: mircepstrum (..., 'Min', min) -> sig.cepstrum(..., 'Min', min)
clearvars -except testfile ;
disp('testing migration: mircepstrum (..., ''Min'', min) -> sig.cepstrum(..., ''Min'', min)'); 


min = 1000; %minimum frequency 

a = mircepstrum(testfile, 'Min', min);
b = sig.cepstrum(testfile, 'Min', min, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end


%% testing migration: mircepstrum (..., 'Max', max) -> sig.cepstrum(..., 'Max', max)
clearvars -except testfile ;
disp('testing migration: mircepstrum (..., ''Max'', max) -> sig.cepstrum(..., ''Max'', max)'); 

max = 1000; %maximum frequency 

a = mircepstrum(testfile, 'Max', max);
b = sig.cepstrum(testfile, 'Max', max, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

%% testing migration: mircepstrum (..., 'Complex') -> sig.cepstrum(..., 'Complex')
clearvars -except testfile ;
disp('testing migration: mircepstrum (..., ''Complex'') -> sig.cepstrum(..., ''Complex'')'); 


a = mircepstrum(testfile, 'Complex');
b = sig.cepstrum(testfile, 'Complex', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

