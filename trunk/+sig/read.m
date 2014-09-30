% SIG.READ
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function [data sr] = read(file,extract)
try
    [d,sr] = audioread(file,extract');
catch thiserror
    err.wav = thiserror.message;
    try
        [d,sr] = audioreader(extract,@wavread,file);
    catch thiserror
        err.wav = thiserror.message;
        try
           [d,sr] = audioreader(extract,@auread,file);
        catch thiserror
            err.au = thiserror.message;
            try
                [d,sr] = audioreader(extract,@mp3read,file);
            catch thiserror
                err.mp3 = thiserror.message;
                try
                    [d,sr] = audioreader(extract,@aiffread,file);
                catch thiserror
                    err.aiff = thiserror.message;
                    try
                        data = midiread(file);
                        sr = 0;
                    catch
                        misread(file, err);
                    end
                end
            end
        end
    end
end
if sr
    data = sig.data(d,{'sample','channel'});
end


function [data,sr] = audioreader(extract,reader,file)
if isempty(extract)
    [data,sr] = reader(file);
else
    [data,sr] = reader(file,extract(1:2));
    %data = data(:,extract(3));
end
if 1 %verbose
    disp([file,' loaded.']);
end


function nmat = midiread(name)
fid = fopen(name);
if fid<0
    error;
    return
end
head = fread(fid,'uint8');
fclose(fid);
if ~isequal(head(1:4)',[77 84 104 100]);
    error;
    return
end
nmat = mus.midi2nmat(name);


function misread(file,err)
display('Here are the error message returned by each reader:');
display(err.wav);
display(err.au);
display(err.mp3);
display(err.aiff);
error(['Cannot open file ',file]);