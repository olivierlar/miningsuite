classdef pattern < hgsetget
	properties (SetAccess = protected)
        parent
        children
		occurrences
		memory
        cycle
    end
    properties
        parameter
        general
        specific
    end
    properties (Dependent)
        freq
    end
	methods
		function obj = pattern(parent,param,paramstruct)
            if nargin < 1
                parent = [];
            end
            if nargin < 2
                param = seq.paramtype;
            end
            obj.parent = parent;
            obj.parameter = param;
            if nargin > 2
                obj.memory = pat.creatememory(paramstruct,obj);
            elseif ~isempty(param)
                obj.memory = pat.creatememory(param,obj);
            end
            if ~isempty(parent)
                obj = obj.connect2general;
                obj = obj.connect2specific;
                parent.children{end+1} = obj;
                for i = 1:length(parent.children)
                    completed = 0;
                    while ~completed
                        for j = i+1:length(parent.children)
                            if ismember(parent.children{j},...
                                        parent.children{i}.specific)
                                child = parent.children{j};
                                parent.children{j} = parent.children{i};
                                parent.children{i} = child;
                                completed = -1;
                                break
                            end
                        end
                        completed = completed+1;
                    end
                end
            end
        end
        function f = get.freq(obj)
            f = length(obj.occurrences);
        end
        function occ = occurrence(obj,varargin)
            occ = pat.occurrence(obj,varargin{:});
            obj.occurrences = [obj.occurrences occ];
        end
        function occ2 = remember(obj,occ,succ,general)
            occ2 = [];
            if isempty(occ.suffix)
            %if ~isempty(occ) && isempty(occ.cycle) && ...
            %       ~isequal(occ.pattern,obj)
                return
            end
            for i = 1:length(obj.children)
                child = obj.children{i};
                
                stop = 0;
                if isa(succ,'pat.syntagm')
                    to = succ.to;
                else
                    to = succ;
                end
                for j = 1:length(to.occurrences)
                    if isequal(to.occurrences(j).pattern,child)
                        stop = 1;
                        break
                    end
                end
                if stop
                    continue
                end
                
                generalized = [];
                endofcycle = 0;
                        
                % Generalizing if necessary.
                [test common] = succ.parameter.implies(child.parameter,...
                                                    occ.suffix.parameter);
                if ~test
                    if ~common.isdefined(obj)
                        continue
                    end
                    if nargin > 3
                        patt = general;
                    else
                        patt = obj;
                    end
                    stop = 0;
                    for j = 1:length(patt.children)
                        if patt.children{j}.parameter.isequal(common)
                            stop = 1;
                            break
                        end
                    end
                    if stop
                        continue
                    end
                        
                    generalized = common;
                    child = child.generalize(common);
                end
                
                if ~isempty(occ)
                    % For cyclic occurrences:
                    if ~isempty(occ.cycle)
                        [test common] = child.parameter.implies(...
                                        occ.cycle(1).parameter);
                                        %occ.cycle(2).parameter) ???
                        if ~test && ~common.isdefined
                            % Cyclicity ending.
                            endofcycle = 1;
                            if ~isequal(occ.pattern,obj)
                                return
                            end
                        end
                    end

                    % Don't go further if extension already exists.
                    found = 0;
                    for j = 1:length(occ.extensions)
                        if occ.extensions(j).parameter.implies(...
                                child.parameter)
                            found = 1;
                            break
                        end
                    end
                    if found
                        continue
                    end
                    
                    found = 0;
                    for j = 1:length(to.occurrences)
                        if ~isempty(to.occurrences(j).cycle) && ...
                                isempty(to.occurrences(j).pattern.parent.parent) && ...
                                isequal(to.occurrences(j).cycle(end),child)
                            found = 1;
                            break
                        end
                    end
                    if found
                        continue
                    end

                    % New cyclicity?
                    if 0 && pat.cyclic && isempty(occ.prefix)
                        found = 0;
                        f = occ.first(obj);
                        suf = f.suffix;
                        if isa(suf,'pat.succession')
                            suf = suf.to;
                        end
                        for j = 1:length(suf.occurrences)
                            if isequal(suf.occurrences(j).pattern,child)
                                found = 1;
                            elseif ~isempty(suf.occurrences(j).cycle) && ...
                                   isequal(suf.occurrences(j).pattern,...
                                           f.pattern) && ...
                                   isequal(suf.occurrences(j).cycle(end),...
                                           child)
                                return
                            end
                        end
                        if found
                            occ2 = child.occurrence(occ,succ,1);
                            if pat.verbose
                                display(occ2);
                            end
                            continue
                        end
                    end
                end
                
                if nargin > 3
                    if      isempty(general.parent.parent) && ...
                            isa(general.parameter.fields{4},'seq.paramtype') && ...
                            ~isempty(child.parameter.fields{4}.value) && ...
                            child.parameter.fields{4}.value
                        continue
                    end
                    for j = 1:length(general.children)
                        if isequal(general.children{j}.parameter,child.parameter)
                            return
                        end
                    end
                    if ~closuretest(occ,succ,child.parameter)
                        continue
                    end
                    child = pat.pattern(general,child.parameter);
                end
                
                occ2 = child.occurrence(occ,succ);
                
                if isa(succ,'pat.event') || isempty(occ2.prefix)
                    continue
                end
                
                % New cyclicity?
                if pat.cyclic && isempty(occ2.prefix.prefix)
                    found = 0;
                    f = occ2.prefix.first(obj);
                    suf = f.suffix;
                    if isa(suf,'pat.succession')
                        suf = suf.to;
                    end
                    for j = 1:length(suf.occurrences)
                        if isequal(suf.occurrences(j).pattern,child)
                            found = 1;
                        elseif ~isempty(suf.occurrences(j).cycle) && ...
                               isequal(suf.occurrences(j).pattern,...
                                       f.pattern) && ...
                               isequal(suf.occurrences(j).cycle(end),...
                                       child)
                            return
                        end
                    end
                    if found
                        occ2 = child.occurrence(occ2.prefix,succ,1);
                        if pat.verbose
                            display(occ2);
                        end
                        continue
                    end
                end
                
                % For cyclic occurrences:
                if ~isempty(occ) && ~isempty(occ.cycle)
                    if endofcycle
                        occ2.cycle = [];
                    elseif length(occ.cycle)==2
                        % New cycle.
                        cycl = child.list;
                        occ2.cycle = cycl(2:end);
                        occ2.round = occ2.round + 1;
                        param = occ2.suffix.to.parameter;
                        occ2.suffix.to.parameter = param.setfield('metre',...
                               seq.paramval(param.getfield('metre'),...
                                            occ2.round));                        
                        first = cycl(2);
                        if ~isempty(generalized)
                            first = first.generalize(generalized);
                        end
                        occ2.pattern = first;
                        %occ2.currentcycle = cycl(end);
                    end
                end
                
                if pat.verbose
                    display(occ2);
                end
            end
            
            %obj.memory.learn(succ.parameter,occ,succ,obj);
            
            %if nargin < 4
            %    for i = 1:length(obj.general)
            %        obj.general(i).memory.learn(succ.parameter,occ,succ,...
            %                                    obj.general(i));
            %    end
            %end
        end
        function obj2 = link(obj1,memo,pref,suff,param)
            %if ~isempty(pref) && ~isequal(pref.pattern,obj1)
            %    obj2 = [];
            %    return
            %end
            
            if nargin < 5
                %if ~strcmp(class(memo{1}{2}),class(suff))
                %    obj2 = [];
                %    return
                %end
                if isa(suff,'pat.syntagm') && isa(memo{1}{2},'pat.event')
                    suff = suff.to;
                end
                
                if isa(suff,'pat.event')
                    for i = 1:length(memo)
                        last1{i} = memo{i}{2};
                    end
                    last2 = suff;
                else
                    for i = 1:length(memo)
                        last1{i} = memo{i}{2}.to;
                    end
                    last2 = suff.to;
                end
                for i = 1:length(last1)
                    if isequal(last1{i},last2)
                        obj2 = [];
                        return
                    end
                end
            
                if 1 %isa(suff,'pat.event')
                    param = suff.parameter;
                else
                    param = suff.unexplainedparameter;
                end
                param = memo{1}{2}.parameter.common(param);
                if ~param.isdefined(obj1)
                    obj2 = [];
                    return
                end
                
                %for i = 1:length(last2.occurrences)
                %    if last2.occurrences(i).parameter.implies(param)
                %        obj2 = [];
                %        return
                %    end
                %end

                i = 2;
                while i<=length(memo)
                    if memo{i}{2}.parameter.implies(param);
                        i = i+1;
                    else
                        memo(i) = [];
                    end
                end

                if isempty(obj1.parameter) || obj1.parameter.isvaldefined
                    if ~(param.isvaldefined || param.isinterdefined)
                        obj2 = [];
                        return
                    end
                end
                %if ~isempty(obj1.parent) && ...
                %        (isempty(param.inter) || isempty(display(param.inter,1))) ...
                 %       && isempty(display(memo{1}{1}.suffix.parameter,1))
                 %   obj2 = [];
                 %   return
                %end
                if 0 && ~isempty(pref.cycle) && ...
                        isempty(pref.pattern.parent.parent) && ...
                        param.implies(pref.cycle(2).parameter)
                    obj1 = pref.cycle(1);
                end
                for i = 1:length(obj1.children)
                    if obj1.children{i}.parameter.implies(param)
                        obj2 = obj1.children{i};
                        return
                    end
                end
                if ~closuretest(pref,suff,param)
                    obj2 = [];
                    return
                end
            end
                        
            obj2 = pat.pattern(obj1,param,obj1.memory);
            
            if nargin < 5
                %if length(memo) == 1
                %   for i = 1:length(memo)
                i = 1;
                        old = obj2.occurrence(memo{i}{1},memo{i}{2},0);
                        for j = 1:length(last1{i}.from)
                            old.memorize(last1{i}.from(j),0);
                        end
                %    end
                %end
            else
                for i = 1:length(memo)
                    old = obj2.occurrence(memo(i).prefix,memo(i).suffix,0);
                    for j = 1:length(memo(i).suffix.to.from)
                        old.memorize(memo(i).suffix.to.from(j),0);
                    end
                end
            end
            
            new = obj2.occurrence(pref,suff,0)
            if pat.verbose
                display(obj2);
                disp(' ');
            end
            
            if pat.cyclic && ~isempty(pref) 
                first = new.first(obj2);
                suf = first.suffix;
                if isa(suf,'pat.succession')
                    suf = suf.to;
                end
                if 1 %nargin < 6
                    last = memo{end}{2}.to;
                else
                    last = memo(end).suffix;
                end
                if isequal(last,suf)
                    pref = memo{end}{2}.to.occurrences(2);
                    pref.round = 1;
                    param = pref.suffix.to.parameter;
                    pref.suffix.to.parameter = param.setfield('metre',...
                               seq.paramval(param.getfield('metre'),1));
                    obj2.occurrence(pref,suff,1)
                    % should we incorporate the first cycle?
                    return
                end
            end
        end
        function obj2 = generalize(obj1,param)
            parent = obj1.parent;
            param = obj1.parameter.common(param);
            found = parent.findchild(param);
            if isempty(found)
                obj2 = pat.pattern(obj1.parent,param,obj1.memory);
            else
                obj2 = found;
            end
        end
        function obj = connect2general(obj,g,params) % obsolete?
            if nargin < 2
                g = obj.parent;
            end
            if nargin < 3
                params = [];
            end
            for i = 1:length(g.children)
                if obj.parameter.implies(g.children{i}.parameter)
                    newgeneral = true;
                    for j = 1:length(params)
                        if params(j).implies(g.children{i}.parameter)
                            newgeneral = false;
                            break
                        end
                    end
                    if newgeneral
                        obj.general = [obj.general g.children{i}];
                        g.children{i}.specific = ...
                            [g.children{i}.specific obj];
                        params = [params g.children{i}.parameter];
                    end
                end
            end
            for i = 1:length(g.general)
                obj = obj.connect2general(g.general(i),params);
            end
        end
        function obj = connect2specific(obj,s,params)
            if nargin < 2
                s = obj.parent;
            end
            if nargin < 3
                params = [];
            end
            for i = 1:length(s.children)
                if isequal(s.children{i},obj) || ...
                        ~s.children{i}.parameter.implies(obj.parameter)
                    continue
                end
                newspecific = true;
                for j = 1:length(params)
                    if ~params(j).implies(s.children{i}.parameter)
                        newspecific = false;
                        break
                    end
                end
                if newspecific
                    obj.specific = [obj.specific s.children{i}];
                    s.children{i}.general = ...
                        [s.children{i}.general obj];
                    params = [params s.children{i}.parameter];
                    %if isempty(obj.memory.fields{1}.content.values)
                    %    obj.memory = s.children{i}.memory;
                    %else
                    %    %error('here');
                    %end
                end
            end
            for i = 1:length(s.specific)
                obj = obj.connect2specific(s.specific(i),params);
            end
        end
        function f = first(obj)
            if isempty(obj.parent)
                f = obj;
            else
                f = obj.parent.first;
            end
        end
        function child = findchild(obj,param)
            for i = 1:length(obj.children)
                if isequal(obj.children{i}.parameter,param)
                    child = obj.children{i};
                    return
                end
            end
            child = [];
        end
        function l = list(obj)
            if isempty(obj.parent)
                l = obj;
            else
                l = [list(obj.parent) obj];
            end
        end
        function txt = display(obj,varargin)
            txt = '';
            if ~isempty(obj.parent) && ~isempty(obj.parent.parent)
                txt = [display(obj.parent,0),'; '];
            end
            if ~isempty(obj.parameter)
                txt = [txt display(obj.parameter,0)];
            end
            if nargin == 1 || varargin{1} == 1
                disp(['Pattern: ',txt,' (',num2str(obj.freq),')']);
            elseif varargin{1} == 2
                disp(txt);
            end
            
        end
        function displaytree(obj)
            c = 0;
            for i = 1:length(obj.children)
                c = c + length(obj.children{i}.occurrences); % Monodimensional case!
            end
            if isempty(obj.children) || ~pat.closed || length(obj.occurrences) > c
                display(obj,2);
            end
            for i = 1:length(obj.children)
                displaytree(obj.children{i});
            end
        end
	end
end


function test = closuretest(pref,suff,param)
    test = 1;
    if isempty(pref)
        for i = 1:length(suff.occurrences)
            if suff.occurrences(i).parameter.implies(param) && ...
                    freq < suff.occurrences(i).pattern.freq 
                test = 0;
                return
            end
        end
    else
        spec = pref.specifics;
        for i = 1:length(spec)
            for j = 1:length(spec(i).extensions)
                if spec(i).extensions(j).parameter.implies(param)
                    test = 0;
                    return
                end
            end
        end
        for j = 1:length(pref.extensions)
            if pref.extensions(j).parameter.implies(param)
                test = 0;
                return
            end
        end
    end
end