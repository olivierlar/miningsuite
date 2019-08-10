testfile = 'ragtime.wav'


%% testing migration: mirautocor with sig.autocor with Frame
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor'); 

a = mirautocor(testfile, 'Frame');
b = sig.autocor(testfile, 'Frame', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);



%x = (mirgetdata(a));
%y = (b.getdata);



if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');

   sizeTest = migrationTestUtility_dimensionTest(mirgetdata(a),b.getdata);
   
   if  sizeTest == 1
       disp('dimension OK');
   else
       disp('dimension fail');
   end
   

   
end


%% testing migration: mirautocor with sig.autocor with Min
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Min'); 

mi = 0.01;

a = mirautocor(testfile, 'Min', mi);
b = sig.autocor(testfile, 'Min', mi, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirautocor with sig.autocor with Min 's'
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Min ''s'' '); 

mi = 0.01;

a = mirautocor(testfile, 'Min', mi, 's');
b = sig.autocor(testfile, 'Min', mi, 's', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirautocor with sig.autocor with Min 'Hz'
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Min ''Hz'' '); 

mi = 0.00;

a = mirautocor(testfile, 'Min', mi, 'Hz');
b = sig.autocor(testfile, 'Min', mi, 'Hz', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirautocor with sig.autocor with Max
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Max'); 

ma = 0.05; %default ma = 0.05 corresponding to 20 Hz

a = mirautocor(testfile, 'Max', ma);
b = sig.autocor(testfile, 'Max', ma, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end



%% testing migration: mirautocor with sig.autocor with Normal biased
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal biased'); 

n = 'biased';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end



%% testing migration: mirautocor with sig.autocor with Normal unbiased
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal unbiased'); 

n = 'unbiased';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirautocor with sig.autocor with Normal coeff
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal coeff'); 

n = 'coeff';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirautocor with sig.autocor with Normal none
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal none'); 

n = 'none';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end



%% testing migration: mirautocor with sig.autocor with Normal Freq
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal Freq'); 

a = mirautocor(testfile, 'Freq');
b = sig.autocor(testfile, 'Freq', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirautocor with sig.autocor with NormalWindow
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with NormalWindow'); 

w = 'hanning';

a = mirautocor(testfile, 'NormalWindow', w );
b = sig.autocor(testfile, 'NormalWindow', w, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirautocor with sig.autocor with NormalWindow off
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with NormalWindow off'); 

w = 'off';

a = mirautocor(testfile, 'NormalWindow', w );
b = sig.autocor(testfile, 'NormalWindow', w, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirautocor with sig.autocor with Halfwave
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Halfwave'); 

a = mirautocor(testfile, 'Halfwave');
b = sig.autocor(testfile, 'Halfwave', 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end


%% testing migration: mirautocor with sig.autocor with Compres
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Compres'); 

k = 0.67;

a = mirautocor(testfile, 'Compres', k);
b = sig.autocor(testfile, 'Compres', k,  'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   fprintf(2,'test fail!\n');
end

%% testing migration: mirautocor with sig.autocor with Enhanced
% clearvars -except testfile ;
% disp('testing migration: mirautocor with sig.autocor with Enhanced'); 
% 
% a = 2:10;
% 
% a = mirautocor(testfile, 'Enhanced', a);
% b = sig.autocor(testfile, 'Enhanced', a,  'Mix');
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    fprintf(2,'test fail!\n');
% end
% 

