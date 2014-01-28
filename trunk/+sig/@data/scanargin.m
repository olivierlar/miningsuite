function [args content] = scanargin(obj,argin)
    args = cell(1,length(obj.dims));
    for i = 1:length(obj.dims)
        args{i} = ':';
    end
    
    if mod(length(argin),2)
        content = argin{1};
        if isa(content,'sig.data')
            content = content.content;
        end
        argin = argin(2:end);
    else
        content = obj.content;
    end
    
    for i = 1:2:length(argin)
        dim = obj.whichdim(argin{i});
        if isempty(dim)
            continue
        end
        argini = argin{i+1};
        if iscell(argini)
            for j = 1:length(argini)
                args{dim(j)} = index2str(argini{j});
            end
        elseif length(argini)==1
            args{dim} = argini;
        else
            args{dim} = argini(1):argini(2);
        end
    end
    
    if 0 %iscell(obj.content)
        type = '{}';
    else
        type = '()';
    end
    args = substruct(type,args);
end


function str = index2str(index)
    switch length(index)
        case 0
            str = ':';
        case 1
            str = index;
        case 2
            str = index(1):index(2);
    end
end