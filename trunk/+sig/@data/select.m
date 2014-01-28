function obj = select(obj,dim,pos,type)
    if nargin<4
        type = '()';
    end

    data = obj.content;
    posdata = pos.content;
    dimdata = size(data);
    ndimdata = length(dimdata);
    
    foundim = obj.whichdim(dim);
    dimdata(foundim) = 1;

    start = cell(1,ndimdata);
    if iscell(data)
        oldtype = '{}';
    else
        oldtype = '()';
    end
    [datargs posargs] = recurse(data,pos,foundim,start,start,1,ndimdata,...
                                {},{},oldtype);
    newdata = zeros(dimdata);

    for i = 1:length(datargs)
        olddatai = subsref(data,datargs{i});
        posi = subsref(posdata,posargs{i});
        newdatai = olddatai(posi);
        newdata = subsasgn(newdata,datargs{i},newdatai);
    end

    obj.content = newdata;
end


function [datargs posargs] = recurse(data,pos,dim,datcurrent,poscurrent,...
                                     d,ndim,datargs,posargs,type)
    if d > ndim
        datargs{end+1} = substruct(type,datcurrent);
        posargs{end+1} = substruct('{}',poscurrent);
    elseif d == dim
        datcurrent{d} = ':';
        poscurrent{d} = 1;
        [datargs posargs] = recurse(data,pos,dim,datcurrent,poscurrent,...
                                    d+1,ndim,datargs,posargs,type);
    else
        for i = 1:size(data,d)
            datcurrent{d} = i;
            poscurrent{d} = i;
            [datargs posargs] = recurse(data,pos,dim,datcurrent,poscurrent,...
                                        d+1,ndim,datargs,posargs,type);
        end
    end
end