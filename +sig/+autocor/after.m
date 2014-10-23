function out = after(x,postoption)
    if iscell(x)
        x = x{1};
    end
    
    if isfield(postoption,'tmp')
        tmp = postoption.tmp;
    else
        tmp = [];
    end
    
    if postoption.freq
        x.Xaxis.name = 'Frequency';
    else
        x.Xaxis.name = 'Time';
    end

    if isstruct(postoption.min) || isstruct(postoption.max)
        if ~isstruct(postoption.min)
            postoption.min.value = -Inf;
            postoption.min.unit = 's';
        end
        if ~isstruct(postoption.max)
            postoption.max.value = Inf;
            postoption.max.unit = 's';
        end
        param.value = [postoption.min.value,postoption.max.value];
        param.unit = postoption.min.unit;
        x = x.extract(param,'element','Xaxis','Ydata'); %,'window');
    end

    if not(isequal(postoption.normwin,0) || ...
           strcmpi(postoption.normwin,'No') || ...
           strcmpi(postoption.normwin,'Off') || ...
           x.normalized)
        %x = x.normalize;
    end
    if postoption.hwr
        x = x.hwr;
    end
    
    if isequal(postoption.enhance,1)
        postoption.enhance = 2:10;
    end
    if max(postoption.enhance)>1
        x = x.enhance(postoption.enhance);
    end

    out = {x,tmp};
end