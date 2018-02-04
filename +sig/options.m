% SIG.OPTIONS
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function [options,extract] = options(specif,args,name)

options = struct;
extract = [];

if isa(specif,'function_handle')
    specif = specif(.05,.5);
end
fields = fieldnames(specif);
for i = 1:length(fields)
    field = fields{i};
    if isfield(specif.(field),'default')
        if isfield(specif.(field),'type') && strcmpi(specif.(field).type,'Unit') && isfield(specif.(field),'defaultunit')
            options.(field).value = specif.(field).default;
            options.(field).unit = specif.(field).defaultunit;
        else
            options.(field) = specif.(field).default;
        end
    else
        options.(field) = 0;
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
        if isfield(specif.(field),'key')
            key = specif.(field).key;
            if not(iscell(key))
                key = {key};
            end
            for j = 1:length(key)
                if strcmpi(arg,key{j})
                    match = 1;
                end
            end
            if match
                if isfield(specif.(field),'type')
                    type = specif.(field).type;
                else
                    type = [];
                end
                if strcmpi(type,'String')
                    if length(args) > i && ...
                            (ischar(args{i+1}) || args{i+1} == 0 || args{i+1} == 1)
                        if isfield(specif.(field),'choice')
                            match2 = 0;
                            arg2 = args{i+1};
                            for j = specif.(field).choice
                                if (ischar(j{1}) && strcmpi(arg2,j)) || ...
                                   (not(ischar(j{1})) && isequal(arg2,j{1}))
                                        match2 = 1;
                                        i = i+1;
                                        optionvalue = arg2;
                                end
                            end
                            if not(match2)
                                if isfield(specif.(field),'keydefault')
                                    optionvalue = specif.(field).keydefault;
                                elseif isfield(specif.(field),'default')
                                    optionvalue = specif.(field).default;
                                else
                                    error(['SYNTAX ERROR IN ',name,...
                                        ': Unexpected keyword after key ',arg'.']);
                                end
                            end
                        else
                            i = i+1;
                            optionvalue = args{i};
                        end
                    elseif isfield(specif.(field),'keydefault')
                        optionvalue = specif.(field).keydefault;
                    elseif isfield(specif.(field),'default')
                        optionvalue = specif.(field).default;
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
                    elseif isfield(specif.(field),'keydefault')
                        optionvalue = specif.(field).keydefault;
                    elseif isfield(specif.(field),'default')
                        optionvalue = specif.(field).default;
                    else
                        error(['SYNTAX ERROR IN ',func2str(method),...
                            ': An integer should follow the key ',arg'.']);
                    end
                    if isfield(specif.(field),'number')...
                            && specif.(field).number == 2
                        if length(args) > i && isnumeric(args{i+1})
                            i = i+1;
                            optionvalue = [optionvalue args{i}];
                        elseif isfield(specif.(field),'keydefault')
                            optionvalue = [optionvalue specif.(field).keydefault(2)];
                        elseif isfield(specif.(field),'default')
                            optionvalue = [optionvalue specif.(field).default(2)];
                        else
                            error(['SYNTAX ERROR IN ',func2str(method),...
                            ': Two integers should follow the key ',arg'.']);
                        end
                    end
                    if strcmpi(type,'Unit')
                        unit = specif.(field).unit;
                        value = optionvalue;
                        optionvalue = struct;
                        optionvalue.value = value;
                        found = 0;
                        if length(args) > i && ischar(args{i+1})
                            for j = 1:length(unit)
                                if strcmpi(args{i+1},unit{j})
                                    i = i+1;
                                    if j == 2 && isfield(specif.(field),'opposite')
                                        field = specif.(field).opposite;
                                        optionvalue.value = 1/value;
                                        optionvalue.unit = unit{1};
                                    else
                                        optionvalue.unit = args{i};
                                    end
                                    found = 1;
                                    break
                                end
                            end
                        end
                        if ~found
                            if isfield(specif.(field),'defaultunit')
                                optionvalue.unit = specif.(field).defaultunit;
                            else
                                optionvalue.unit = unit{1};
                            end
                        end
                        if strcmp(field,'fsize') || strcmp(field,'fhop')
                            options.frame = 1;
                        end
                    end
                else
                    if length(args) > i
                        i = i+1;
                        optionvalue = args{i};
                    elseif isfield(specif.(field),'keydefault')
                        optionvalue = specif.(field).keydefault(1);
                    else
                        error(['SYNTAX ERROR IN ',name,...
                            ': Data should follow the key ',arg'.']);
                    end
                end
                
                if strcmp(field,'extract')
                    extract = optionvalue;
                end
            end
        elseif isfield(specif.(field),'choice')
            choices = specif.(field).choice;
            for j = 1:length(choices)
                if strcmpi(arg,choices{j})
                    match = 1;
                    optionvalue = arg;
                end
            end
        elseif isfield(specif.(field),'position') && ...
                specif.(field).position == i
             match = 1;
             optionvalue = arg;
        end    
        if match
            options.(field) = optionvalue;
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