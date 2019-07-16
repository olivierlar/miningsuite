
testfile = 'ragtime.wav'



%% testing migration: mirfilterbank (..., 'Gammatone') -> aud.filterbank
disp('testing migration: mirfilterbank (..., ''Gammatone'') -> aud.filterbank'); 

a = mirfilterbank(testfile, 'Gammatone');
b = aud.filterbank(testfile, 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;



%% testing migration: mirfilterbank (..., '2Channels') -> aud.filterbank (...,'2Channels')
disp('testing migration: mirfilterbank (..., ''2Channels'') -> aud.filterbank (...,''2Channels'')'); 

a = mirfilterbank(testfile, '2Channels');
b = aud.filterbank(testfile, '2Channels', 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Channel',c) -> sig.filterbank (...,'Channel', c)
disp('testing migration: mirfilterbank (..., ''Channel'', c) -> aud.filterbank (...,''Channel'',c)'); 

c = 2;

a = mirfilterbank(testfile, 'Channel', c);
b = aud.filterbank(testfile, 'Channel', c, 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Manual',f) -> sig.filterbank (...,'CutOff', f)
% disp('testing migration: mirfilterbank (..., ''Manual'', f) -> aud.filterbank (...,''CutOff'',f)'); 
% 
% f = 200;
% 
% a = mirfilterbank(testfile, 'Manual', f);
% b = sig.filterbank(testfile, 'CutOff', f);
% 
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    disp('test fail!');
% end
% clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Order',o) -> sig.filterbank (...,'Order', o)
disp('testing migration: mirfilterbank (..., ''Order'', o) -> aud.filterbank (...,''Order'',o)'); 

o = 4;

a = mirfilterbank(testfile, 'Order', o);
b = aud.filterbank(testfile, 'Order', o, 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Hop',h) -> sig.filterbank (...,'Hop', h)
disp('testing migration: mirfilterbank (..., ''Hop'', h) -> aud.filterbank (...,''Hop'',h)'); 


disp('filters are non-overlapping');
h = 1;

a = mirfilterbank(testfile, 'Hop', h);
b = sig.filterbank(testfile, 'Hop', h, 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

disp('filters are half-overlapping');
h = 2;

a = mirfilterbank(testfile, 'Hop', h);
b = sig.filterbank(testfile, 'Hop', h, 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end

clearvars -except testfile ;

disp('the spectral hop factor between successive fiters is a thir of the whole frequency region');
h = 3;

a = mirfilterbank(testfile, 'Hop', h);
b = sig.filterbank(testfile, 'Hop', h, 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end



%% testing migration: mirfilterbank (..., 'Mel') -> aud.filterbank (...,'Mel')
% disp('testing migration: mirfilterbank (..., ''Mel'') -> aud.filterbank (...,''Mel'')'); 
% 
% a = mirfilterbank(testfile, 'Mel');
% b = aud.filterbank(testfile, 'Mel');
% 
% tf = isequal(mirgetdata(a),b.getdata);
% 
% if tf == 1
%    disp('test OK!'); 
% else
%    disp('test fail!');
% end
% clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Bark') -> aud.filterbank (...,'Bark')
disp('testing migration: mirfilterbank (..., ''Bark'') -> aud.filterbank (...,''Bark'')'); 

a = mirfilterbank(testfile, 'Bark');
b = aud.filterbank(testfile, 'Bark', 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Scheirer') -> aud.filterbank (...,'Scheirer')
disp('testing migration: mirfilterbank (..., ''Scheirer'') -> aud.filterbank (...,''Scheirer'')'); 

a = mirfilterbank(testfile, 'Scheirer');
b = aud.filterbank(testfile, 'Scheirer', 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirfilterbank (..., 'Klapuri') -> aud.filterbank (...,'Klapuri')
disp('testing migration: mirfilterbank (..., ''Klapuri'') -> aud.filterbank (...,''Klapuri'')'); 

a = mirfilterbank(testfile, 'Klapuri');
b = aud.filterbank(testfile, 'Klapuri', 'Mix');

tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;
