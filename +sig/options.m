% SIG.OPTIONS
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function [during after frame extract] = options(options,args,name)

during = struct;
after = [];
extract = [];

if isfield(options,'fsize')
    frame.toggle = options.frame.default;
    frame.size = options.fsize.default;
    frame.hop = options.fhop.default;
else
    frame = [];
end

if isa(options,'function_handle')
    options = options(.05,.5);
end
fields = fieldnames(options);
for i = 1:length(fields)
    field = fields{i};
    if ~max(strcmpi(field,{'frame','fsize','fhop'}))
        if isfield(options.(field),'when') && ...
                (strcmpi(options.(field).when,'After') || ...
                 strcmpi(options.(field).when,'Both'))
            if isfield(options.(field),'default')
                after.(field) = options.(field).default;
            else
                after.(field) = 0;
            end
        end
        if not(isfield(options.(field),'when')) || ...
                strcmpi(options.(field).when,'Both')
            if isfield(options.(field),'default')
                during.(field) = options.(field).default;
            else
                during.(field) = 0;
            end
        end
    end
end

i = 2;
while i <= length(args)
    arg = args{i};
    match = 0;
    k = 0;
    while not(match) && k<length(fields)
        k = k+1;
        field = fields{k};
        if isfield(options.(field),'key')
            key = options.(field).key;
            if not(iscell(key))
                key = {key};
            end
            for j = 1:length(key)
                if strcmpi(arg,key{j})
                    match = 1;
                end
            end
            if match
                if isfield(options.(field),'type')
                    type = options.(field).type;
                else
                    type = [];
                end
                if strcmpi(type,'String')
                    if length(args) > i && ...
                            (ischar(args{i+1}) || args{i+1} == 0)
                        if isfield(options.(field),'choice')
                            match2 = 0;
                            arg2 = args{i+1};
                            for j = options.(field).choice
                                if (ischar(j{1}) && strcmpi(arg2,j)) || ...
                                   (not(ischar(j{1})) && isequal(arg2,j{1}))
                                        match2 = 1;
                                        i = i+1;
                                        optionvalue = arg2;
                                end
                            end
                            if not(match2)
                                if isfield(options.(field),'keydefault')
                                    optionvalue = options.(field).keydefault;
                                else
                                    error(['SYNTAX ERROR IN ',name,...
                                        ': Unexpected keyword after key ',arg'.']);
                                end
                            end
                        else
                            i = i+1;
                            optionvalue = args{i};
                        end
                    elseif isfield(options.(field),'keydefault')
                        optionvalue = options.(field).keydefault;
                    elseif isfield(options.(field),'default')
                        optionvalue = options.(field).default;
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
                    if length(args) > i && (isnumeric(args{i+1}) || ...
                                            iscell(args{i+1}))
                        i = i+1;
                        optionvalue = args{i};
                    elseif isfield(options.(field),'keydefault')
                        if strcmpi(type,'Integers')
                            optionvalue = options.(field).keydefault;
                        else
                            optionvalue = options.(field).keydefault(1);
                        end
                    elseif isfield(options.(field),'default')
                        if strcmpi(type,'Integers')
                            optionvalue = options.(field).default;
                        else
                            optionvalue = options.(field).default(1);
                        end
                    else
                        error(['SYNTAX ERROR IN ',func2str(method),...
                            ': An integer should follow the key ',arg'.']);
                    end
                    if isfield(options.(field),'number')...
                            && options.(field).number == 2
                        if length(args) > i && isnumeric(args{i+1})
                            i = i+1;
                            optionvalue = [optionvalue args{i}];
                        elseif isfield(options.(field),'keydefault')
                            optionvalue = [optionvalue options.(field).keydefault(2)];
                        elseif isfield(options.(field),'default')
                            optionvalue = [optionvalue options.(field).default(2)];
                        else
                            error(['SYNTAX ERROR IN ',func2str(method),...
                            ': Two integers should follow the key ',arg'.']);
                        end
                    end
                    if strcmpi(type,'Unit')
                        unit = options.(field).unit;
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
                        optionvalue = options.(field).keydefault(1);
                    else
                        error(['SYNTAX ERROR IN ',name,...
                            ': Data should follow the key ',arg'.']);
                    end
                end
                
                if strcmp(field,'extract')
                    extract = optionvalue;
                end
            end
        elseif isfield(options.(field),'choice')
            choices = options.(field).choice;
            for j = 1:length(choices)
                if strcmpi(arg,choices{j})
                    match = 1;
                    optionvalue = arg;
                end
            end
        elseif strcmpi(field,'frame')
            match = 0;
        elseif i == 2
            match = 1;
            optionvalue = arg;
        end    
        if match
            if strcmpi(field,'frame') % && options.frame.auto
                frame.toggle = optionvalue;
            elseif strcmpi(field,'fsize')
                frame.size = optionvalue;
                frame.toggle = 1;
            elseif strcmpi(field,'fhop')
                frame.hop = optionvalue;
                frame.toggle = 1;
            elseif strcmpi(field,'frameconfig')
                frame = optionvalue;
            else
                if isfield(options.(field),'when') ...
                        && (strcmpi(options.(field).when,'After') || ...
                            strcmpi(options.(field).when,'Both'))
                    after.(field) = optionvalue;
                end
                if not(isfield(options.(field),'when')) ...
                        || strcmpi(options.(field).when,'Both')
                    during.(field) = optionvalue;
                end
            end
        end
    end
    if ~match
        if isnumeric(arg) || islogical(arg)
            arg = num2str(arg);
        end
        error(['SYNTAX ERROR IN ',name,...
            ': Unknown parameter ',arg'.']);
    end
    i = i+1;
end
if isfield(options,'frame') && isfield(options.frame,'when') && strcmpi(options.frame.when,'After')
    after.frame = frame;
    frame = [];
end