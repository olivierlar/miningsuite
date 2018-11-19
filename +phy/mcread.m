function d = mcread(fn)
% Reads a motion capture data file and returns a MoCap structure. 
%
% syntax
% d = mcread(fn);
% d = mcread;
%
% input parameters
% fn: file name; tsv, c3d, bvh, mat, or wii format. If no input parameter is given, a file open dialog opens.
%
% output
% d: MoCap structure containing parameter values and data
% 
% examples
% d = mcread('filename.tsv');
% d = mcread('filename.c3d');
% d = mcread('filename.bvh');
% d = mcread('filename.mat');
% d = mcread('filename.wii');
% d = mcread;
%
% comments
% Currently the .c3d, .tsv (as exported by QTM), .bvh, .mat (as exported by QTM), and .wii 
% (WiiDataCapture software) formats are supported. The file names must have postfixes 
% '.c3d', '.tsv', ?.bvh', '.mat', or '.wii', respectively. 
% For reading .c3d files, the function provided at http://www.c3d.org/download_apps.html is used.
% For exporting in .tsv format from Qualisys QTM, recommended export parameter are: 
%	3D data and Include TSV header ticked.
%	Export time data for every frame and write column headers will be ignored by mcread if ticked
% The .c3d format does not support more than 65535 frames per file 
% (see www.c3d.org/HTML/default.htm ? The C3D file format ? Limitations). Therefore, 
% if you happen to have longer recordings, export them either in .tsv or .mat, or in more than one
% c3d file. If further problems occur when reading in .c3d files, try to adapt the ?machinetype' 
% parameters as indicated in the readc3d.m (in the folder ?private?).
% Reading in .bvh files requires additional toolboxes available here: 
% http://staffwww.dcs.shef.ac.uk/people/N.Lawrence/mocap/ (mocap and ndlutil).

%
% Part of the Motion Capture Toolbox, Copyright 2008, 
% University of Jyvaskyla, Finland

d = [];
if nargin==0
    [file,path] = uigetfile({'*.tsv;*.c3d;*bvh;*.mat;*.wii', '.tsv, .c3d, .bvh, .mat and .wii files'}, 'Pick a .tsv, .c3d, .bvh, .mat, or .wii file');
    fn = [path file];
end
    
if ~ischar(fn) %Check if input is given as string - BB 20120413 (does not work if file ending is given)
    disp([10, 'Please enter file name as string!',10]);
    [y,fs] = audioread('mcsound.wav');
    sound(y,fs);
    return
end

if fn ~= 0

    if exist(fn,'file') == 2 %Check if file exists - BB 20111109
        postfix = fn((end-3):end);
        
        if strcmp(postfix,'.tsv')
            d = mcreadtsv(fn);
            d.data(d.data==0) = NaN;
        elseif strcmp(postfix, '.c3d')
            d = mcreadc3d(fn);
            d.data(d.data==0) = NaN;
        elseif strcmp(postfix, '.bvh')
            d = mcreadbvh(fn);
            d.data(d.data==0) = NaN;
        elseif strcmp(postfix, '.wii') || strcmp(postfix, '.txt')
            d = mcreadwii(fn);
            d.data(d.data==0) = NaN;
        elseif strcmp(postfix,'.mat') % -- ES: ADDED 201107
            d = mcreadmat(fn);
        
        else
            disp([10, 'This file format is not supported!',10]);
            [y,fs] = audioread('mcsound.wav');
            sound(y,fs);
        end
    else
        disp([10, 'File not found!',10]); %BB 20111109
        [y,fs] = audioread('mcsound.wav');
        sound(y,fs);
    end
end
    