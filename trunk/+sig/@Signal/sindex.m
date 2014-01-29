function s = sindex(obj,t)
    ndims = length(obj.Srate);
    if ndims == 0
        s = [];
    elseif ndims == 1
        s = round(t/Frate);
    else
        s = cell(1,ndims);
        for i = 1:ndims
            s(i) = round(t/Srate(i));
        end
    end
end