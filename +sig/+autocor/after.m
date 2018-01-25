% SIG.AUTOCOR.AFTER
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    
    if isfield(option,'tmp')
        tmp = option.tmp;
    else
        tmp = [];
    end

    if ~x.isempty
        if isstruct(option.min) || isstruct(option.max)
            if ~isstruct(option.min)
                option.min.value = -Inf;
                option.min.unit = 's';
            end
            if ~isstruct(option.max)
                option.max.value = Inf;
                option.max.unit = 's';
            end
            param.value = [option.min.value,option.max.value];
            param.unit = option.min.unit;
            x = x.extract(param,'element','Xaxis','Ydata','window');
        end
        
        if not(isequal(x.normwin,0) || strcmpi(x.normwin,'No') || ...
                strcmpi(x.normwin,'Off') || x.normalized)
            x = x.normalize;
        end
        if option.hwr
            x = x.halfwave;
        end
        
        if isequal(option.enhance,1)
            option.enhance = 2:10;
        end
        if max(option.enhance)>1
            x = x.enhance(option.enhance);
        end
    end

    if option.freq
        x.Xaxis.name = 'Frequency';
    elseif isempty(x.Xaxis.name)
        x.Xaxis.name = 'Time';
    end
    
    out = {x,tmp};
end