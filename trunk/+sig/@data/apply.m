function [obj varargout] = apply(obj,func,argin,dimfunc,ndimfunc,type)
    if nargin<5
        ndimfunc = Inf;
    end

    if nargin<6
        type = '()';
    end
    
    data = obj.content;
    if isempty(data)
        return
    end
    dimdata = size(data);
    ndimdata = length(dimdata);
    ordim = zeros(1,ndimdata);
    ndimfunc = min(ndimfunc,ndimdata);
    
    for i = 1:length(dimfunc)
        foundim = obj.whichdim(dimfunc{i});
        if isempty(foundim)
            %varargout = {};
            %return
            ndimdata = ndimdata+1;
            foundim = ndimdata;
            obj.dims{foundim} = dimfunc{i};
        end
        ordim(i) = foundim;
        dimdata(foundim) = 0;
    end

    [sortedim bestdim] = sort(dimdata,'descend');
    notherdims = ndimdata-length(dimfunc);
    if notherdims
        ordim(length(dimfunc)+1:ndimdata) = bestdim(1:notherdims);
    end

    data = permute(data,ordim);
    dimdata = dimdata(ordim);

    start = cell(1,ndimdata);
    for i = 1:ndimfunc
        start{i} = ':';
    end
    if iscell(data)
        oldtype = '{}';
    else
        oldtype = '()';
    end
    args = recurse(data,start,ndimfunc+1,ndimdata,{},oldtype);
    
    for i = 1:length(args)
        olddatai = subsref(data,args{i});
        
        f = find(strcmp('self',argin));
        if f
            argini = argin;
            argini{f} = olddatai;
        else
            argini = [{olddatai} argin];
        end
                
        if nargout == 1
            newdatai = func(argini{:});
        elseif nargout == 2
            [newdatai varargout{1}] = func(argini{:});
            % Full reconstruction not implemented yet.
        end

        if i == 1
            if strcmp(type,'{}')
                dimdata(~dimdata) = 1;
                newdata = cell(dimdata);
                for i = 1:ndimfunc
                    start{i} = 1;
                end
                newargs = recurse(data,start,ndimfunc+1,ndimdata,{},'{}');
                
            elseif ~isequal(size(olddatai),size(newdatai)) && ndimdata>ndimfunc
                extradims = sortedim((ndimfunc+1:ndimdata)-ndimfunc);
                if ndims(newdatai) == 2 && size(newdatai,2) == 1
                    newdata = zeros([length(newdatai),extradims]);
                else
                    newdata = zeros([size(newdatai),extradims]);
                end
                newargs = args;
                
            else
                newdata = newdatai; %data;
                newargs = args;
            end
        end
        
        newdata = subsasgn(newdata,newargs{i},newdatai);
    end

    newdata = ipermute(newdata,ordim);
    obj.content = newdata;
end


function args = recurse(data,current,d,ndim,args,type)
    if d > ndim
        args{end+1} = substruct(type,current);
    else
        for i = 1:size(data,d)
            current{d} = i;
            args = recurse(data,current,d+1,ndim,args,type);
        end
    end
end