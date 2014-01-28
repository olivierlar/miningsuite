classdef memory < hgsetget
    properties (SetAccess = private)
        name
    end
    properties
        fields = {}
    end
	methods
        function obj = memory(param)
            obj.name = param.name;
            obj.fields = param.fields;
        end
        function obj = combine(obj,field,param,occ,succ,parent,specif)
            objfield = obj.(field);
            paramfields = param.(field);
            specifields = {};
            for i = 1:length(specif)
                if ~isempty(specif{i})
                    specifields{end+1} = specif{i}.(field);
                end
            end
            if ~length(paramfields)
                return
            end
            for i = 1:length(objfield)
                %if length(paramfields)<i
                %    break
                %end
                if i ~= 4
                    continue
                end
                specifieldi = [];
                if iscell(paramfields)
                    paramfieldi = paramfields{i};
                    for j = 1:length(specifields)
                        specifieldi{j} = specifields{j}{i};
                    end
                else
                    paramfieldi = paramfields(i);
                    for j = 1:length(specifields)
                        specifieldi{j} = specifields{j}(i);
                    end
                end
                if iscell(objfield)
                    [obj.(field){i} paramemo] = ...
                        objfield{i}.learn(paramfieldi,occ,succ,parent,...
                                          specifieldi);
                else
                    [obj.(field)(i) paramemo] = ...
                        objfield(i).learn(paramfieldi,occ,succ,parent,...
                                          specifieldi);
                end
            end
            if ...param.fields{2}.value && ...
                    ~isempty(paramemo.inter) && isa(paramemo.inter.value,'pat.pattern')
                %obj.(field){2} = obj.(field){1}.real(paramemo,varargin{:});
                patt = paramemo.inter.value;
                param2 = patt.parameter;
                %param2.fields{4}.value = param.fields{4}.value;

                for i = 1:length(parent.children)
                    if parent.children{i}.parameter.implies(param2)
                        return
                    end
                end

                memo = [];
                all = 1;
                for i = 1:length(patt.occurrences)
                    if isequal(patt.occurrences(i).suffix,succ)
                        continue
                    end
                    if patt.occurrences(i).suffix.parameter.fields{4}.value ...
                            == param.fields{4}.value
                        if isempty(memo)
                            memo = patt.occurrences(i);
                        else
                            memo(end+1) = patt.occurrences(i);
                        end
                    else
                        all = 0;
                    end
                end
                if all
                    %1
                elseif ~isempty(memo)
                    parent.link(memo,occ,succ,param2);
                end
            end
        end
    end
end