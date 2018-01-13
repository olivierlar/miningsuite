% SIG.FRAME
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = frame(varargin)
    out = sig.operate('sig','frame',options,@init,@main,@after,varargin,'extensive');
    varargout = out;
end


function options = options
    options = sig.Signal.signaloptions();
    
        fsize.key = 'FrameSize';
        fsize.type = 'Unit';
        fsize.default.unit = 's';
        fsize.default.value = .05;
        fsize.unit = {'s','sp'};
    options.fsize = fsize;

        fhop.key = 'FrameHop';
        fhop.type = 'Unit';
        fhop.default.unit = '/1';
        fhop.default.value = .5;
        fhop.unit = {'s','sp','Hz','/1'};
    options.fhop = fhop;
end


function [x,type] = init(x,option,frame)
    if isa(x,'sig.design')
        x.overlap = option.fsize;
    end
    type = 'sig.Signal';
end


function out = main(x,frame)
    if iscell(x)
        x = x{1};
    end
    if x.Frate
        warning('Warning in sig.frame: Already frame-decomposed. Ignored.');
        out = {x};
        return
    end
    frate = sig.compute(@sig.getfrate,x.Srate,frame);
    data = sig.compute(@routine,x.Ydata,x.Sstart,length(x.Sstart)>1,frame,x.Srate);
    if isempty(data)
        out = {[]};
    else
        x.Ydata = data;
        x.Frate = frate;
        out = {x};
    end
end


function data = routine(data,start,segmented,param,sr)
    if strcmpi(param.fsize.unit,'s')
        l = param.fsize.value*sr;
    elseif strcmpi(param.fsize.unit,'sp')
        l = param.fsize.value;
    end
    if strcmpi(param.fhop.unit,'/1')
        h = param.fhop.value*l;
    elseif strcmpi(param.fhop.unit,'%')
        h = param.fhop.value*l*.01;
    elseif strcmpi(param.fhop.unit,'s')
        h = param.fhop.value*sr;
    elseif strcmpi(param.fhop.unit,'sp')
        h = param.fhop.value;
    elseif strcmpi(param.fhop.unit,'Hz')
        h = sr/param.fhop.value;
    end
    l = floor(l);
    
    sf = ceil((start-1)/h)+1; %Starting frame
    if segmented
        offset = 0;
    else
        fstart = floor((sf-1)*h) + 1; %Actual sample where we should start
        offset = fstart - start;
    end
    
    olddim = data.whichdim('sample');
    oldcontent = data.content;
    if olddim > 2
        error('not implemented yet');
    end
    
    if size(l)==1
        nfr = floor((size(oldcontent,olddim)-l-offset)/h)+1; % Number of frames 
        if nfr < 1
            if ~offset
                disp('Frame length longer than total sequence size. No frame decomposition.');
            end
            data = [];
            return
        end
        switch olddim
            case 1
                if length(size(oldcontent)) == 2 
                    if size(oldcontent,2) == 1
                        newcontent = zeros(l,nfr);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1) + offset;
                            newcontent(:,i) = oldcontent(st:st+l-1);
                        end
                        data.dims{2} = 'frame';
                    else
                        newcontent = zeros(l,size(oldcontent,2),nfr);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1) + offset;
                            newcontent(:,:,i) = oldcontent(st:st+l-1,:);
                        end
                        data.dims{3} = 'frame';
                    end
                else
                    newcontent = zeros(l,size(oldcontent,2),size(oldcontent,3),nfr);
                    for i = 1:nfr % For each frame, ...
                        st = floor((i-1)*h+1) + offset;
                        newcontent(:,:,:,i) = oldcontent(st:st+l-1,:,:);
                    end
                    data.dims{4} = 'frame';
                end
            case 2
                if length(size(oldcontent)) == 2 
                    if size(oldcontent,1) == 1
                        newcontent = zeros(nfr,l);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1) + offset;
                            newcontent(i,:) = oldcontent(1,st:st+l-1);
                        end
                        data.dims{1} = 'frame';
                    else
                        newcontent = zeros(size(oldcontent,1),l,nfr);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1) + offset;
                            newcontent(:,:,i) = oldcontent(:,st:st+l-1);
                        end
                        data.dims{3} = 'frame';
                    end
                else
                    newcontent = zeros(size(oldcontent,1),l,size(oldcontent,3),nfr);
                    for i = 1:nfr % For each frame, ...
                        st = floor((i-1)*h+1) + offset;
                        newcontent(:,:,:,i) = oldcontent(:,st:st+l-1,:);
                    end
                    data.dims{4} = 'frame';
                end
        end
    end
    
    data.content = newcontent;
end


function x = after(x,option)
end