% PHY.POINT.DIFF
%
% Copyright (C) 2018 Olivier Lartillot
% Copyright (C) 2008 University of Jyvaskyla (MoCap Toolbox)
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = diff(obj,n,butter_order,butter_cutoff,norm)
    if nargin < 5
        norm = 1;
        if nargin < 4
            if nargin < 3
                butter_order = 2;
            end
            butter_cutoff = .2;
        end
    end
    obj.Ydata = sig.compute(@main,obj.Ydata,n,obj.Srate,...
                            butter_order,butter_cutoff,norm);
end


function out = main(d,n,srate,butter_order,cutoff,norm)
    d = d.apply(@differentiate_fast,{n, butter_order, cutoff, srate,norm},...
                                    {'sample'},1);
    out = {d};
end


function d = differentiate_fast(d,n,butter_order,cutoff,srate,norm)
% Part of the MoCap Toolbox, Copyright 2008, 
% University of Jyvaskyla, Finland
    if butter_order
        [b,a]=butter(butter_order, cutoff); % optimal filtering frequency is 0.2 Nyquist frequency
    end
    
    d_mc=mcinitstruct('MoCap data', d, 100);
    [mf mm mgrid]=mcmissing(d_mc);
    if sum(mf)>0 %missing frames need to be filled for the filtering!
        d_mc=mcfillgaps(d_mc,'fillall');%BB FIX 20111212, also beginning and end need filling
        d=d_mc.data;
    end
    
    for k=1:n %differences and filtering
        d=diff(d);
        if butter_order
            d=filtfilt(b,a,d);
        end
        d = [repmat(d(1,:),1,1); d];
    end
    
    if sum(mf)>0 %missing frames set back to NaN
        tmp=1:d_mc.nMarkers;
        tmp=[tmp;tmp;tmp];
        tmp=reshape(tmp,1,[]);
        mgrid=[mgrid(:,tmp)];
        d(mgrid==1)=NaN;
    end
    
    if norm
        d = d .* srate^n;
    end
end


function d1 = mcinitstruct(type, data, freq, markerName, fn)
% Initializes MoCap or norm data structure.
%
% syntax
% d1 = mcinitstruct;
% d1 = mcinitstruct(type);
% d1 = mcinitstruct(type, data);
% d1 = mcinitstruct(type, data, freq);
% d1 = mcinitstruct(type, data, freq, markerName);
% d1 = mcinitstruct(type, data, freq, markerName, fn);
% d1 = mcinitstruct(data, freq);
% d1 = mcinitstruct(data, freq, markerName);
% d1 = mcinitstruct(data, freq, markerName, fn);
%
% input parameters
% type: 'MoCap data' or 'norm data' (default: 'MoCap data')
% data: data to be used in the .data field of the mocap structure (default: [])
% freq: frequency / capture rate of recording (default: NaN)
% markerName: cell array with marker names (default: {})
% fn: filename (default: '')
% 
% output
% d1: mocap or norm data structure with default parameters or parameter
% adjustment according to the parameter input.
% 
% examples
% d1 = mcinitstruct;
% d1 = mcinitstruct('norm data', data);
% d1 = mcinitstruct(data, 120, markernames, 'mydata1.tsv');
% 
% comments
% default parameters (for 'MoCap data'): 
%   type: 'MoCap data'
%   filename: ''
%   nFrames: 0
%   nCameras: NaN
%   nMarkers: 0
%   freq: NaN
%   nAnalog: 0
%   anaFreq: 0
%   timederOrder: 0
%   markerName: {}
%   data: []
%   analogdata: []
%   other:
%   	other.descr: 'DESCRIPTION	--'
%   	other.timeStamp: 'TIME_STAMP	--'
%       other.dataIncluded: '3D'
%
% Part of the Motion Capture Toolbox, Copyright 2008, 
% University of Jyvaskyla, Finland

d1=[];

if nargin==0 %nothing is given
    type='MoCap data';
    data=[];
    freq=NaN;
    markerName={};
    fn='';
