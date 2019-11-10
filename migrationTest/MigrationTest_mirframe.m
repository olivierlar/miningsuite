
testfile = 'ragtime.wav'

%% testing migration: mirframe(..., 'Length', w, 's') -> sig.frame(..., 'FrameSize', w, 's')
clearvars -except testfile ;

disp('testing migration: mirframe(..., ''Length'', w, ''s'') -> sig.frame(..., ''FrameSize'', w, ''s'')'); 

w = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = 's';

a = mirframe(testfile, 'Length', w, wu);
b = sig.frame(testfile, 'FrameSize', w, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end



%% testing migration: mirframe(..., 'Length', w, 'sp') -> sig.frame(..., 'FrameSize', w, 'sp')
clearvars -except testfile ;

disp('testing migration: mirframe(..., ''Length'', w, ''sp'') -> sig.frame(..., ''FrameSize'', w, ''sp'')'); 

w = 1; %%length of the window in number of samples
wu = 'sp';

a = mirframe(testfile, 'Length', w, wu);
b = sig.frame(testfile, 'FrameSize', w, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirframe(...,'Hop;=', h, 's') -> sig.frame(..., 'FrameHop', h, 's')
clearvars -except testfile ;

disp('testing migration: mirframe(...,''Hop'', h, ''s'') -> sig.frame(..., ''FrameHop'', h, ''s'')'); 

h = 0.05; %%length of the window in seconds (default 0.05 seconds)
wu = 's';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end




%% testing migration: mirframe(...,'Hop', h, 'sp') -> sig.frame(..., 'FrameHop', h, 'sp')
clearvars -except testfile ;

disp('testing migration: mirframe(...,''Hop'', h, ''sp'') -> sig.frame(..., ''FrameHop'', h, ''sp'')'); 

h = 1000; %%length of the window in number of samples
wu = 'sp';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration:  mirframe(...,'Hop', h, '%') -> sig.frame(..., 'FrameHop', h, '%')
clearvars -except testfile ;

disp('testing migration: mirframe(...,''Hop'', h, ''%'') -> sig.frame(..., ''FrameHop'', h, ''%'')');

h = 25; %%length of the window in seconds (default 0.05 seconds)
wu = '%';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end



%% testing migration:  mirframe(...,'Hop', h, 'Hz') -> sig.frame(..., 'FrameHop', h, 'Hz')
clearvars -except testfile ;

disp('testing migration: mirframe(...,''Hop'', h, ''Hz'') -> sig.frame(..., ''FrameHop'', h, ''Hz'')');

h = 100; %%length of the window in seconds (default 0.05 seconds)
wu = 'Hz';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end
% 
% 
% 
%% testing migration:  mirframe(...,'Hop', h, '/1') -> sig.frame(..., 'FrameHop', h, '/1')
clearvars -except testfile ;

disp('testing migration: mirframe(...,''Hop'', h, ''/1'') -> sig.frame(..., ''FrameHop'', h, ''/1'')');

h = 0.1; %%length of the window in seconds (default 0.05 seconds)
wu = '/1';

a = mirframe(testfile, 'Hop', h, wu);
b = sig.frame(testfile, 'FrameHop', h, wu,'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end
