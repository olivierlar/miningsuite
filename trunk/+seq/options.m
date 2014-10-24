function options = options(optionspec,args)

options = struct;
%extract = [];

fields = fieldnames(optionspec);
for i = 1:length(fields)
    field = fields{i};
    if isfield(optionspec.(field),'default')
        options.(field) = optionspec.(field).default;
    else
        options.(field) = 0;
    end
end
i = 1;
while i <= length(args)
    arg = args{i};
    match = 0;
    k = 0;
    while not(match) && k<length(fields)
        k = k+1;
        field = fields{k};
        if isfield(optionspec.(field),'key')
            key = optionspec.(field).key;
            if not(iscell(key))
                key = {key};
            end
            for j = 1:length(key)
                if strcmpi(arg,key{j})
                    match = 1;
                end
            end
            if match
                if isfield(optionspec.(field),'type')
                    type = optionspec.(field).type;
                else
                    type = [];
                end
                if strcmpi(type,'String')
                    if length(args) > i && ...
                            (ischar(args{i+1}) || args{i+1} == 0)
                        if isfield(optionspec.(field),'choice')
                            match2 = 0;
                            arg2 = args{i+1};
                            for j = optionspec.(field).choice
                                if (ischar(j{1}) && strcmpi(arg2,j)) || ...
                                   (not(ischar(j{1})) && isequal(arg2,j{1}))
                                        match2 = 1;
                                        i = i+1;
                                        optionvalue = arg2;
                                end
                            end
                            if not(match2)
                                if isfield(optionspec.(field),'keydefault')
                                    optionvalue = optionspec.(field).keydefault;
                                else
                                    error(['SYNTAX ERROR IN ',func2str(method),...
                                        ': Unexpected keyword after key ',arg'.']);
                                end
                            end
                        else
                            i = i+1;
                            optionvalue = args{i};
                        end
                    elseif isfield(options.(field),'keydefault')
                        optionvalue = optionspec.(field).keydefault;
                    elseif isfield(options.(field),'default')
                        optionvalue = optionspec.(field).default;
                    else
                        error(['SYNTAX ERROR IN ',func2str(method),...
                            ': A string should follow the key ',arg'.']);
                    end
                elseif strcmpi(type,'Boolean')
                    if length(args) > i && ...
                            (isnumeric(args{i+1}) || islogical(args{i+1}))
                        i = i+1;
                        optionvalue = args{i};
                    elseif length(args) > i && ischar(args{i+1}) ...
                            && (strcmpi(args{i+1},'on') || ...
                                strcmpi(args{i+1},'yes'))
                        i = i+1;
                        optionvalue = 1;
                    elseif length(args) > i && ischar(args{i+1}) ...
                            && (strcmpi(args{i+1},'off') || ...
                                strcmpi(args{i+1},'no'))
                        i = i+1;
                        optionvalue = 0;
                    else
                        optionvalue = 1;
                    end
                elseif strcmpi(type,'Numeric') || strcmpi(type,'Unit')
                    if length(args) > i && isnumeric(args{i+1})
                        i = i+1;
                        optionvalue = args{i};
                    elseif isfield(optionspec.(field),'keydefault')
                        if strcmpi(type,'Integers')
                            optionvalue = optionspec.(field).keydefault;
                        else
                            optionvalue = optionspec.(field).keydefault(1);
                        end
                    elseif isfield(option.(field),'default')
                        if strcmpi(type,'Integers')
                            optionvalue = optionspec.(field).default;
                        else
                            optionvalue = optionspec.(field).default(1);
                        end
                    else
                        error(['SYNTAX ERROR IN ',func2str(method),...
                            ': An integer should follow the key ',arg'.']);
                    end
                    if isfield(optionspec.(field),'number')...
                            && optionspec.(field).number == 2
                        if length(args) > i && isnumeric(args{i+1})
                            i = i+1;
                            optionvalue = [optionvalue args{i}];
                        elseif isfield(options.(field),'keydefault')
                            optionvalue = [optionvalue optionspec.(field).keydefault(2)];
                        elseif isfield(options.(field),'default')
                            optionvalue = [optionvalue optionspec.(field).default(2)];
                        else
                            error(['SYNTAX ERROR IN ',func2str(method),...
                            ': Two integers should follow the key ',arg'.']);
                        end
                    end
                    if strcmpi(type,'Unit')
                        unit = optionspec.(field).unit;
                        value = optionvalue;
                        optionvalue = struct;
                        optionvalue.value = value;
                        found = 0;
                        if length(args) > i && ischar(args{i+1})
                            for j = 1:length(unit)
                                if strcmpi(args{i+1},unit{j})
                                    i = i+1;
                                    optionvalue.unit = args{i};
                                    found = 1;
                                    break
                                end
                            end
                        end
                        if ~found
                            optionvalue.unit = unit{1};
                        end
                    end
                else
                    if length(args) > i
                        i = i+1;
                        optionvalue = args{i};
                    elseif isfield(options.(field),'keydefault')
                        optionvalue = optionspec.(field).keydefault(1);
                    else
                        error(['SYNTAX ERROR IN MUS.SCORE: ',...
                            'Data should follow the key ',arg'.']);
                    end
                end
                
                %if strcmp(field,'extract')
                %    extract = optionvalue;
                %end
            end
        elseif isfield(options.(field),'choice')
            choices = optionspec.(field).choice;
            for j = 1:length(choices)
                if strcmpi(arg,choices{j})
                    match = 1;
                    optionvalue = arg;
                end
            end
        end    
        if match
            options.(field) = optionvalue;
        end
    end
    if ~match
        if isnumeric(arg) || islogical(arg)
            arg = num2str(arg);
        end
        error(['SYNTAX ERROR IN MUS.SCORE: Unknown parameter ',arg'.']);
    end
    i = i+1;
end