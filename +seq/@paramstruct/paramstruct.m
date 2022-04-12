classdef paramstruct < seq.param
    properties
        fields
        names
        iscell
        validfield
    end
	methods
        function obj = paramstruct(title,names,iscell,validfield)
            if nargin < 1
                title = '';
            end
            if nargin < 2
                names = [];
            end
            if nargin < 3
                iscell = 0;
            end
            if nargin < 4
                validfield = @(i,options) true;
            end
            obj = obj@seq.param(title);
            obj.names = names;
            obj.iscell = iscell;
            obj.validfield = validfield;
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
            if isempty(f)
                y = [];
                return
            end
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
            %if isa(x,'seq.paramval') && ~isempty(x.type.general)
            %    x.general = x.type.general.func(x.value);
            %end
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
                    if ~isa(obj1.fields{i},'seq.paramval') || ...
                            ~isa(obj2.fields{i},'seq.paramval')
                        f{i} = obj2.fields{i};
                    else
                        f{i} = paraminter(obj1.fields{i},obj2.fields{i});
                    end
                end
            else
                for i = 1:length(obj1.fields)
                    if ~isa(obj1.fields(i),'seq.paramval') || ...
                            ~isa(obj2.fields(i),'seq.paramval')
                        f{i} = obj2.fields(i);
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
        function obj = common(obj1,obj2,options)
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
                if ~obj1.validfield(i,options)
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
                if isempty(fields1) && isempty(fields2)
                    f{i} = [];
                elseif isempty(fields1)
                    f{i} = fields2;
                    if isa(f{i},'seq.paramval')
                        f{i}.value = [];
                    end
                elseif isempty(fields2)
                    f{i} = fields1;
                    if isa(f{i},'seq.paramval')
                        f{i}.value = [];
                    end
                else
                    f{i} = common(fields1,fields2,options);
                end
            end
            obj.fields = f;
        end
        function obj1 = add(obj1,obj2)
            for i = 1:length(obj1.fields)
                if isempty(obj2.fields{i}) || ...
                        isa(obj2.fields{i},'seq.paramtype') || ...
                        isempty(obj2.fields{i}.inter)
                    continue
                end
                if isa(obj1.fields{i},'seq.paramtype')
                    obj1.fields{i} = obj2.fields{i};
                    continue
                end
                if isempty(obj1.fields{i}.inter.value) && ...
                        ~isempty(obj1.fields{i}.inter.general)
                    % obj1 is contour
                    if ~obj2.fields{i}.inter.implies(obj1.fields{i}.inter)
                        obj1.fields{i}.inter.setgeneral = [];
                    end
                elseif isempty(obj2.fields{i}.inter.value) && ...
                        ~isempty(obj2.fields{i}.inter.general)
                    % obj2 is contour
                    if obj2.fields{i}.inter.implies(obj1.fields{i}.inter)
                        obj1.fields{i}.inter.setgeneral = ...
                            obj2.fields{i}.inter.setgeneral;
                    else
                        obj1.fields{i}.inter.setgeneral = [];
                    end
                else
                    obj1.fields{i}.inter.value = ...
                        obj1.fields{i}.inter.value ...
                        + obj2.fields{i}.inter.value;
                end
            end
        end
        function [test param] = implies(obj1,obj2,context)
            if nargout < 2
                if nargin > 2
                    test = implies_fast(obj1,obj2,context);
                else
                    test = implies_fast(obj1,obj2);
                end
                return
            end
            test = true;
            param = obj2;
            for i = 1:length(obj1.fields)
                if isempty(obj2.fields{i})
                    continue
                end
                if nargin>2
                    [testi param.fields{i}] = implies(obj1.fields{i},...
                                                      obj2.fields{i},...
                                                      context.fields{i});
                else
                    [testi param.fields{i}] = implies(obj1.fields{i},...
                                                      obj2.fields{i});
                end
                test = test & testi;
            end
        end
        function test = implies_fast(obj1,obj2,context)
            test = true;
            for i = 1:length(obj1.fields)
                if isempty(obj2.fields{i})
                    continue
                end
                if nargin>2
                    test = implies_fast(obj1.fields{i},obj2.fields{i},...
                                        context.fields{i});
                else
                    test = implies_fast(obj1.fields{i},obj2.fields{i});
                end
                if ~test
                    break
                end
            end
        end
        function test = isequal(obj1,obj2,options) %,varargin)
            %if obj1.implies(obj2) && obj2.implies(obj1);
            %    test = true;
            %    return
            %end
            
            test = true;
            for i = 1:length(obj1.fields)
                if i < 2 || i > 4 || (i == 2 && ~options.chro) || ...
                        (i == 3 && ~options.dia) || ...
                        (i == 4 && ~options.onset)
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
            intertest = false;
            interdefine = nargin > 1 && ~isempty(patt.parent);
            for i = 1:length(obj.fields)-1
                if iscell(obj.fields)
                    field = obj.fields{i};
                else
                    field = obj.fields(i);
                end
                if ~isempty(field)
                    if field.isdefined
                        test = true;
                    end
                    if ~interdefine
                        if test
                            return
                        end
                    else
                        if ~isempty(field.inter) && field.inter.isdefined(patt)
                            intertest = true;
                        end
                        if test && intertest
                            return
                        end
                    end
                end
            end
            if test && interdefine && ~intertest
                test = false;
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
        function obj = nointer(obj)
            for i = 1:length(obj.fields)
                if iscell(obj.fields)
                    if isa(obj.fields{i},'seq.paramval')
                        obj.fields{i} = obj.fields{i}.nointer;
                    end
                else
                    if isa(obj.fields(i),'seq.paramval')
                        obj.fields(i) = obj.fields(i).nointer;
                    end
                end
            end
        end
        function txt = display(obj)
            if length(obj) > 1
                for i = 1:length(obj)
                    display(obj(i));
                end
            else
                txt = '';
                if iscell(obj.fields)
                    for i = 1:length(obj.fields)
                        if isa(obj.fields{i},'seq.paramval')
                            txt = [txt display(obj.fields{i},1)];
                        end
                    end
                else
                    for i = 1:length(obj.fields)
                        if isa(obj.fields(i),'seq.paramval')
                            txt = [txt display(obj.fields(i),1)];
                        end
                    end
                end
                disp(txt)
            end
        end
        function txt = simpledisplay(obj)
            if length(obj) > 1
                for i = 1:length(obj)
                    display(obj(i));
                end
            else
                txt = '';
                if iscell(obj.fields)
                    for i = 1:length(obj.fields)
                        if isa(obj.fields{i},'seq.paramval')
                            txt = [txt display(obj.fields{i},1)];
                        end
                    end
                else
                    for i = 1:length(obj.fields)
                        if isa(obj.fields(i),'seq.paramval')
                            txt = [txt display(obj.fields(i),1)];
                        end
                    end
                end
            end
        end
        function tab = tabulize(obj,tab)
            if nargin<2
                tab = [];
            end
            if iscell(obj.fields)
                for i = 1:length(obj.fields)
                    if ~isempty(obj.fields{i})
                        tab = obj.fields{i}.tabulize(tab);
                    end
                end
            else
                for i = 1:length(obj.fields)
                    if ~isempty(obj.fields(i))
                        tab = obj.fields(i).tabulize(tab);
                    end
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
        function res = undefined_pitch_parameter(obj)
        % to be checked..
            res = isempty(obj.fields{2}.value) && ...
                  isempty(obj.fields{2}.general) && ...
                  (isempty(obj.fields{2}.inter) || ...
                   isempty(obj.fields{2}.inter.value)) && ...
                  (isempty(obj.fields{3}) || ...
                   (isempty(obj.fields{3}.value) && ...
                    isempty(obj.fields{3}.general) && ...
                    (isempty(obj.fields{3}.inter) || ...
                     isempty(obj.fields{3}.inter.value))));
        end
    end
end