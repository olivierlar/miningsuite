% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef memostruct < pat.memory
	methods
        function obj = memostruct(param,pattern)
            obj = obj@pat.memory(param);
            if iscell(obj.fields)
                f = cell(1,length(obj.fields));
                for i = 1:length(obj.fields)
                    if i == 9
                        continue
                    end
                    if isempty(obj.fields{i})
                        f{i} = [];
                    else
                        f{i} = pat.creatememory(obj.fields{i},pattern);
                    end
                end
                obj.fields = f;
            elseif not(isempty(obj.fields))
                f = pat.creatememory(obj.fields(1),pattern);
                for i = 2:length(obj.fields)
                    f(i) = pat.creatememory(obj.fields(i),pattern);
                end
                obj.fields = f;
            end
        end
        function obj = learn(obj,param,occ,succ,parent,specif,cyclic,root)
            if 1 %isempty(parent.parent) || ...
                 %   (~isa(parent.parameter.fields{4},'seq.paramtype') && ...
                 %    ~isempty(parent.parameter.fields{4}) && ...
                 %    ~isempty(parent.parameter.fields{4}.value))
                if isempty(specif)
                    specifmemo = [];
                else
                    for i = 1:length(specif)
                        specifmemo{i} = specif(i).memory;
                    end
                end
                
                if 1 %isempty(occ.suffix)
                    group = '';
                else
                    oldinter = occ.suffix.parameter.getfield('onset').inter;
                    if isempty(oldinter)
                        group = '';
                    else
                        oldinter = oldinter.value;
                        newinter = param.getfield('onset').inter.value;
                        if log(newinter/oldinter) > .8
                            group = 'close';
                        elseif log(oldinter/newinter) > .8
                            group = 'open';
                        else
                            group = 'extend';
                        end
                    end
                end
                
                obj = obj.combine('fields',param,group,occ,succ,parent,...
                                  specifmemo,cyclic,root);
            end
        end
        %function obj = shortcut(obj,param,child)
        %    obj = obj.combine('shortcut','fields',param,child);
        %end
	end
end