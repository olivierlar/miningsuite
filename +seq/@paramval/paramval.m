classdef paramval < seq.param
    properties (SetAccess = private)
        type
    end
    properties
        value
        inter
        setgeneral
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
            if ~isempty(obj.setgeneral)
                val = obj.setgeneral;
                return
            end
            if isempty(obj.type.general) || isempty(obj.value)
                val = [];
                return
            end
            val = seq.paramval(obj.type.general(1),...
                               obj.type.general(1).func(obj.value));
            for i = 2:length(obj.type.general)
                val(i) = seq.paramval(...
                               obj.type.general(i),...
                               obj.type.general(i).func(obj.value));
            end
        end
        function val = nogeneral(obj)
            val = isempty(obj.setgeneral) && ...
                (isempty(obj.type.general) || isempty(obj.value));
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
            if isempty(obj1.value) || isempty(obj2.value)
                val = [];
            elseif isstruct(obj1.value)
                fields = fieldnames(obj1.value);
                for i = 1:length(fields)
                    if strcmp(fields{i},'bar')
                        val.bar = [];
                        continue
                    end
                    if isequal(obj1.value.(fields{i}),...
                               obj2.value.(fields{i}))
                        val.(fields{i}) = obj1.value.(fields{i});
                    else
                        if strcmp(fields{i},'letter')
                            val = [];
                            break
                        elseif strcmp(fields{i},'number')
                            %if sign(obj1.value.number) == ...
                            %        sign(obj2.value.number)
                            %    val.number = sign(obj1.value.number) * Inf;
                            %else
                                val = [];
                                break
                            %end
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
                    val = common(obj1.inter,obj2.inter);
                elseif isequal(obj1.inter,obj2.inter)
                    val = obj1.inter;
                else
                    val = [];
                end
                if 0 %~isempty(val) && strcmp(obj.name,'onset')
                    return
                    obj.name = 'rhythm';
                    obj.type.name = 'rhythm';
                    obj.value = 1;
                else
                    obj.inter = val;
                end
                if 1 %isempty(val)
                    if obj2.nogeneral
                        obj.setgeneral = [];
                    else
                        g1 = obj1.general;
                        g2 = obj2.general;
                        obj.setgeneral = g1;
                        for i = 1:length(g1)
                            if isa(g1(i),'seq.paramval')
                                obj.setgeneral(i) = common(g1(i),g2(i));
                            end
                        end
                    end
                end
            end
        end
        function [test, param] = implies(obj1,obj2,pos)
            if nargout < 2
                test = implies_fast(obj1,obj2);
                return
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
                param.value = [];
            elseif isstruct(obj1.value)
                test = true;
                f = fields(obj1.value);
                for i = 1:length(f)
                    if ~isempty(obj2.value.(f{i})) && ...
                            (isempty(obj1.value.(f{i})) || ...
                             ... % Below is gross contour comparison:
                             (~(isinf(obj2.value.(f{i})) && ...
                               sign(obj1.value.(f{i})) == ...
                                sign(obj2.value.(f{i}))) && ...
                              ...
                              obj1.value.(f{i}) ~= obj2.value.(f{i})))
                        test = false;
                        param.value.(f{i}) = [];
                    end
                end
                if strcmp(obj1.name,'dia') && ...
                        isempty(param.value.letter)
                    param.value.accident = [];
                    param.value.octave = [];
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
            if isempty(obj1) || isempty(obj1.general)
                param.setgeneral = [];
                if ~isempty(obj2.general)
                    test = 0;
                end
            else
                for i = 1:length(obj2.general)
                    [testi, param.setgeneral(i)] = ...
                                obj1.general(i).implies(obj2.general(i));
                    test = test & testi;
                end
            end
            if isempty(obj1) || isempty(obj1.inter)
                param.inter = [];
                if ~isempty(obj2.inter)
                    test = 0;
                end
            else
                for i = 1:length(obj2.inter)
                    [testi, param.inter(i)] = ...
                                obj1.inter(i).implies(obj2.inter(i));
                    test = test & testi;
                end
            end
            %if ~isempty(pos) && ~isempty(pos.inter) && ...
            %        strcmp(obj2.name,'rhythm') && ...
            %        abs(obj1.inter.value - pos.inter.value)<0.02
            %    test = 1;
            %end
        end
        function test = implies_fast(obj1,obj2)
            if isa(obj2,'seq.paramtype') || isempty(obj2)
                test = true;
                return
            end
            if (isempty(obj1) || isempty(obj1.inter)) && ...
                    ~isempty(obj2.inter)
                test = false;
                return
            end
            if isempty(obj2.value)
            elseif isempty(obj1) || isempty(obj1.value)
                test = false;
                return
            elseif isstruct(obj1.value)
                f = fields(obj1.value);
                for i = 1:length(f)
                    if ~isempty(obj2.value.(f{i})) && ...
                            (isempty(obj1.value.(f{i})) || ...
                             ... % Below is gross contour comparison:
                             (~(isinf(obj2.value.(f{i})) && ...
                               sign(obj1.value.(f{i})) == ...
                                sign(obj2.value.(f{i}))) && ...
                              ...
                              obj1.value.(f{i}) ~= obj2.value.(f{i})))
                        test = false;
                        return
                    end
                end
            else
                if isnumeric(obj1.value)
                    test = abs(obj1.value-obj2.value)<0.02;
                else
                    test = isequal(obj1.value,obj2.value);
                end
                if ~test
                    return
                end
            end
            for i = 1:length(obj2.general)
                if isempty(obj1.general)
                    test = false;
                    return
                end
                test = obj1.general(i).implies(obj2.general(i));
                if ~test
                    return
                end
            end
            for i = 1:length(obj2.inter)
                test = obj1.inter(i).implies(obj2.inter(i));
                if ~test
                    return
                end
            end
            test = true;
        end
        function test = isequal(obj1,obj2)
            if isa(obj1,'seq.paramtype') || isa(obj2,'seq.paramtype')
                test = isa(obj1,'seq.paramtype') && ...
                       isa(obj2,'seq.paramtype');
                return
            elseif isempty(obj1)
                test = isempty(obj2) || isempty(obj2.value);
                return
            elseif isempty(obj2)
                test = isempty(obj1) || isempty(obj1.value);
                return
            elseif isempty(obj1.value) || isempty(obj2.value)
                if ~isempty(obj1.value)
                    if isstruct(obj1.value)
                        f1 = fields(obj1.value);
                        for i = 1:length(f1)
                            if ~isempty(obj1.value.(f1{i}))
                                test = false;
                                return
                            end
                        end
                    else
                        test = false;
                        return
                    end
                elseif ~isempty(obj2.value)
                    if isstruct(obj2.value)
                        f2 = fields(obj2.value);
                        for i = 1:length(f2)
                            if ~isempty(obj2.value.(f2{i}))
                                test = false;
                                return
                            end
                        end
                    else
                        test = false;
                        return
                    end
                end
                if obj1.nogeneral
                    g2 = obj2.general;
                    for i = 1:length(g2)
                        if ~isempty(g2(i).value)
                            test = false;
                            return
                        end
                    end
                elseif obj2.nogeneral
                    g1 = obj1.general;
                    for i = 1:length(g1)
                        if ~isempty(g1(i).value)
                            test = false;
                            return
                        end
                    end
                else
                    g1 = obj1.general;
                    g2 = obj2.general;
                    for i = 1:length(g1)
                        test = isequal(g1(i),g2(i));
                        if ~test
                            return
                        end
                    end
                end
                test = true;
            elseif isstruct(obj1.value)
                test = true;
                f = fields(obj1.value);
                for i = 1:length(f)
                    if isempty(obj2.value.(f{i}))
                        test = isempty(obj1.value.(f{i}));
                    % Below is gross contour comparison:
                    elseif isinf(obj2.value.(f{i}))
                        test = isinf(obj1.value.(f{i}));
                        break % We don't look at interval quality
                    else
                        test = isequal(obj1.value.(f{i}),obj2.value.(f{i}));
                    end
                    if ~test
                        return
                    end
                end
            elseif isnumeric(obj1.value)
                test = abs(obj1.value-obj2.value)<0.02;
            else
                test = isequal(obj1.value,obj2.value);
            end
            if ~test
                return
            end
            if isempty(obj1.inter) || isempty(obj2.inter)
                test = isempty(obj1.inter) && isempty(obj2.inter);
            else
                for i = 1:length(obj2.inter)
                    test = obj1.inter(i).isequal(obj2.inter(i));
                    if ~test
                        break
                    end
                end
            end
        end
        function test = isdefined(obj,patt)
            if ~isempty(obj.value)
                if isstruct(obj.value)
                    if isfield(obj.value,'number')
                        test = ~isempty(obj.value.number);
                    elseif isfield(obj.value,'letter')
                        test = ~isempty(obj.value.letter);
                    elseif isfield(obj.value,'inbar')
                        test = ~isempty(obj.value.inbar);
                    else
                        error
                    end
                else
                    test = ~strcmp(obj.name,'channel');
                end
            elseif isempty(obj.inter)
                for i = 1:length(obj.general)
                    if obj.general(i).isdefined
                        test = 1;
                        return
                    end
                end
                test = 0;
            else
                test = obj.inter.isdefined;
            end
        end
        %function test = isempty(obj)
        %    test = and(isempty(obj.value),isempty(obj.inter));
        %end
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
        function obj = nointer(obj)
            obj.inter = [];
        end
        function txt = display(obj,varargin)
            head = obj.type.name;
            if ~isempty(head)
                head = head(1);
            end
            if isempty(obj.inter)
                txt = '';
            elseif isempty(obj.inter.value)
                txt = '';
                for i = 1:length(obj.inter.general)
                    if obj.inter.general(i).isdefined
                        switch i
                            case 1
                                if ~isempty(obj.inter.general(i).value)
                                    txt = [txt '[',...
                                        num2str(obj.inter.general(i).value),...
                                        ']'];
                                end
                            case 2
                                if obj.inter.general(i).value > 0
                                    txt = [txt '+'];
                                else
                                    txt = [txt '-'];
                                end
                        end
                    end
                end
            else
                [head txt] = displayval(head,obj.inter.value,1);
            end
            if isempty(obj.value)
                for i = 1:length(obj.general)
                    txt = [txt display(obj.general(i),1)];
                end
            else
                [head txt2] = displayval(head,obj.value);
                if isempty(txt) && isempty(txt2)
                    txt = [];
                else
                    txt = [txt ':' txt2];
                end
            end
            if ~isempty(txt) && ~isempty(head)
                txt = [head txt ' ']; %':' txt ' '];
            end
            if nargin == 1
                disp(txt)
            end
        end
        function tab = tabulize(obj,tab)
            if isstruct(obj.value)
                f = fields(obj.value);
                for i = 1:length(f)
                    tab(end+1) = obj.value.(f{i});
                end
            elseif isempty(obj.value)
                tab(end) = NaN;
            else
                tab(end+1) = obj.value;
            end
            if ~isempty(obj.inter)
                tab = obj.inter.tabulize(tab);
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
        %head = '';
        txt = '';
        field = fields(val);
        %par = 0;
        for i = 1:length(field)
            if isempty(val.(field{i}))
                continue
            end
            %if i > 1 && ~par
            %    txt = [txt '('];
            %    par = 1;
            %end
            if strcmp(field{i},'accident')
                switch val.(field{i}) 
                    case 0
                        txt2 = '=';
                    case +1
                        txt2 = '#';
                    case -1
                        txt2 = 'b';
                    otherwise
                        txt2 = 'ERROR';
                end
                txt = [txt txt2];
            elseif strcmp(field{i},'quality')
                switch val.(field{i}) 
                    case 0
                        txt2 = 'M';
                    case +1
                        txt2 = '+';
                    case -1
                        txt2 = 'm';
                    case -2
                        txt2 = '-';
                    otherwise
                        txt2 = 'ERROR';
                end
                txt = [txt txt2];
            elseif strcmp(field{i},'number') && isinf(val.(field{i}))
                if sign(val.(field{i})) == 1
                    txt = '+';
                else
                    txt = '-';
                end
                break
            else
                if i > 1
                    txt = [txt field{i}(1)];
                end
                txt = [txt relnum2str(val.(field{i}),inter)];
            end
        end
        %if par
        %    txt = [txt ')'];
        %end
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