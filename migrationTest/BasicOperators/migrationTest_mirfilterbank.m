    
testfile = 'ragtime.wav'


%% testing migration: mirfilterbank (...) -> aud.filterbank(...)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (...) -> aud.filterbank(...)'); 

a = mirfilterbank(testfile);
b = aud.filterbank(testfile, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   %cprintf('*green', 'test SUCCESS!\n'); 
   cprintf('*green', 'test OK!');
else
   cprintf('*red', 'test FAIL!');
   %cprintf('*red', 'test FAIL!\n');
end






%% testing migration: mirfilterbank (..., 'Gammatone') -> aud.filterbank(..., 'Gammatone')

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Gammatone'') -> aud.filterbank(..., ''Gammatone'')'); 

a = mirfilterbank(testfile, 'Gammatone');
b = aud.filterbank(testfile, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Gammatone','Lowest', f) -> aud.filterbank (...,'Gammatone','Lowest', f)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Gammatone'',''Lowest'', f) -> aud.filterbank (...,''Gammatone'',''Lowest'', f)'); 

f = 50; %lowest frequency (default = 50 Hz)

a = mirfilterbank(testfile, 'Gammatone','Lowest', f);
b = aud.filterbank(testfile, 'Gammatone','Lowest', f, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end



%% testing migration: mirfilterbank (..., 'Gammatone', '2Channels') -> aud.filterbank(..., 'Gammatone', '2Channels') 

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Gammatone'', ''2Channels'') -> aud.filterbank(..., ''Gammatone'', ''2Channels'')'); 


a = mirfilterbank(testfile, '2Channels');
b = aud.filterbank(testfile, '2Channels', 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirfilterbank (..., 'Gammatone', 'NbChannels', N) -> aud.filterbank (..., 'Gammatone', 'NbChannels', N)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Gammatone'', ''NbChannels'', N) -> aud.filterbank(..., ''Gammatone'', ''NbChannels'', N)'); 


N = 20; %no of channels 

a = mirfilterbank(testfile, 'Gammatone', 'NbChannels', N);
b = aud.filterbank(testfile, 'Mix', 'NbChannels', N);

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end



%% testing migration: mirfilterbank (..., 'Channel',c) -> aud.filterbank (...,'Channel', c)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Channel'', c) -> aud.filterbank (...,''Channel'',c)'); 

c = 2:5;

a = mirfilterbank(testfile, 'Channel', c);
b = aud.filterbank(testfile, 'Channel', c, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end




%% testing migration: mirfilterbank (..., 'Manual',f) -> sig.filterbank (...,'CutOff', f)
clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Manual'', f) -> sig.filterbank (...,''CutOff'',f)'); 

f = [-Inf,200,Inf];

a = mirfilterbank(testfile, 'Manual', f);
b = sig.filterbank(testfile, 'CutOff', f,'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Manual', f, 'Order',o) -> sig.filterbank (...,'CutOff', f,'Order', o)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Manual'', f, ''Order'', o) -> sig.filterbank (...,''CutOff'',f,''Order'',o)'); 

f = [-Inf,200,Inf];
o = 3;

a = mirfilterbank(testfile, 'Manual', f, 'Order', o);
b = sig.filterbank(testfile, 'CutOff', f, 'Order', o, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end



%% testing migration: mirfilterbank (..., 'Manual', f, 'Hop',1) -> sig.filterbank (...,'CutOff', f,'Hop', 1)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Manual'', f, ''Hop'', 1) -> sig.filterbank (...,''CutOff'',f,''Hop'',1)'); 
f = [-Inf,200,400,Inf];
h = 1;

a = mirfilterbank(testfile, 'Manual', f, 'Hop', h);
b = sig.filterbank(testfile, 'CutOff', f, 'Hop', h, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Manual', f, 'Hop',2) -> sig.filterbank (...,'CutOff', f,'Hop', 2)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Manual'', f, ''Hop'', 2) -> sig.filterbank (...,''CutOff'',f,''Hop'',2)'); 
f = [-Inf,200,400,Inf];
h = 2;

a = mirfilterbank(testfile, 'Manual', f, 'Hop', h);
b = sig.filterbank(testfile, 'CutOff', f, 'Hop', h, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end

%% testing migration: mirfilterbank (..., 'Manual', f, 'Hop',3) -> sig.filterbank (...,'CutOff', f,'Hop', 3)

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Manual'', f, ''Hop'', 3) -> sig.filterbank (...,''CutOff'',f,''Hop'',3)'); 
f = [-Inf,200,400,600,Inf];
h = 3;

a = mirfilterbank(testfile, 'Manual', f, 'Hop', h);
b = sig.filterbank(testfile, 'CutOff', f, 'Hop', h, 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Mel') -> aud.filterbank (...,'Mel')
clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Mel'') -> aud.filterbank (...,''Mel'')'); 

a = mirfilterbank(testfile, 'Mel');
b = aud.filterbank(testfile, 'Mel','Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Bark') -> aud.filterbank (...,'Bark')

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Bark'') -> aud.filterbank (...,''Bark'')'); 

a = mirfilterbank(testfile, 'Bark');
b = aud.filterbank(testfile, 'Bark', 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Scheirer') -> aud.filterbank (...,'Scheirer')

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Scheirer'') -> aud.filterbank (...,''Scheirer'')'); 

a = mirfilterbank(testfile, 'Scheirer');
b = aud.filterbank(testfile, 'Scheirer', 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end


%% testing migration: mirfilterbank (..., 'Klapuri') -> aud.filterbank (...,'Klapuri')

clearvars -except testfile ;
disp('testing migration: mirfilterbank (..., ''Klapuri'') -> aud.filterbank (...,''Klapuri'')'); 

a = mirfilterbank(testfile, 'Klapuri');
b = aud.filterbank(testfile, 'Klapuri', 'Mix');

tf = isequal(squeeze(mirgetdata(a)),b.getdata);

if tf == 1
   cprintf('*green', 'test SUCCESS!\n'); 
else
   cprintf('*red', 'test FAIL!\n');
end
