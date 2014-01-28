classdef paramval < seq.param
    properties (SetAccess = private)
        type
    end
    properties
        value
        inter
    end
    properties (Dependent)
        general
    end
	methods
        function obj = paramval(type,val)
            obj = obj@seq.param(type.name);
            obj.type = type;
            obj.value = val;
        end
        function val = get.general(obj)
            if isempty(obj.type.general)
                val = [];
            else
                if isempty(obj.value)
                    val = [];
                else
                    val = seq.paramval(obj.type.general(1),...
                                       obj.type.general(1).func(obj.value));
                    for i = 2:length(obj.type.general)
                        val(i) = seq.paramval(...
                                       obj.type.general(i),...
                                       obj.type.general(i).func(obj.value));
                    end
                end
            end
        end
        %function obj = reset(obj)
        %    obj.value = [];
        %end
        function obj = paraminter(obj1,obj2)
            obj = obj2;
            if ~isempty(obj1.type.inter)
                try
                    func = obj1.type.inter.func;
                    general = obj.type.inter.general;
                catch
                    func = obj1.type.inter.fields{1}.func; %%% WHY???
                    general = obj.type.inter.fields{1}.general;
                end
                obj.inter = seq.paramval(...
                                seq.paramtype,...
                                func(obj2.value,obj1.value));
                obj.inter.type.general = general;
            end
        end
        function obj = common(obj1,obj2,pos)
            if isempty(obj2)
                obj = obj2;
                return
            end
            if nargin<3
                pos = '';
            end
            if isstruct(obj1.value)
                fields = fieldnames(obj1.value);
                for i = 1:length(fields)
                    if isequal(obj1.value.(fields{i}),...
                               obj2.value.(fields{i}))
                        val.(fields{i}) = obj1.value.(fields{i});
                    else
                        if strcmp(fields{i},'letter')
                            val = [];
                            break
                        else
                            val.(fields{i}) = [];
                        end
                    end
                end
            else
                if isnumeric(obj1.value)
                    test = abs(obj1.value-obj2.value)<0.02;
                else
                    test = isequal(obj1.value, obj2.value);
                end
                if test
                    val = obj1.value;
                else
                    val = [];
                end
            end
            obj = seq.paramval(obj1.type,val);
            if isempty(pos)
                if isstruct(obj1.inter)
                    fields = fieldnames(obj1.inter);
                    for i = 1:length(fields)
                        if isequal(obj1.inter.(fields{i}),...
                                   obj1.inter.(fields{i}))
                            val.(fields{i}) = obj1.inter.(fields{i});
                        else
                            val.(fields{i}) = [];
                        end
                    end
                elseif isa(obj1.inter,'seq.paramval')
                    val = common(obj1.inter,obj2.inter,pos);
                elseif isequal(obj1.inter,obj2.inter)
                    val = obj1.inter;
                else
                    val = [];
                end
                if ~isempty(val) && strcmp(obj.name,'onset')
                    obj.name = 'rhythm';
                    obj.type.name = 'rhythm';
                    obj.value = 1;
                else
                    obj.inter = val;
                end
            end
        end
        function [test param] = implies(obj1,obj2,pos)
            if nargin<3
                pos = '';
            end
            param = obj2;
            if isa(obj2,'seq.paramtype') || isempty(obj2) 
                test = true;
                return
            end
            if isempty(obj2.value)
                test = 1;
            elseif isempty(obj1) || isempty(obj1.value)
                test = 0;
            elseif isstruct(obj1.value)
                test = true;
                f = fields(obj1.value);
                for i = 1:length(f)
                    if ~isempty(obj2.value.(f{i})) && ...
                            (isempty(obj1.value.(f{i})) || ...
                             obj1.value.(f{i}) ~= obj2.value.(f{i}))
                        test = false;
                        break
                    end
                end
                if ~test
                    param.value = [];
                end
            else
                if isnumeric(obj1.value)
                    test = abs(obj1.value-obj2.value)<0.02;
                else
                    test = isequal(obj1.value,obj2.value);
                end
                if ~test
                    param.value = [];
                end
            end
            if isempty(pos)
                if isempty(obj1) || isempty(obj1.inter)
                    param.inter = [];
                    if ~isempty(obj2.inter)
                        test = 0;
                    end
                else
                    for i = 1:length(obj2.inter)
                        [testi param.inter(i)] = ...
                                    obj1.inter(i).implies(obj2.inter(i));
                        test = test & testi;
                    end
                end
            else
                if strcmp(obj2.name,'rhythm') && ~isempty(pos.inter) && ...
                        abs(obj1.inter.value - pos.inter.value)<0.02
                    test = 1;
                end
            end
            %if ~isempty(obj1.general)
            %    [testi param.general] = ...
            %                obj1.general.implies(obj2.general);
            %    test = test & testi;
            %end
        end
        function test = isdefined(obj,patt)
            if ~isempty(obj.value)
                test = 1;
            elseif isempty(obj.inter)
                test = 0;
            else
                test = obj.inter.isdefined;
            end
        end
        function test = isempty(obj)
            test = and(isempty(obj.value),isempty(obj.inter));
        end
        function test = isvaldefined(obj)
            test = ~isempty(obj.value);
        end
        function test = isinterdefined(obj)
            if isempty(obj.inter)
                test = 0;
            else
                test = obj.inter.isdefined;
            end
        end

        function txt = display(obj,varargin)
            head = obj.type.name;
            if ~isempty(obj.inter)
                [head txt] = displayval(head,obj.inter.value,1);
            else
                txt = '';
            end
            if isempty(obj.value)
                for i = 1:length(obj.general)
                    txt = [txt display(obj.general(i),1)];
                end
            else
                [head txt2] = displayval(head,obj.value);
                if isempty(txt)
                    txt = txt2;
                else
                    txt = [txt '= ' txt2];
                end
            end
            if ~isempty(txt) && ~isempty(head)
                txt = [head ':' txt ' '];
            end
            if nargin == 1
                disp(txt)
            end
        end
        function obj1 = substract(obj1,obj2)
            if isdefined(obj1) && isdefined(obj2)
                if obj1.value == obj2.value
                    obj1.value = [];
                end
                if ~isempty(obj1.inter)
                    1
                end
            end
        end
    end
end


function [head txt] = displayval(head,val,inter)
    if nargin < 3
        inter = 0;
    end
    if isa(val,'mus.pitch')
        val = mean(val.height);
    end
    if isstruct(val)
        head = '';
        txt = '';
        field = fields(val);
        for i = 1:length(field)
            txt = [txt field{i} ':' relnum2str(val.(field{i}),inter) ' '];
        end
    else
        txt = relnum2str(val,inter);
    end
end


function txt = relnum2str(num,inter)
    if isempty(num)
        txt = '';
    else
        if inter && num(1) >= 0 %remove (1), it was a tweak for rhythm
            txt = '+';
        else
            txt = '';
        end
        txt = [txt num2str(num(1))];
    end
end