function obj = frame(obj,param,sr)
    obj = sig.compute(@main,obj,param,sr);
end


function data = main(data,param,sr)
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
    if olddim > 1
        error('not implemented yet');
    end
    
    if size(l)==1
        nfr = floor((size(oldcontent,olddim)-l)/h)+1; % Number of frames 
        if nfr < 1
            disp('Frame length longer than total sequence size. No frame decomposition.');
            return
        end
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