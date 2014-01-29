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
        round
        %currentcycle
    end
    properties (Dependent)
        parameter
    end
    methods
		function obj = occurrence(patt,pref,suff,cyclic)
            param = patt.parameter;
            if nargin==4
                if cyclic
                    %o = getfield(param,'onset');
                    %if ~isempty(o.inter.value)
                    %    1
                    %end
                    
                    %if isdefined(patt.parameter.fields{1})
                    %    patt.parameter.fields{2}.value = 1;
                    %end
                    cycl = patt.list;
                    cycl(1) = [];
                    patt = generalize(cycl(1),patt.parameter);
                    obj.round = 2;
               else
                    cycl = [];
                end
            else
                if isempty(pref)
                    cycl = [];
                else
                    obj.round = pref.round;
                    cycl = pref.cycle;
                    if ~isempty(cycl)
                        cycl(1) = [];
                    end
                    if ~isempty(cycl) && ~cycl(1).parameter.implies(param)
                        cycl = [];
                    end
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
            if (nargin < 4 || ~cyclic) && ~isempty(pref)
                test = ~isequal(pref.pattern,patt.parent);
                if ~test && ~isempty(pref.cycle)
                    [unused common] = patt.parameter.implies(...
                                                pref.cycle(2).parameter);
                    test = ~common.isdefined(patt.parent);
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
                            if isempty(presuf.occurrences(i).cycle) && ...
                                    isequal(presuf.occurrences(i).pattern,...
                                            patt.parent)
                                pref = presuf.occurrences(i);
                                found = 1;
                                break
                            end
                        end
                        if ~found
                            pref = pat.occurrence(patt.parent,...
                                                  pref.prefix,...
                                                  pref.suffix,0);
                        end
                    end
                end
            end
            obj.prefix = pref;
            obj.suffix = suff;
            if nargin == 4 && cyclic
                param = obj.suffix.to.parameter;
                obj.suffix.to.parameter = param.setfield('metre',...
                           seq.paramval(param.getfield('metre'),2));
            end
            obj.cycle = cycl;
            %obj.currentcycle = curcycl;
            if ~isempty(to)
                to.occurrence(obj);
            end
            if isempty(suff) %|| isa(suff,'pat.syntagm')
                return
            end
            if isempty(pref)
                for i = 1:length(suff.occurrences)
                    if ~is_equal(suff.occurrences(i),obj)
                        if suff.occurrences(i).pattern.parameter.implies(...
                                param)
                            suff.occurrences(i).general = ...
                                [suff.occurrences(i).general obj];
                            obj.specific = [obj.specific suff.occurrences(i)];
                        elseif isempty(suff.occurrences(i).prefix) ...
                                && param.implies(...
                                        suff.occurrences(i).pattern.parameter)
                            suff.occurrences(i).specific = ...
                                [suff.occurrences(i).specific obj];
                            obj.general = [obj.general suff.occurrences(i)];
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
                                && (~isempty(cycl) || ...
                                    isempty(genr(i).extensions(j).cycle))
                            obj.general = [obj.general ...
                                           genr(i).extensions(j)];
                            genr(i).extensions(j).specific = ...
                                [genr(i).extensions(j).specific obj];
                        end
                    end
                end
            end
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
        function occ = memorize(obj,succ,objpat)
            generalize = nargin < 3 || ~isequal(objpat,0);
            if nargin < 3 || isequal(objpat,0)
                objpat = obj.pattern;
            end
            
            occ = objpat.remember(obj,succ);
            if ~isempty(obj.cycle) && ~isempty(occ)
                return
            end
            
            for i = 1:length(objpat.specific)
                %if ~(   (~isa(obj.pattern.parameter.fields{2},'seq.paramval') || ...
                %         isempty(obj.pattern.parameter.fields{2}.value) || ...
                %         ~obj.pattern.parameter.fields{2}.value) && ...
                %        succ.parameter.fields{2}.value)
                    occ = objpat.specific(i).remember(obj,succ,objpat);
                    if ~isempty(obj.cycle) && ~isempty(occ)
                        return
                    end
                %else
                %    1
                %    %pat = obj.pattern.specific(i).remember(obj,succ,obj.pattern);
                %end
            end
            if generalize
                for i = 1:length(objpat.general)
                    occ = objpat.general(i).remember(obj,succ);
                    if ~isempty(obj.cycle) && ~isempty(occ)
                        return
                    end
                end
            end
            
            if ~isempty(obj.cycle)
                return
            end
            
            %if nargin < 3 && ~isempty(obj.cycle) && ...
            %    ...if
            %            isempty(obj.cycle(1).parent.parent)
            %        pat0 = obj.cycle(end);
            %    %else
            %    %    pat0 = obj.cycle(1);
            %    %end
            %    %obj.memorize(succ,pat0); %%%%%%%
            %end            
            
            objpat.memory.learn(succ.parameter,obj,succ,objpat,...
                                objpat.specific);
            if generalize
                for i = 1:length(objpat.general)
                    objpat.general(i).memory.learn(succ.parameter,...
                                                   obj,succ,...
                                                   objpat.general(i),...
                                                   objpat.general(i).specific);
                end
            end
        end
        function f = first(obj,patt)
            if nargin<2
                patt = obj.pattern;
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