end
if nargin==1
    if ischar(type) %type is given
        data=[];
        freq=NaN;
        markerName={};
        fn='';
    else
        disp([10, 'Inconsistent input arguments.', 10]);
        [y,fs] = audioread('mcsound.wav');
        sound(y,fs);
        return
    end
end
if nargin==2
    if ischar(type) && isnumeric(data) %type and data given
        freq=NaN;
        markerName={};
        fn='';
    elseif isnumeric(type) && isnumeric(data) %data and freq given
        freq=data;
        data=type;
        type='MoCap data';
        markerName={};
        fn='';
    else
        disp([10, 'Inconsistent input arguments.', 10]);
        [y,fs] = audioread('mcsound.wav');
        sound(y,fs);
        return
    end
end
if nargin==3
    if ischar(type) && isnumeric(data) && isnumeric(freq) %type, data, and freq given
        markerName={};
        fn='';
    elseif isnumeric(type) && isnumeric(data) && iscell(freq) %data, freq, and markerName given
        markerName=freq;
        freq=data;
        data=type;
        type='MoCap data';
        fn='';
    else
        disp([10, 'Inconsistent input arguments.', 10]);
        [y,fs] = audioread('mcsound.wav');
        sound(y,fs);
        return
    end
end
if nargin==4
    if isnumeric(type) && isnumeric(data) && iscell(freq) && ischar(markerName) %data, freq, markerName, and filename given
        fn=markerName;
        markerName=freq;
        freq=data;
        data=type;
        type='MoCap data';
    else
        disp([10, 'Inconsistent input arguments.', 10]);
        [y,fs] = audioread('mcsound.wav');
        sound(y,fs);
        return
    end
end


d1.type=type;
d1.filename=fn;
d1.nFrames=length(data);
d1.nCameras=NaN;
if strcmp(type,'norm data')
    d1.nMarkers=size(data,2);
else
    d1.nMarkers=size(data,2)/3;
end
d1.freq=freq;
d1.nAnalog=0;
d1.anaFreq=0;
d1.timederOrder=0;
d1.markerName=markerName;
d1.data=data;
d1.analogdata=[];
d1.other=[];

d1.other.descr='DESCRIPTION	--';
d1.other.timeStamp='TIME_STAMP	--';
d1.other.dataIncluded='3D';



if length(d1.markerName)~=d1.nMarkers && ~isempty(markerName)
    disp([10, 'Warning: Amount of marker names (markerName field) inconsistent with number of markers (nMarkers field)', 10]);
end

if strcmp(d1.type,'MoCap data') && d1.nMarkers*3~=size(d1.data,2)
    disp([10, 'Warning: Inconsistent type (MoCap data) and size of data (data and nMarkers fields)', 10]);
end

if strcmp(d1.type,'norm data') && d1.nMarkers~=size(d1.data,2)
    disp([10, 'Warning: Inconsistent type (norm data) and size of data (data and nMarkers fields)', 10]);
end
end



function [mf, mm, mgrid] = mcmissing(d)
% Reports missing data per marker and frame. 
%
% syntax
% [mf, mm, mgrid] = mcmissing(d);
%
% input parameters
% d: MoCap or norm data structure.
%
% output
% mf: number of missing frames per marker
% mm: number of missing markers per frame
% mgrid: matrix showing missing data per marker and frame (rows correspond to frames and columns to markers
%
% Part of the Motion Capture Toolbox, Copyright 2008,
% University of Jyvaskyla, Finland

if isfield(d,'type') && strcmp(d.type, 'MoCap data')
    mf = sum(isnan(d.data(:,1:3:end)),1);
    mm = sum(isnan(d.data(:,1:3:end)),2);
    mgrid = isnan(d.data(:,1:3:end));
elseif isfield(d,'type') && strcmp(d.type, 'norm data')
    mf = sum(isnan(d.data(:,1:end)),1);
    mm = sum(isnan(d.data(:,1:end)),2);
    mgrid = isnan(d.data(:,1:end));
else
    disp([10, 'The first input argument should be a variable with MoCap or norm data structure.', 10]);
    [y,fs] = audioread('mcsound.wav');
    sound(y,fs);
    mf=[];
    mm=[];
    mgrid=[];
end
end
