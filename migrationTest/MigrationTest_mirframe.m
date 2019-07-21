
testfile = 'ragtime.wav'

%% testing migration: mirframe with sig.frame in framesize and in seconds
clearvars -except testfile ;

disp('testing migration: mirframe with sig.frame in framesize and in seconds'); 

w = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = 's';

a = mirframe(testfile, 'Length', w, wu);
b = sig.frame(testfile, 'FrameSize', w, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirframe with sig.frame in framesize and in no of samples
% clearvars -except testfile ;
%
% disp('testing migration: mirframe with sig.frame in framesize and in no of samples'); 
% 
% w = 0.5; %%length of the window in seconds (default 0.05 seconds)
% wu = 'sp';
% 
% a = mirframe(testfile, 'Length', w, wu);
% b = sig.frame(testfile, 'FrameSize', w, wu,'Mix');
% 
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    disp('test fail!');
% end


%% testing migration: mirframe with sig.frame in Hop and in seconds
clearvars -except testfile ;

disp('testing migration: mirframe with sig.frame in Hop and in seconds'); 

h = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = 's';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end




%% testing migration: mirframe with sig.frame in Hop and in no of samples
clearvars -except testfile ;

disp('testing migration: mirframe with sig.frame in Hop and in no of hops'); 

h = ; %%length of the window in seconds (default 0.05 seconds)
wu = 'sp';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirframe with sig.frame in Hop and in percent
clearvars -except testfile ;

disp('testing migration: mirframe with sig.frame in Hop and in percent'); 

h = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = '%';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirframe with sig.frame in Hop and in Hz
clearvars -except testfile ;

disp('testing migration: mirframe with sig.frame in Hop and in Hz'); 

h = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = 'Hz';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirframe with sig.frame in Hop and in ratio
clearvars -except testfile ;

disp('testing migration: mirframe with sig.frame in Hop and in ratio'); 

h = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = '/1';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
