
testfile = 'voice.wav'

%% testing migration: mirframe with sig.frame in framesize and in seconds
disp('testing migration: mirframe with sig.frame in framesize and in seconds'); 

w = 1; %%length of the window in seconds (default 0.05 seconds)
wu = 's';

a = mirframe(testfile, 'Length', w, wu);
b = sig.frame(testfile, 'FrameSize', w, wu);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;



% % testing migration: mirframe with sig.frame in framesize and in no of samples
% disp('testing migration: mirframe with sig.frame in framesize and in no of samples'); 
% 
% w = 0.5; %%length of the window in seconds (default 0.05 seconds)
% wu = 'sp';
% 
% a = mirframe(testfile, 'Length', w, wu);
% b = sig.frame(testfile, 'FrameSize', w, wu);
% 
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    disp('test fail!');
% end
% clearvars -except testfile ;


%% testing migration: mirframe with sig.frame in Hop and in seconds
disp('testing migration: mirframe with sig.frame in Hop and in seconds'); 

h = 1; %%length of the window in seconds (default 0.05 seconds)
wu = 's';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;



% testing migration: mirframe with sig.frame in Hop and in no of samples
disp('testing migration: mirframe with sig.frame in Hop and in no of hops'); 

h = 2; %%length of the window in seconds (default 0.05 seconds)
wu = 'sp';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirframe with sig.frame in Hop and in percent
disp('testing migration: mirframe with sig.frame in Hop and in percent'); 

h = 1; %%length of the window in seconds (default 0.05 seconds)
wu = '%';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;




%% testing migration: mirframe with sig.frame in Hop and in Hz
disp('testing migration: mirframe with sig.frame in Hop and in Hz'); 

h = 1; %%length of the window in seconds (default 0.05 seconds)
wu = 'Hz';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;



%% testing migration: mirframe with sig.frame in Hop and in ratio
disp('testing migration: mirframe with sig.frame in Hop and in ratio'); 

h = 1; %%length of the window in seconds (default 0.05 seconds)
wu = '/1';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu);

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;
