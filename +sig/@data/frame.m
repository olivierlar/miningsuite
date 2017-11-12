% SIG.DATA.FRAME
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = frame(obj,param,sr)
    obj = sig.compute(@main,obj,param,sr);
end


function [data nfr] = main(data,param,sr)
    if strcmpi(param.size.unit,'s')
        l = param.size.value*sr;
    elseif strcmpi(param.size.unit,'sp')
        l = param.size.value;
    end
    if strcmpi(param.hop.unit,'/1')
        h = param.hop.value*l;
        frate = sr/h;
    elseif strcmpi(param.hop.unit,'%')
        h = param.hop.value*l*.01;
        frate = sr/h;
    elseif strcmpi(param.hop.unit,'s')
        h = param.hop.value*sr;
        frate = 1/param.hop.value;
    elseif strcmpi(param.hop.unit,'sp')
        h = param.hop.value;
        frate = sr/param.hop.value;
    elseif strcmpi(param.hop.unit,'Hz')
        h = sr/param.hop.value;
        frate = param.hop.value;
    end
    l = floor(l);
    
    olddim = data.whichdim('sample');
    oldcontent = data.content;
    if olddim > 2
        error('not implemented yet');
    end
    
    if size(l)==1
        nfr = floor((size(oldcontent,olddim)-l)/h)+1; % Number of frames 
        if nfr < 1
            disp('Frame length longer than total sequence size. No frame decomposition.');
            return
        end
        switch olddim
            case 1
                if length(size(oldcontent)) == 2 
                    if size(oldcontent,2) == 1
                        newcontent = zeros(l,nfr);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1);
                            newcontent(:,i) = oldcontent(st:st+l-1);
                        end
                        data.dims{2} = 'frame';
                    else
                        newcontent = zeros(l,size(oldcontent,2),nfr);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1);
                            newcontent(:,:,i) = oldcontent(st:st+l-1,:);
                        end
                        data.dims{3} = 'frame';
                    end
                else
                    newcontent = zeros(l,size(oldcontent,2),size(oldcontent,3),nfr);
                    for i = 1:nfr % For each frame, ...
                        st = floor((i-1)*h+1);
                        newcontent(:,:,:,i) = oldcontent(st:st+l-1,:,:);
                    end
                    data.dims{4} = 'frame';
                end
            case 2
                if length(size(oldcontent)) == 2 
                    if size(oldcontent,1) == 1
                        newcontent = zeros(nfr,l);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1);
                            newcontent(i,:) = oldcontent(1,st:st+l-1);
                        end
                        data.dims{1} = 'frame';
                    else
                        newcontent = zeros(size(oldcontent,1),l,nfr);
                        for i = 1:nfr % For each frame, ...
                            st = floor((i-1)*h+1);
                            newcontent(:,:,i) = oldcontent(:,st:st+l-1);
                        end
                        data.dims{3} = 'frame';
                    end
                else
                    newcontent = zeros(size(oldcontent,1),l,size(oldcontent,3),nfr);
                    for i = 1:nfr % For each frame, ...
                        st = floor((i-1)*h+1);
                        newcontent(:,:,:,i) = oldcontent(:,st:st+l-1,:);
                    end
                    data.dims{4} = 'frame';
                end
        end
    end
    
    data.content = newcontent;
end


function old_code % more general but slow
    olddim = data.whichdim('sample');
    oldcontent = data.content;
    olddims = size(oldcontent);
    free = find(olddims==1);
    if isempty(free)
        newdim = length(olddims)+1;
    else
        newdim = free(1);
    end

    if size(l)==1
        nfr = floor((size(oldcontent,olddim)-l)/h)+1; % Number of frames 
        if nfr < 1
            disp('Frame length longer than total sequence size. No frame decomposition.');
            return
        end
        
        olddims(olddim) = l;
        newdims = olddims;
        newdims(newdim) = nfr;  
        newcontent = zeros(newdims);
        oldargs = cell(1,length(olddims));
        for i = 1:length(olddims)
            oldargs{i} = ':';
        end
        newargs = oldargs;
        
        for i = 1:nfr % For each frame, ...
            st = floor((i-1)*h+1);
            oldargs{olddim} = st:st+l-1;
            newargs{newdim} = i;
            oldstruct = substruct('()',oldargs);
            newstruct = substruct('()',newargs);
            newcontent = subsasgn(newcontent,newstruct,...
                                  subsref(oldcontent,oldstruct));
        end
    end
end