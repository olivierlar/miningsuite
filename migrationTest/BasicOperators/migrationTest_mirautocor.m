testfile = 'ragtime.wav'


%% testing migration: mirautocor with sig.autocor with Frame
clearvars -except testfile ;
disp('<strong> testing migration: mirautocor with sig.autocor </strong>'); 

a = (mirautocor(testfile, 'Frame'));
b = sig.autocor(testfile, 'Frame', 'Mix');

x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   

   debugFail(x,y);

end


%% testing migration: mirautocor with sig.autocor with Min
clearvars -except testfile ;
disp('<strong>testing migration: mirautocor with sig.autocor with Min </strong>'); 

mi = 0.01;

a = mirautocor(testfile, 'Min', mi);
b = sig.autocor(testfile, 'Min', mi, 'Mix');

x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
  debugFail(x,y);
end

%% testing migration: mirautocor with sig.autocor with Min 's'
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Min ''s'' '); 

mi = 0.01;

a = mirautocor(testfile, 'Min', mi, 's');
b = sig.autocor(testfile, 'Min', mi, 's', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end


%% testing migration: mirautocor with sig.autocor with Min 'Hz'
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Min ''Hz'' '); 

mi = 0.00;

a = mirautocor(testfile, 'Min', mi, 'Hz');
b = sig.autocor(testfile, 'Min', mi, 'Hz', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end

%% testing migration: mirautocor with sig.autocor with Max
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Max'); 

ma = 0.05; %default ma = 0.05 corresponding to 20 Hz

a = mirautocor(testfile, 'Max', ma);
b = sig.autocor(testfile, 'Max', ma, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end



%% testing migration: mirautocor with sig.autocor with Normal biased
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal biased'); 

n = 'biased';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end



%% testing migration: mirautocor with sig.autocor with Normal unbiased
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal unbiased'); 

n = 'unbiased';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end


%% testing migration: mirautocor with sig.autocor with Normal coeff
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal coeff'); 

n = 'coeff';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end

%% testing migration: mirautocor with sig.autocor with Normal none
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal none'); 

n = 'none';

a = mirautocor(testfile, n);
b = sig.autocor(testfile, n, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end



%% testing migration: mirautocor with sig.autocor with Normal Freq
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Normal Freq'); 

a = mirautocor(testfile, 'Freq');
b = sig.autocor(testfile, 'Freq', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end


%% testing migration: mirautocor with sig.autocor with NormalWindow
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with NormalWindow'); 

w = 'hanning';

a = mirautocor(testfile, 'NormalWindow', w );
b = sig.autocor(testfile, 'NormalWindow', w, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end

%% testing migration: mirautocor with sig.autocor with NormalWindow off
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with NormalWindow off'); 

w = 'off';

a = mirautocor(testfile, 'NormalWindow', w );
b = sig.autocor(testfile, 'NormalWindow', w, 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end


%% testing migration: mirautocor with sig.autocor with Halfwave
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Halfwave'); 

a = mirautocor(testfile, 'Halfwave');
b = sig.autocor(testfile, 'Halfwave', 'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end


%% testing migration: mirautocor with sig.autocor with Compres
clearvars -except testfile ;
disp('testing migration: mirautocor with sig.autocor with Compres'); 

k = 0.67;

a = mirautocor(testfile, 'Compres', k);
b = sig.autocor(testfile, 'Compres', k,  'Mix');
x = mirgetdata(a);
y = b.getdata;

%tf = isequal(a_round,b_round);
tf = isequal(x,y);
if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   
   debugFail(x,y);
end

%% testing migration: mirautocor with sig.autocor with Enhanced
% clearvars -except testfile ;
% disp('testing migration: mirautocor with sig.autocor with Enhanced'); 
% 
% a = 2:10;
% 
% a = mirautocor(testfile, 'Enhanced', a);
% b = sig.autocor(testfile, 'Enhanced', a,  'Mix');
% x = mirgetdata(a);
% y = b.getdata;

% tf = isequal(a_round,b_round);
% tf = isequal(x,y);
% 
% if tf == 1
%    cprintf('*green', 'test SUCCESS!\n'); 
% else
%    
% end
% 

