% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef occurrence < hgsetget
	properties %(SetAccess = private)
		id
        pattern
		prefix
		suffix
    end
    properties
        specific
        general
		extensions
        cycle
        phase
        round
        length
    end
    properties (Dependent)
        parameter
    end
    methods
		function obj = occurrence(patt,pref,suff,nocyclic)
            param = patt.parameter;
            if isempty(pref)
                cycl = [];
            else
                if nargin>3 && nocyclic
                    pref.cycle = [];
                end
                
                obj.round = pref.round;
                cycl = pref.cycle;
                %pcycl = pref.pattern.potentialcycle;
                if ~isempty(cycl)
                    cycl(1) = [];
                end
                if ~isempty(cycl) 
                    [test common] = param.implies(cycl(1).parameter);
                    if ~common.isdefined
                        warning('Attention')
                        cycl = [];
                    end
                    obj.phase = pref.phase + 1;
                    if length(cycl) == 1
                        cycl = patt.list;
                        cycl(1) = [];
                        %patt = generalize(cycl(1),patt.parameter);
                        obj.phase = 0;
                    end
                    %cycl(end).addcycle(obj,obj.phase);
                end
            end
            to = suff;
            if isa(suff,'pat.syntagm')
                to = to.to;
            end
            %for i = 1:length(to.occurrences)
            %    if ~isempty(to.occurrences(i).cycle)
            %       if isequal(to.occurrences(i).cycle(end),cycl)
            %           obj = to.occurrences(i);
            %           return
            %       end
            %    end
            %end
            obj.id = identify;
            obj.pattern = patt;
            if isempty(cycl) && ~isempty(pref)
                % Reconstructing the prefix if necessary
                test = ~isequal(pref.pattern,patt.parent);
                if ~test && ~isempty(pref.cycle) ...
                        && length(pref.cycle) > 1 %???
                    [test, common] = patt.parameter.implies(...
                                                pref.cycle(2).parameter);
                    test = ~test || ~common.isdefined(patt.parent);
                end
                if test
                    if isempty(patt.parent.parent)
                        pref = [];
                        if isa(suff,'pat.syntagm')
                            suff = suff.to;
                        end
                    else
                        found = 0;
                        presuf = pref.suffix;
                        if isa(presuf,'pat.syntagm')
                            presuf = presuf.to;
                        end
                        for i = 1:length(presuf.occurrences)
                            if isempty(presuf.occurrences(i).cycle) || ...
                                    presuf.occurrences(i).phase
                                pi = presuf.occurrences(i).pattern;
                            else
                                pi = presuf.occurrences(i).cycle(end);
                                %if ~isequal(pi,patt.parent) && ...
                                %        ismember(patt.parent,pi.general)
                                %    error('Should have been already tested in occ.memorize');
                                %    obj = [];
                                %    return
                                %end
                            end
                            if isequal(pi,patt.parent)
                                pref = presuf.occurrences(i);
                                found = 1;
                                break
                            end
                        end
                        if ~found
                            pref = pat.occurrence(patt.parent,...
                                                  pref.prefix,...
                                                  pref.suffix);%,0);
                        end
                    end
                end
            end
            obj.prefix = pref;
            obj.suffix = suff;
            %if nargin == 4 && cyclic
            %    param = obj.suffix.to.parameter;
            %    %obj.suffix.to.parameter = param.setfield('metre',...
            %    %           seq.paramval(param.getfield('metre').type,2));
            %end
            obj.cycle = cycl;
            %if ~isempty(cycl)
            %    cycl(end).addcycle(obj);
            %end
            if isempty(pref)
                obj.length = 0;
            else
                obj.length = pref.length + 1;
            end
            %obj.currentcycle = curcycl;
            if isempty(suff) %|| isa(suff,'pat.syntagm')
                return
            end
            if isempty(pref) || isempty(pref.prefix)
                suffto = suff;
                if isa(suffto,'pat.syntagm')
                    suffto = suff.to;
                end
                for i = 1:length(suffto.occurrences)
                    if ~is_equal(suffto.occurrences(i),obj)
                        if suffto.occurrences(i).pattern.parameter.implies(...
                                param)
                            suffto.occurrences(i).general = ...
                                [suffto.occurrences(i).general obj];
                            obj.specific = [obj.specific ...
                                            suffto.occurrences(i)];
                        elseif isempty(suffto.occurrences(i).prefix) ...
                                && param.implies(...
                                   suffto.occurrences(i).pattern.parameter)
                            suffto.occurrences(i).specific = ...
                                [suffto.occurrences(i).specific obj];
                            obj.general = [obj.general ...
                                           suffto.occurrences(i)];
                        end
                    end
                end
            else
                pref.extensions = [pref.extensions obj];
                spec = [pref pref.specific];
                for i = 1:length(spec)
                    for j = 1:length(spec(i).extensions)
                        if ~isequal(spec(i).extensions(j), obj) && ...
                                spec(i).extensions(j).pattern.parameter...
                                .implies(param) && ...
                                (~isempty(spec(i).extensions(j).cycle) ...
                                 || isempty(cycl))
                            obj.specific = [obj.specific ...
                                            spec(i).extensions(j)];
                            spec(i).extensions(j).general = ...
                                [spec(i).extensions(j).general obj];
                        end
                    end
                end
                genr = [pref pref.general];
                for i = 1:length(genr)
                    for j = 1:length(genr(i).extensions)
                        if ~isequal(genr(i).extensions(j), obj) && ...
                                param.implies(...
                                genr(i).extensions(j).pattern.parameter) ...
                                && isempty(cycl) && ...(~isempty(cycl) || ...
                                    isempty(genr(i).extensions(j).cycle)%)
                            obj.general = [obj.general ...
                                           genr(i).extensions(j)];
                            genr(i).extensions(j).specific = ...
                                [genr(i).extensions(j).specific obj];
                        end
                    end
                end
                if ~isempty(to.occurrences)
                    genocc = to.occurrences(1);
                    if isempty(genocc.pattern.parent.parent) %&& ~isequal(genocc,obj) %~ismember(obj,genocc.specific)
                        genocc.specific = [genocc.specific obj];
                        obj.general = [obj.general genocc];
                    end
                end
            end
            if ~isempty(to)
                to.occurrence(obj);
            end
        end
        function found = newcycle(obj,root,patt)
            found = 0;
            if nargin < 3
                patt = obj.pattern;
            end
            if isempty(patt.parent) || isempty(patt.parent.parent) ...
                    || ~isempty(obj.cycle)
                return
            end
            for j = 1:length(obj.suffix.to.occurrences)
                if ~isempty(obj.suffix.to.occurrences(j).cycle) && ...
                    (isequal(obj.suffix.to.occurrences(j).cycle(end),...
                             patt) || ...
                     ismember(patt,...
                              obj.suffix.to.occurrences(j).cycle(end).general))
                    return
                end
            end
            f = obj.prefix.first(patt.parent);
            suf = f.suffix;
            if isa(suf,'pat.syntagm')
                suf = suf.to;
            end
            for j = 1:length(suf.occurrences)
                if isequal(suf.occurrences(j).pattern,patt)
                    found = 1;
                else
                    for i = 1:length(suf.occurrences(j).pattern.general)
                        if isequal(suf.occurrences(j).pattern.general(i),...
                                   patt)
                            found = 1;
                        end
                    end
                end
                if found
                    break
                end
            end
            if found
                cycl = patt.list;
                cycl(1) = [];
                patt.addpotentialcycle(patt,0);
                for i = 2:length(cycl)-1
                    cycl(i).addpotentialcycle(patt,i-1);
                end
                patt.cyclememory = pat.creatememory(patt.parameter,patt);
                for i = 2:length(cycl)-1
                    patt.cyclememory(i) = ...
                        pat.creatememory(patt.parameter,patt);
                end
                if nargin > 2
                    obj = obj.generalize(patt);
                end
                obj.cycle = cycl;
                obj.phase = 0;
                %obj.pattern = cycl(1);
                    % Previously: occ.pattern = generalize(cycl(1),patt.parameter);
                    % But only the note (not the interval) should be generalized.
                obj.round = 2;
                % should we incorporate the first cycle?
                if pat.verbose
                    display(obj);
                end
            end
        end
        function g = generalize(obj,patt)
            g = patt.occurrence(obj.prefix,obj.suffix);
            g.specific = obj.specific;
            %g.general
            g.extensions = obj.extensions;
            g.length = obj.length;
        end
        
        
        function s = specifics(obj)
            s = [];
            for i = 1:length(obj.specific)
                if ~ismember(obj.specific(i),s)
                    s = [s obj.specific(i)];
                    si = obj.specific(i).specifics;
                    for j = 1:length(si)
                        if ~ismember(si(j),s)
                            s = [s si(j)];
                        end
                    end
                end
            end
        end
        function g = generals(obj)
            g = [];
            for i = 1:length(obj.general)
                if ~ismember(obj.general(i),g)
                    g = [g obj.general(i)];
                    gi = obj.general(i).generals;
                    for j = 1:length(gi)
                        if ~ismember(gi(j),g)
                            g = [g gi(j)];
                        end
                    end
                end
            end
        end
        function occ2 = track_cycle(occ,succ,root)
            child = occ.cycle(2);
            param = child.parameter;
            [test common] = succ.parameter.implies(param,...
                                                   occ.suffix.parameter);
            if ~test
                if ~common.isdefined(occ.pattern)
                    occ2 = [];
                    return
                end
                if undefined_pitch_parameter(common)
                    occ2 = [];
                    return
                end

                param = common;
                [newchild found] = child.generalize(param,root);
                if isempty(newchild)
                    occ2 = [];
                    return
                end
                newchild.specificmodel = [child.specificmodel child];
                if isempty(found)
                    newchild.occurrences = child.occurrences; % This might be avoided in order to get specific classes
                end
                child = newchild;
            else
                newchild = [];
            end
            occ2 = child.occurrence(occ,succ);
            if isempty(newchild) && child.closed == 1
                child.closed = 2;
            end
            if length(occ.cycle) == 2
                occ2.round = occ2.round + 1;
            end
            if pat.verbose
                display(occ2);
            end
        end
        function occ = memorize(obj,succ,root,occs,cyclic)
            if nargin < 4
                occs = [];
            end
            if nargin < 5
                cyclic = 0;
            end
            objpat = obj.pattern;
            
            if isa(succ,'pat.syntagm')
                for i = 1:length(succ.to.occurrences)
                    if ~isempty(succ.to.occurrences(i).prefix) && ...
                            ismember(objpat,...
                                succ.to.occurrences(i).prefix.pattern.general)...
                            && succ.parameter.implies(...
                                 succ.to.occurrences(i).pattern.parameter)
                        % We should only accept parameter more specific than succ.to.occurrences(i).pattern.parameter 
                        %occ = [];
                        %return
                    end
                end
            end
            
            occ = objpat.remember(obj,succ,[],cyclic,root);
            for i = 1:length(objpat.specific)
                %if ~(   (~isa(obj.pattern.parameter.fields{2},'seq.paramval') || ...
                %         isempty(obj.pattern.parameter.fields{2}.value) || ...
                %         ~obj.pattern.parameter.fields{2}.value) && ...
                %        succ.parameter.fields{2}.value)
                    occ = objpat.specific(i).remember(obj,succ,...
                                                      objpat,cyclic,root);
                %else
                %    1
                %    %pat = obj.pattern.specific(i).remember(obj,succ,obj.pattern);
                %end
            end
                
            for i = 1:length(objpat.general)
                if ismember(objpat.general(i),occs) || ...
                        obj.incompatible(objpat.general(i))
                    continue
                end
                if isempty(obj.cycle) && ...
                        ~isempty(objpat.general(i).parent)
                    presuf = obj.suffix;
                    if isa(presuf,'pat.syntagm')
                        presuf = presuf.to;
                    end
                    stop = 0;
                    for j = 1:length(presuf.occurrences)
                        if isempty(presuf.occurrences(j).cycle)
                            continue
                        end
                        if presuf.occurrences(j).phase
                            pi = presuf.occurrences(j).pattern;
                        else
                            pi = presuf.occurrences(j).cycle(end);
                        end
                        if ~isequal(pi,objpat.general(i)) && ...
                                ismember(objpat.general(i),pi.general)
                            stop = 1;
                            break
                        end
                    end
                    if stop
                        continue
                    end
                end
                occ = objpat.general(i).remember(obj,succ,[],cyclic,root);
                if ~isempty(obj.cycle) && ~isempty(occ)
                    %return
                end
            end
            
            
            if ~isempty(obj.cycle) && ~obj.phase
                %% Other patterns could be considered for other phases too...
                objpat = obj.cycle(end);
            end
            
            if cyclic
                return
            end
            
            objpat.memory.learn(succ.parameter,obj,succ,objpat,...
                                objpat.specificmodel,cyclic,root);
        
            for i = 1:length(objpat.general)
                if ismember(objpat.general(i),occs) || ...
                        obj.incompatible(objpat.general(i))
                    continue
                end
                objpat.general(i).memory.learn(succ.parameter,...
                                               obj,succ,...
                                               objpat.general(i),...
                                               objpat.general(i).specificmodel,...
                                               cyclic,root);
            end
            %if isempty(obj.cycle)
            %    for i = 1:length(obj.pattern.potentialcycles)
            %        pci = obj.pattern.potentialcycles(i);
            %        %pci.pattern.cyclememory(pci.phase+1).learn(...
            %        %    succ.parameter,obj,succ,...
            %        %    objpat,objpat.specific,cyclic);
            %    end
            %end
        end
        function l = list(obj,patt)
            if nargin<2
                if ~isempty(obj.cycle)
                    patt = obj.cycle(end);
                else
                    patt = obj.pattern;
                end
            end
            if isempty(obj.prefix) || isempty(patt(1).parent.parent)
                l = obj;
            else
                l = [obj.prefix.list obj];
            end
        end
        function f = first(obj,patt)
            if nargin<2
                if ~isempty(obj.cycle)
                    patt = obj.cycle(end);
                else
                    patt = obj.pattern;
                end
            end
            if isempty(obj.prefix) || isempty(patt(1).parent.parent)
                f = obj;
            else
                f = obj.prefix.first(patt(1).parent);
            end
        end
        function f = get.parameter(obj)
            if ~isempty(obj.cycle) && isempty(obj.pattern.parent.parent)
                f = obj.cycle(end).parameter;
            else
                f = obj.pattern.parameter;
            end
        end
        function i = is_equal(obj1,obj2)
            if ~isa(obj2,'pat.occurrence')
                i = 0;
            else
                i = isequal(obj1.id,obj2.id);
            end
        end
        function txt = display(obj,varargin)
            if length(obj) > 1
                for i = 1:length(obj)
                    i
                    obj(i).display(varargin{:});
                end
                return
            end
            if isempty(obj.prefix)
                txt = '';
            else
                txt = [display(obj.prefix,1) '; '];
            end
            if ~isempty(obj.parameter)
                txt = [txt display(obj.parameter,1)];%.fields{2},1)];
            end
            if nargin < 2 && ~isempty(txt) && pat.verbose
                if isempty(obj.cycle)
                    disp(['Occurrence: ',txt]);
                else
                    disp(['Occurrence: ',txt,' towards:']);
                    display(obj.cycle(end));
                end
                display(obj.pattern);
                disp(' ');
            end
            suffix = obj.suffix;
        end
        function stop = incompatible(occ,patt)
            stop = 0;
            if isempty(occ.cycle) && ~isempty(patt.parent)
                presuf = occ.suffix;
                if isa(presuf,'pat.syntagm')
                    presuf = presuf.to;
                end
                stop = 0;
                for j = 1:length(presuf.occurrences)
                    if isempty(presuf.occurrences(j).cycle)
                        continue
                    end
                    if presuf.occurrences(j).phase
                        pi = presuf.occurrences(j).pattern;
                    else
                        pi = presuf.occurrences(j).cycle(end);
                    end
                    if ~isequal(pi,patt) && ismember(patt,pi.general)
                        stop = 1;
                        return
                    end
                end
            end
        end
        function pre1 = implies(obj,par2,suff)
            if isa(suff,'pat.event') || isempty(obj.pattern.parent.parent)
                pre1 = [];
                return
            end
            par1 = obj.parameter;
            pre1 = obj.prefix;
            if ~isempty(pre1) %?
                while pre1.suffix.parameter.fields{4}.value > ...
                        suff.from.parameter.fields{4}.value
                    par1 = par1.add(pre1.parameter);
                    pre1 = pre1.prefix;
                    if isempty(pre1)
                        pre1 = [];
                        return
                    end
                end
                if pre1.suffix.parameter.fields{4}.value < ...
                        suff.from.parameter.fields{4}.value
                    pre1 = [];
                    return
                end
            end
            if ~par1.implies(par2)
                pre1 = [];
            end
        end
	end
end


function i = identify
    persistent pat_occurrences_id
    if isempty(pat_occurrences_id)
        pat_occurrences_id = 0;
    end
    pat_occurrences_id = pat_occurrences_id+1;
    i = pat_occurrences_id;
end