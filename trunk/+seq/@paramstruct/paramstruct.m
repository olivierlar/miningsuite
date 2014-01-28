classdef paramstruct < seq.param
    properties
        fields
        names
        iscell
    end
	methods
        function obj = paramstruct(title,names,iscell)
            if nargin < 1
                title = '';
            end
            if nargin < 2
                names = [];
            end
            if nargin < 3
                iscell = 0;
            end
            obj = obj@seq.param(title);
            obj.names = names;
            obj.iscell = iscell;
        end
        function obj = type2val(obj)
            if obj.iscell
                for i = 1:length(obj.fields)
                    if isnumeric(obj.fields{i})
                        obj.fields{i} = [];
                    elseif isstruct(obj.fields{i})
                        obj.fields{i} = struct;
                    else
                        obj.fields{i} = obj.fields{i}.type2val;
                    end
                end
            else
                obj.fields = seq.paramval(obj.fields(1),0);
            end
        end
        function y = getfield(obj,name,varargin)
            f = find(strcmp(name,obj.names));
            if obj.iscell
                y = obj.fields{f};
            else
                y = obj.fields(f);
            end
            if nargin > 2
                y = y.getfield(varargin{:});
            end
        end
        function obj = setfield(obj,name,varargin)
            f = find(strcmp(name,obj.names));
            x = varargin{end};
            if nargin == 3
                if obj.iscell
                    obj.fields{f} = x;
                elseif ~length(obj.fields)
                    obj.fields = x;
                else
                    obj.fields(f) = x;
                end
            else
                if obj.iscell
                    obj.fields{f} = obj.fields{f}.setfield(varargin{:});
                elseif ~length(obj.fields)
                    obj.fields = obj.fields.setfield(varargin{:});
                else
                    obj.fields(f) = obj.fields(f).setfield(varargin{:});
                end
            end
        end
        function obj = paraminter(obj1,obj2)
            obj = obj1;
            f = cell(1,length(obj1.fields));
            if iscell(obj1.fields)
                for i = 1:length(obj1.fields)
                    if isempty(obj1.fields{i}) || isempty(obj2.fields{i})
                        f{i} = [];
                    else
                        f{i} = paraminter(obj1.fields{i},obj2.fields{i});
                    end
                end
            else
                for i = 1:length(obj1.fields)
                    if isempty(obj1.fields(i)) || isempty(obj2.fields(i))
                        f{i} = [];
                    else
                        f{i} = paraminter(obj1.fields(i),obj2.fields(i));
                    end
                end
            end
            obj.fields = f;
        end
        function obj2 = inter(obj1)
            obj2 = obj1;
            f = cell(1,length(obj1.fields));
            if iscell(obj1.fields)
                for i = 1:length(obj1.fields)
                    f{i} = obj1.fields{i}.inter;
                end
            else
                for i = 1:length(obj1.fields)
                    f{i} = obj1.fields(i).inter;
                end
            end
            obj2.fields = f;
        end
        function obj = common(obj1,obj2,varargin)
            obj = obj1;
            f = obj1.fields;
            %if obj1.fields{1}.common(obj2.fields{1}).isdefined
            %    f{2}.value = 1;
            %end
            %if isa(f{1},'seq.paramval')
            %    f{1}.value = [];
            %    f{1}.inter = [];
            %end
            %f{3} = common(obj1.fields{3},obj2.fields{3});
            %f{4} = common(obj1.fields{4},obj2.fields{4});
            for i = 1:length(obj1.fields)
                if i ~= 4
                    f{i} = [];
                    continue
                end
                if iscell(obj1.fields)
                    fields1 = obj1.fields{i};
                else
                    fields1 = obj1.fields(i);
                end
                if iscell(obj2.fields)
                    fields2 = obj2.fields{i};
                else
                    fields2 = obj2.fields(i);
                end
                if isempty(fields1) || isempty(fields2)
                    f{i} = [];
                else
                    f{i} = common(fields1,fields2,varargin{:});
                end
            end
            obj.fields = f;
        end
        function [test param] = implies(obj1,obj2,context)
            test = true;
            param = obj2;
            for i = 1:length(obj1.fields)
                %if i == 2
                %    continue
                %end
                if length(obj1.fields)<i || length(obj2.fields)<i
                    break
                end
                if iscell(obj1.fields)
                    fields1 = obj1.fields{i};
                else
                    fields1 = obj1.fields(i);
                end
                if iscell(obj2.fields)
                    fields2 = obj2.fields{i};
                else
                    fields2 = obj2.fields(i);
                end
                if iscell(obj2.fields)
                    if isempty(fields1)
                        testi = isempty(fields2) || ...
                                isa(fields2,'seq.paramtype') || ...
                                (isempty(fields2.value) && ...
                                 isempty(fields2.inter));
                    elseif nargin>2
                        [testi param.fields{i}] = implies(fields1,fields2,...
                                                context.fields{i});
                    else
                        [testi param.fields{i}] = implies(fields1,fields2);
                    end
                else
                    [testi param.fields(i)] = implies(fields1,fields2);
                end
                test = test & testi;
            end
        end
        function test = isequal(obj1,obj2) %,varargin)
            if obj1.implies(obj2) && obj2.implies(obj1);
                test = true;
                return
            end
            
            test = true;
            for i = 1:length(obj1.fields)
                if iscell(obj1.fields)
                    fields1 = obj1.fields{i};
                else
                    fields1 = obj1.fields(i);
                end
                if iscell(obj2.fields)
                    fields2 = obj2.fields{i};
                else
                    fields2 = obj2.fields(i);
                end
                if iscell(obj2.fields)
                    testi = isequal(fields1,fields2);%,varargin{:});
                else
                    testi = isequal(fields1,fields2);%,varargin{:});
                end
                test = test & testi;
            end
        end
        function test = isdefined(obj,patt)
            test = false;
            if nargin>1
                %if ~isempty(patt.parent) ...
                %        && (isempty(display(patt.parameter,1)) || ...
                %            isa(patt.parameter,'sig.paramtype')) ...
                %        && isempty(patt.parent.parent) ...
                %        && (isempty(patt.parent.parameter) || ...
                %            isempty(display(patt.parent.parameter,1))) ...
                %        && isempty(display(obj.inter,1))
                %    return
                %end
        %        if ~isempty(patt.parent) && ...
        %                (isa(patt.parameter.fields{3},'seq.paramtype') || ...
        %                 (isempty(patt.parameter.fields{3}.value) && ...
        %                  isempty(patt.parameter.fields{3}.inter))) && ...
        %                isempty(obj.fields{1}.inter) && ...
        %                isempty(obj.fields{2}) && ...
        %                isempty(obj.fields{3}.inter)
        %            return
        %        end
            end
            for i = 1:length(obj.fields)-1
                if iscell(obj.fields)
                    field = obj.fields{i};
                else
                    field = obj.fields(i);
                end
                if ~isempty(field) && field.isdefined
                    test = true;
                    return
                end
            end
        end
        function test = isvaldefined(obj)
            test = false;
            for i = 1:length(obj.fields)
                if iscell(obj.fields)
                    field = obj.fields{i};
                else
                    field = obj.fields(i);
                end
                if ~isempty(field) && field.isvaldefined
                    test = true;
                    return
                end
            end
        end
        function test = isinterdefined(obj)
            test = false;
            for i = 1:length(obj.fields)
                if iscell(obj.fields)
                    field = obj.fields{i};
                else
                    field = obj.fields(i);
                end
                if ~isempty(field) && field.isinterdefined
                    test = true;
                    return
                end
            end
        end
        function txt = display(obj,varargin)
            if length(obj) > 1
                for i = 1:length(obj)
                    display(obj(i));
                end
            else
                txt = '';
                if iscell(obj.fields)
                    for i = 1:length(obj.fields)
                        if not(isempty(obj.fields{i}))
                            txt = [txt display(obj.fields{i},1)];
                        end
                    end
                else
                    for i = 1:length(obj.fields)
                        if not(isempty(obj.fields(i)))
                            txt = [txt display(obj.fields(i),1)];
                        end
                    end
                end
                if nargin == 1 && ~isempty(txt)
                    disp(txt)
                end
            end
        end
        function obj = substract(obj1,obj2)
            obj = obj1;
            f = obj1.fields;
            if obj2.fields{2}.isdefined
                f{1}.value = [];
                f{1}.inter = [];
                f{2}.value = [];
            end
            f{3} = obj1.fields{3}.substract(obj2.fields{3});
            f{4} = obj1.fields{4};
            obj.fields = f;
        end
    end
end