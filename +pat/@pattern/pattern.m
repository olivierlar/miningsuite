% Copyright (C) 2014, 2022, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef pattern < hgsetget
	properties %(SetAccess = protected)
        parent
        children
		occurrences
		memory
        address
    end
    properties
        parameter
        general
        specific
        abstract
        specificmodel
        potentialcycles
        cyclememory
        revelation
        closed = 1
    end
    properties (Dependent)
        freq
        length
        isogeneral
        isospecific
    end
	methods
		function obj = pattern(root,parent,param,paramstruct,abstract)
            obj.parent = parent;
            obj.parameter = param;
            if isempty(root)
                if isempty(parent)
                    obj.address = 0;
                else
                    obj.address = 1;
                    parent.address = 1;
                end
            else
                root.address = root.address + 1;
                obj.address = root.address;
            end
            if nargin > 3 && ~isempty(paramstruct)
                obj.memory = pat.creatememory(paramstruct,obj);
            elseif ~isempty(param)
                obj.memory = pat.creatememory(param,obj);
            end
            if nargin > 4
                obj.abstract = abstract;
            end
            if ~isempty(parent)
                parent.children{end+1} = obj;
                
                l1 = parent.list;
                for i = 1:length(parent.potentialcycles)
                    pci = parent.potentialcycles(i);
                    l2 = pci.pattern.list;
                    %if length(l2) > length(l1)
                    %    idx = length(l1)+1;
                    %else
                    %    idx = 3 + length(l1) - length(l2);
                    %end
                    idx = 3 + pci.phase;
                    if param.implies(l2(idx).parameter)
                        pci.phase = pci.phase + 1;
                        if pci.phase == length(l2) - 2
                            pci.phase = 0;
                        end
                        obj.addpotentialcycle(pci.pattern,pci.phase);
                    end
                end
                
                obj = obj.connect2general(root);
                obj = obj.connect2specific(root);
%                 for i = 1:length(parent.children)
%                     completed = 0;
%                     while ~completed
%                         for j = i+1:length(parent.children)
%                             if ismember(parent.children{j},...
%                                         parent.children{i}.specific)
%                                 child = parent.children{j};
%                                 parent.children{j} = parent.children{i};
%                                 parent.children{i} = child;
%                                 completed = -1;
%                                 break
%                             end
%                         end
%                         completed = completed+1;
%                     end
%                 end
            end
        end
        function f = get.freq(obj)
            f = length(obj.occurrences);
        end
        function l = get.length(obj)
            l = length(obj.list);
        end
        function g = get.isogeneral(obj)
            l = obj.length;
            g = [];
            for i = 1:length(obj.general)
                if obj.general(i).length == l
                    g(end+1) = i;
                end
            end
            if ~isempty(g)
                g = obj.general(g);
            end
        end
        function s = get.isospecific(obj)
            l = obj.length;
            s = [];
            for i = 1:length(obj.specific)
                if obj.specific(i).length == l
                    s(end+1) = i;
                end
            end
            if ~isempty(s)
                s = obj.specific(s);
            end
        end
        function occ = occurrence(obj,varargin)
            occ = pat.occurrence(obj,varargin{:});
            obj.occurrences = [obj.occurrences occ];
            if ~isempty(obj.parent) && ...
                    length(obj.parent.occurrences) == length(obj.occurrences)
                    %&& obj.parent.closed < 2
                obj.parent.closed = 0;
            end
        end

        %% Pattern recognition
        % Can the pattern occurrence 'obj' be extended into an
        % occurrence of a known child of the pattern?
        function occ2 = remember(obj,occ,succ,general,cycle,root,options)
            if isempty(obj.parent)
                addr = 0;
            else
                addr = obj.address;
            end
            if ismember(addr,succ.processed)
                occ2 = []; % is this output ever used?
                return
            end
            if isempty(succ.processed)
                succ.processed = addr;
            else
                succ.processed(end+1) = addr;
            end
            occ2 = [];
%             if isempty(occ.suffix)
%             %if ~isempty(occ) && isempty(occ.cycle) && ...
%             %       ~isequal(occ.pattern,obj)
%                 return
%             end
            
            %if justcontour(obj,occ)
            %    occ2 = [];
            %    return
            %end
            
            %% We look at each child
            for i = 1:length(obj.children)
                child = obj.children{i};
                param = child.parameter;
                
                if nargin > 4 && cycle && ~child.implies(occ.cycle(2))
                    continue
                end
                
                stop = 0;
                if isa(succ,'pat.syntagm')
                    to = succ.to;
                else
                    to = succ;
                end
                
                generalized = false;
                                                        
                % Generalizing if necessary.
                if isempty(occ.suffix)
                    param0 = [];
                else
                    param0 = occ.suffix.parameter;
                end
                [test common] = succ.parameter.implies(param,param0);

                if ~test
                    if ~common.isdefined(obj)
                        continue
                    end
                    %if nargin > 3 && ~isempty(general)
                    %    patt = general;
                    %else
                    %    patt = obj;
                    %end
                    %stop = 0;
                    %for j = 1:length(patt.children)
                    %    if patt.children{j}.parameter.isequal(common)
                    %        stop = 1;
                    %        break
                    %    end
                    %end
                    %if stop
                    %    continue
                    %end
                    
                    %if undefined_pitch_parameter(common)
                    %    continue
                    %end
                    
                    generalized = true;
                    param = common;
                end
                
                if 0 %~isempty(obj.parent) && ~isempty(obj.parent.parent)
                    closing = param.getfield('closure');
                    if isa(closing,'seq.paramval')
                        closing = closing.value;
                        if ~isempty(closing)
                            presuf = occ.suffix;
                            if isa(presuf,'pat.syntagm')
                                presuf = presuf.to;
                            end
                            newclosing = 0;
                            for i = 1:length(presuf.issuffix)
                                if presuf.issuffix(i).closing
                                    newclosing = 1;
                                    break
                                end
                            end
                            if newclosing ~= closing
                                continue
                            end
                        end
                    end
                end
                
                if ~isempty(occ.cycle)
                    [test common] = occ.cycle(2).parameter.implies(param);
                    %[test common] = param.implies(...
                    %                occ.cycle(2).parameter);
                    if ~test
                        if cycle
                            if common.isdefined
                                %% inverted test above??
                                param = common;
                                generalized = true;
                            else
                                continue
                            end
                        else
                            %occ.cycle = []; % We should not destroy the
                            %existing cycle. Maybe create a duplicate
                            %acyclic pattern??
                        end
                    end
                end
                
                if ~isempty(occ)
                    % For cyclic occurrences:
                    if ~isempty(occ.cycle)
                        [test common] = param.implies(...
                                        occ.cycle(2).parameter);
                        if ~test
                            if common.isdefined
                                param = common;
                                generalized = true;
                            else
                                % Cyclicity ending.
                                %% Apparently this condition never holds
                                if ~isequal(occ.pattern,obj)
                                    return
                                end
                            end
                        end
                    end

                    % Don't go further if extension already exists.
                    found = 0;
                    for j = 1:length(occ.extensions)
                        if occ.extensions(j).parameter.implies(...
                                param)
                            found = 1;
                            break
                        end
                    end
                    if found
                        continue
                    end
                    for k = 1:length(occ.specific)
                        % occ.specific: still existing?
                        for j = 1:length(occ.specific(k).extensions)
                            if occ.specific(k).extensions(j).parameter...
                                    .implies(param)
                                found = 1;
                                break
                            end
                        end
                        if found
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
                end
                
                if 0 %generalized
                    %% Turned off because obj.children{j} does not pass the test (~child.implies(occ.cycle(2))
                    if nargin > 3 && ~isempty(general)
                        patt = general;
                    else
                        patt = obj;
                    end
                    stop = 0;
                    for j = 1:length(patt.children)
                        if patt.children{j}.parameter.isequal(param,options)
                            stop = 1;
                            break
                        end
                    end
                    if stop
                        continue
                    end
                end
                
                if nargin > 3  && ~isempty(general) % Generalization
                    %if      isempty(general.parent.parent) && 0 &&...
                    %        isa(general.parameter.fields{4},'seq.paramtype') && ...
                    %        ~isempty(param.fields{4}.value) && ...
                    %        param.fields{4}.value
                    %    continue
                    %end
                    for j = 1:length(general.children)
                        if isequal(general.children{j}.parameter,param,...
                                   options)
                            return
                        end
                    end
                    if ~closuretest(occ,succ,param,general)
                        continue
                    end
                    %found = general.findchild(param);
                    %%% Isn't it same as previous for loop?
                    %if isempty(found)
                        newchild = pat.pattern(root,general,param);
                    %else
                    %    newchild = found;
                    %end
                    newchild.specificmodel = [child.specificmodel child];
                    child = newchild;
                    if 0 %~isempty(general.parent.parent)
                        %% TOGGLED OFF FOR THE MOMENT...
                        for j = 1:length(general.occurrences)
                            occj = general.occurrences(j);
                            for k = 1:length(occj.suffix.to.from)
                                extk = occj.suffix.to.from(k);
                                if extk.parameter.implies(param)
                                    old = child.occurrence(occj,extk);%,0);
                                    for l = 1:length(extk.to.from)
                                        old.memorize(extk.to.from(l));
                                    end
                                end
                            end
                        end
                    end
                    
                    if 0 %toggled off for ISMIR paper!
                        for j = 1:length(general.general)
                            if isempty(general.general(j).parent)
                                continue
                            end
                            found = 0;
                            for k = 1:length(general.general(j).children)
                                if param.isequal(...
                                     general.general(j).children{k}.parameter)
                                    found = 1;
                                    break;
                                end
                            end
                            if found
                                continue
                            end
                            fprintf('Abstract ');
                            pat.pattern(root,general.general(j),param)
                        end
                    end
                elseif nargin > 6 && ~isequal(param,child.parameter,options)
                    [newchild found] = child.generalize(param,root,0,...
                                                        options);
                    if isempty(newchild)
                        continue
                    end
                    newchild.specificmodel = [child.specificmodel child];
                    if isempty(found)
                        newchild.occurrences = child.occurrences; % This might be avoided in order to get specific classes
                    end
                    child = newchild;
                else
                    newchild = [];
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
                
                occ2 = child.occurrence(occ,succ);
                if isempty(newchild) && child.closed == 1
                    %child.closed = 2;
                end
                %child.closed = 1;
                %if length(obj.children) == 1 && ...
                %        length(obj.occurrences) == length(child.occurrences)
                %    obj.closed = 0;
                %end
                
                if isa(succ,'pat.event') || isempty(occ2.prefix)
                    continue
                end
                
                if pat.cyclic
                    found = occ2.newcycle(root,occ2.pattern,...
                                          succ.parameter,options);
                    if ~found
                        for j = 1:length(occ2.pattern.isogeneral)
                            f = occ2.newcycle(root,occ2.pattern...
                                                        .isogeneral(j),...
                                                        succ.parameter,...
                                                        options);
                            if f
                                found = 1;
                            end
                        end
                    end
                    if found
                        return
                    end
                end
                                
                % For cyclic occurrences:
                if ~isempty(occ) && ~isempty(occ2.cycle)
                    if 0 %endofcycle
                        occ2.cycle = [];
                    elseif length(occ.cycle)==2
                        % New cycle.
                        %cycl = child.list;
                        %occ2.cycle = cycl(2:end);
                        occ2.round = occ2.round + 1;
                        %param = occ2.suffix.to.parameter;
                        %occ2.suffix.to.parameter = param.setfield('metre',...
                        %       seq.paramval(param.getfield('metre').type,...
                        %                    occ2.round));                        
                        %first = occ2.cycle(1);
                        %if generalized
                        %    first = first.generalize(param);
                        %    occ2.pattern = first;
                        %end
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

        %% Closure test
        function obj2 = link(obj1,memo,pref,suff,cyclic,root,options)
            if isa(suff,'pat.syntagm') && isa(memo{1}{2},'pat.event')
                suff = suff.to;
            end

            if isa(suff,'pat.event')
                last2 = suff;
            else
                last2 = suff.to;
            end
            last1 = cell(1,length(memo));
            i = 1;
            while i <= length(memo)
                last1{i} = memo{i}{2};
                if ~isa(last1{i},'pat.event')
                    last1{i} = last1{i}.to;
                end
                if isequal(last1{i},last2)
                    obj2 = [];
                    return
                end
                if isequal(memo{i}{1},pref) && pref.length > 0
                    obj2 = [];
                    return
                end
                if ~isempty(memo{i}{1}.cycle)
                    memo(i) = [];
                    if isempty(memo)
                        obj2 = [];
                        return
                    end
                    continue
                end

                %%% Toggled off because it should be into MusMinr
%                 if ~isempty(memo{i}{1}.suffix) && ...
%                         ~isempty(pref.suffix) && ...
%                         memo{i}{1}.suffix.parameter.fields{4}.value > ...
%                             pref.suffix.parameter.fields{4}.value
%                     obj2 = [];
%                     return
%                 end
                i = i+1;
            end

            %i = 1;
            %while i <= length(memo)
            %    if memo{i}{1}.incompatible(obj1)
            %        memo(i) = [];
            %    else
            %        i = i+1;
            %    end
            %end
            %if isempty(memo)
            %    obj2 = [];
            %    return
            %end
            
            % Forbidding overlap                 %%% Toggled off because it should be into MusMinr
            if 0 && ~isempty(pref.first.suffix) && ...
                    memo{1}{2}.parameter.getfield('onset').value > ...
                    pref.first.suffix.parameter.getfield('onset').value && ...
                    (isempty(memo{1}{2}.parameter.getfield('channel')) || ...
                     isequal(memo{1}{2}.parameter...
                                .getfield('channel').value,...
                             pref.first.suffix.parameter...
                                .getfield('channel').value))
                obj2 = [];
                return
            end

            param = suff.parameter;
            if isempty(obj1.parent)
                param = param.nointer;
            end
            for i = 1:length(memo)
                param = memo{i}{2}.parameter.common(param,options);
            end

            if ~param.isdefined(obj1)
               obj2 = [];
                return
            end
            
            for i = 1:length(obj1.children)
                if obj1.children{i}.parameter.isequal(param,options)
                    obj2 = [];
                    return
                end
            end

            if ~isempty(pref.cycle) && ...
                    param.implies(pref.cycle(2).parameter)
                obj2 = [];
                return
            end
            
            %if undefined_pitch_parameter(param)
            %    obj2 = [];
            %    return
            %end

            %if justcontour(obj1,pref)

                        %isempty(param.fields{2}.value) && ...
                        %isempty(param.fields{2}.inter.value)
                        % Two successive contours
                    
            %    obj2 = [];
            %    return
            %end
            
            if isempty(obj1.parameter) || obj1.parameter.isvaldefined
                if ~(param.isvaldefined || param.isinterdefined)
                    obj2 = [];
                    return
                end
            end
            
            if ~isempty(obj1.parameter)
                undef = 0;
                for i = 1:length(obj1.parameter.fields)
                    if isempty(obj1.parameter.fields{i}) || ...
                            isa(obj1.parameter.fields{i},'seq.paramtype') || ...
                            isempty(obj1.parameter.fields{i}.inter) || ...
                            isempty(obj1.parameter.fields{i}.inter.value)
                        continue
                    end
                    if ~isempty(param.fields{i}) && ...
                            ~isa(param.fields{i},'seq.paramtype') && ...
                            ~isempty(param.fields{i}.inter) && ...
                            ~isempty(param.fields{i}.inter.value)
                        undef = 0;
                        break
                    end
                    undef = 1;
                end
                if undef
                    obj2 = [];
                    return
                end
            end

            if ~isempty(pref.cycle) && cyclic
                if length(pref.cycle) == 1 %% Why do we need this?
                    cycle = pref.cycle;
                else
                    cycle = pref.cycle(2);
                end
                if ~param.implies(cycle.parameter)
                    obj2 = [];
                    return
                end
            end

            %for i = 1:length(obj1.children)
            %    if obj1.children{i}.parameter.implies(param) && ...
            %            isequal(obj1.children{i}.parameter.fields{9},group)
            %        obj2 = obj1.children{i};
            %        return
            %    end
            %end

            nboccs = length(memo) + 1;
            if ~closuretest(pref,suff,param,obj1,nboccs)
                obj2 = [];
                return
            end

            i = 1;
            while i <= length(memo)
                if ~memo{i}{2}.parameter.implies(param)
                    memo(i) = [];
                else
                    i = i+1;
                end
            end

            if 0 %~isempty(obj1.parent) %&& ~isempty(obj1.parent.parent)
                presuf = pref.suffix;
                if ~isempty(presuf)
                    if isa(presuf,'pat.syntagm')
                        presuf = presuf.to;
                    end
                    newclosing = 0;
                    for i = 1:length(presuf.issuffix)
                        if presuf.issuffix(i).closing
                            newclosing = 1;
                            break
                        end
                    end

                    presuf = memo{1}{1}.suffix;
                    if isa(presuf,'pat.syntagm')
                        presuf = presuf.to;
                    end
                    oldclosing = 0;
                    if ~isempty(presuf)
                        for i = 1:length(presuf.issuffix)
                            if presuf.issuffix(i).closing
                                sufsuf = presuf.issuffix(i).suffix;
                                while ~isempty(sufsuf.suffix)
                                    sufsuf = sufsuf.suffix;
                                end
                                if sufsuf.address == presuf.address
                                    oldclosing = 1;
                                    break
                                end
                            end
                        end
                    end

                    if newclosing ~= oldclosing
                        obj2 = [];
                        return
                    else
                        param = param.setfield('closure',...
                            seq.paramval(param.getfield('closure'),...
                                         newclosing));
                    end
                end
            end
                                        
            %param = param.setfield('group',group);
            
            %if isempty(obj1.children) && ...
            %        length(obj1.occurrences) == length(memo) + 1
            %    obj1.closed = 0;
            %end
            
            %% Success! New pattern created as an extension of the parent
            obj2 = pat.pattern(root,obj1,param,obj1.memory)
                       
            if 1 %toggled off for ismir paper!
                for i = 1:length(obj1.general)
                    if ~isempty(obj1.general(i).abstract)
                        for j = 1:length(obj1.general(i).abstract)
                            extendgeneral(obj1.general(i),param,root,...
                                          obj1.general(i).abstract{j},...
                                          options);
                        end
                    else
                        extendgeneral(obj1.general(i),param,root,...
                                      obj1.general(i),options);
                    end
                end
            end
                        
            %% Memorising all possible continuations of extended pattern 
            % occurrences
            for i = 1:length(memo)
                old = obj2.occurrence(memo{i}{1},memo{i}{2},1);
                for j = 1:length(last1{i}.from)
                    oldsucc = last1{i}.from(j);
                    obj2.memory.learn(oldsucc.parameter,old,oldsucc,obj2,...
                                      obj2.specificmodel,0,root,options,0);
                end
            end
            
            %if isa(memo{1}{2},'pat.syntagm')
            %    oldocc = memo{1}{2}.to.occurrences;
            %    for i = 1:length(oldocc)
            %        if ~isequal(oldocc(i).pattern,obj2) && ...
            %                ~isempty(oldocc(i).pattern.parent.parent) && ...
            %                oldocc(i).parameter.implies(param)
            %            oldocc(i)
            %        end
            %    end
            %end
            
            new = obj2.occurrence(pref,suff,1);
            obj2.revelation = new;
            if pat.verbose
                display(obj2);
                disp(' ');
            end
            
            if pat.cyclic && ~isempty(pref)
                if ~new.newcycle(root,new.pattern,suff.parameter,options)
                    for g = 1:length(new.pattern.isogeneral)
                        new.newcycle(root,new.pattern.isogeneral(g),...
                                     suff.parameter,options);
                    end
                end
            elseif 0 % old version
                first = new.first(obj2);
                suf = first.suffix;
                if isa(suf,'pat.syntagm')
                    suf = suf.to;
                end
                if 1 %nargin < 6
                    last = memo{end}{2}.to;
                else
                    last = memo(end).suffix;
                end
                if isequal(last,suf)
                    %pref = memo{end}{2}.to.occurrences(2);
                    pref.round = 1;
                    param = pref.suffix.to.parameter;
                    %pref.suffix.to.parameter = param.setfield('metre',...
                    %       seq.paramval(param.getfield('metre').type,1));
                    
                    %obj2.occurrence(pref,suff,1)
                    cyclize(obj2,new);
                    return
                end
            end
        end
        function [obj2 found] = generalize(obj1,param,root,recurs,options)
            if nargin < 4
                recurs = 0;
            end
            parent = obj1.parent;
            param = obj1.parameter.common(param,options);
            if ~param.isdefined
                if isequal(obj1.parameter,param,options) %elementary note pattern
                    obj2 = obj1;
                    found = 1;
                    return
                end
                found = [];
                obj2 = root.children{end};  %elementary note pattern?
                return
            end
            if isa(param.fields{2},'seq.paramtype')
                found = 1;
                obj2 = obj1;
                return
            end
            %if undefined_pitch_parameter(param)
            %    found = [];
            %    obj2 = [];
            %    return
            %end
            found = parent.findchild(param,options);
            if isempty(found)
                obj2 = pat.pattern(root,parent,param,obj1.memory);
                for i = 1:length(obj1.general)
                    if ~isempty(obj1.general(i).parent)
                        obj1.general(i).generalize(param,root,1,options);
                    end
                end
            else
                obj2 = found;
            end
        end
        function obj = connect2general(obj,root,g,params)
            if nargin < 3
                g = obj.parent;
            end
            if nargin < 4
                params = [];
            end
            for i = 1:length(g.children)
                if isequal(g.children{i},obj)
                    continue
                end
                if obj.parameter.implies(g.children{i}.parameter)
                    %newgeneral = true;
                    %for j = 1:length(params)
                    %    if params(j).implies(g.children{i}.parameter)
                    %        newgeneral = false;
                    %        break
                    %    end
                    %end
                    %if newgeneral
                        obj.general = [obj.general g.children{i}];
                        g.children{i}.specific = ...
                            [g.children{i}.specific obj];
                        %params = [params g.children{i}.parameter];
                    %end
                end
            end
            if nargin < 4
                for i = 1:length(g.general)
                    obj = obj.connect2general(root,g.general(i),params);
                    if isempty(g.general(i).parent)
                        obj.general = [obj.general g.general(i)];
                        g.general(i).specific = ...
                            [g.general(i).specific obj];
                    %elseif isempty(g.general(i).parent.parent) && ...
                    %        obj.parameter.implies(g.general(i).parameter)
                    %    obj.general = [obj.general g.general(i)];
                    end
                end
            end
            if nargin < 3 && ~isempty(root)
                obj.general = [obj.general root];
            end
        end
        function obj = connect2specific(obj,root,s,params)
            if nargin < 3
                s = obj.parent;
            end
            if nargin < 4
                params = [];
            end
            for i = 1:length(s.children)
                if isequal(s.children{i},obj) || ...
                        ~s.children{i}.parameter.implies(obj.parameter) || ...
                        ismember(s.children{i},obj.specific)
                    continue
                end
                %newspecific = true;
                %for j = 1:length(params)
                %    if ~params(j).implies(s.children{i}.parameter)
                %        newspecific = false;
                %        break
                %    end
                %end
                %if newspecific
                obj.specific = [obj.specific s.children{i}];
                s.children{i}.general = ...
                    [s.children{i}.general obj];
                if 0 %length(s.children{i}.list) > length(obj.list)
                    for j = 1:length(s.children{i}.general)
                        if length(s.children{i}.general(j).list) > ...
                                length(obj.list)
                            com = obj.parameter.common(...
                                s.children{i}.general(j).parameter);
                            if com.isdefined
                                found = 0;
                                for k = 1:length(obj.parent.children)
                                    if isequal(com,...
                                               obj.parent...
                                               .children{k}.parameter)
                                        found = 1;
                                        break
                                    end
                                end
                                if ~found
                                     pat.pattern(root,obj.parent,com,...
                                                 obj.parent.memory);
                                     %g.occurrence(pref,suff,0);
                                end
                            end
                        end
                    end
                end
                    %params = [params s.children{i}.parameter];
                    %if isempty(obj.memory.fields{1}.content.values)
                    %    obj.memory = s.children{i}.memory;
                    %else
                    %    %error('here');
                    %end
                %end
            end
            if nargin < 4
                for i = 1:length(s.specific)
                    obj = obj.connect2specific(root,s.specific(i),params);
                end
            end
        end
        function f = first(obj)
            if isempty(obj.parent)
                f = obj;
            else
                f = obj.parent.first;
            end
        end
        function child = findchild(obj,param,options)
            for i = 1:length(obj.children)
                if isequal(obj.children{i}.parameter,param,options)
                    child = obj.children{i};
                    return
                end
            end
            child = [];
        end
        function t = implies(obj1,obj2,occ1,occ2)
            if isempty(obj2) || isempty(obj2.parameter)
                t = true;
                return
            end
            if isempty(obj1) || isempty(obj1.parameter)
                % does this ever happen?
                t = false;
                return
            end
            par1 = obj1.parameter;
            if nargin > 2
                pre1 = occ1.prefix;
                pre2 = occ2.prefix;
                if isempty(pre1) && ~isempty(pre2)
                    t = false;
                    return
                end
                if isempty(pre2) || isempty(pre2.suffix)
                    t = true;
                    return
                end
                if ~isempty(pre1) && strcmp(pre1.suffix.parameter.name,'music')
                    while pre1.suffix.parameter.fields{4}.value > ...
                            pre2.suffix.parameter.fields{4}.value
                        par1 = par1.add(pre1.parameter);
                        pre1 = pre1.prefix;
                        if isempty(pre1)
                            t = false;
                            return
                        end
                    end
                    if pre1.suffix.parameter.fields{4}.value < ...
                            pre2.suffix.parameter.fields{4}.value
                        t = false;
                        return
                    end
                end
            end
            if ~par1.implies(obj2.parameter)
                t = false;
                return
            end
            t = obj1.parent.implies(obj2.parent);
        end
        function addpotentialcycle(obj,cycle,phase)
            if isempty(obj.potentialcycles)
                obj.potentialcycles.pattern = cycle;
                obj.potentialcycles.phase = phase;
            else
                obj.potentialcycles(end+1).pattern = cycle;
                obj.potentialcycles(end).phase = phase;
            end
        end
        %function addcycle(obj,cycle,phase)
        %    if length(obj.cycles) < phase+1
        %        obj.cycles{phase+1} = cycle;
        %    else
        %        obj.cycles{phase+1}(end+1) = cycle;
        %    end
        %end
        function l = list(obj)
            if isempty(obj.parent)
                l = obj;
            else
                l = [list(obj.parent) obj];
            end
        end
        function txt = display(obj)
            if length(obj) > 1
                for i = 1:length(obj)
                    i
                    obj(i).display;
                end
                return
            end
            txt = '';
            if ~isempty(obj.parent) && ~isempty(obj.parent.parent)
                txt = [simpledisplay(obj.parent),'; '];
            end
            if ~isempty(obj.parameter)
                txt = [txt simpledisplay(obj.parameter)];
            end
            disp(['Pattern: ',txt,' (',num2str(obj.freq),')']);
        end
        function txt = simpledisplay(obj)
            if length(obj) > 1
                for i = 1:length(obj)
                    i
                    obj(i).display;
                end
                return
            end
            txt = '';
            if ~isempty(obj.parent) && ~isempty(obj.parent.parent)
%                 txt = [display(obj.parent),'; '];
                  txt = [simpledisplay(obj.parent),'; '];
            end
            if ~isempty(obj.parameter)
                txt = [txt simpledisplay(obj.parameter)];
            end
            %disp(txt);
        end
        function tree(obj,indent)
            if nargin < 2
                indent = 0;
            end
            txt = obj.display(0);
            disp([blanks(indent) txt]);
            for i = 1:length(obj.children)
                tree(obj.children{i},indent+1);
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


function cyclize(patt,occ)
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
    occ.cycle = cycl;
    occ.phase = 0;
    occ.pattern = cycl(1);
        % Previously: occ.pattern = generalize(cycl(1),patt.parameter);
        % But only the note (not the interval) should be generalized.
    occ.round = 2;
    % should we incorporate the first cycle?
end


function test = closuretest(pref,suff,param,parent,nboccs)
    test = 1;
        
    note = suff;
    if isa(note,'pat.syntagm')
        note = note.to;
    end
    if 0 %isequal(pref.pattern,parent)
        for i = 1:length(note.occurrences)
            if note.occurrences(i).implies(param,suff)
                if ...~isempty(note.occurrences(i).cycle) || ...
                        (~isempty(note.occurrences(i).prefix) && ...
                         (isequal(pref.pattern,...
                                  note.occurrences(i).prefix.pattern) || ...
                          ismember(pref.pattern,...
                                  note.occurrences(i).prefix.pattern.general)))
                    %% Second test never used, because general occurrence alway empty, no?
                    test = 0;
                    return
                end
            end
        end
    elseif pref.pattern.implies(parent)
        for i = 1:length(note.occurrences)
            prefi = note.occurrences(i).implies(param,suff);
            if ~isempty(prefi) && ...
                    prefi.pattern.implies(parent,prefi,pref) && ...
                    (nargin < 5 || ... %%%% What to do in this case?????
                    length(note.occurrences(i).pattern.occurrences) ...
                    >= nboccs)
                    % It is necessary to compare number of occurrences,
                    % because of phenomenon of the type ABCDabcdCD
                test = 0;
                return
            end
        end
    end
end


function extendgeneral(parent,param,root,abstract,options)
    for j = 1:length(parent.children)
        if parent.children{j}.parameter.isequal(param,options)
            return
        end
    end
    if nargin < 4
        refparent = parent;
    else
        refparent = abstract;
    end
    found = {};
    for j = 1:length(refparent.children)
        if refparent.children{j}.parameter.implies(param)
            found{end+1} = refparent.children{j};
        end
    end
    if ~isempty(found)
        fprintf('Abstract ');
        pat.pattern(root,parent,param,[],found)
    end
end


function res = justcontour(obj1,pref)
% Checks whether prefix pattern ends with just gross contour
    res = ~isempty(obj1.parameter) && ...
          isa(obj1.parameter.fields{2},'seq.paramval') && ...
          isempty(obj1.parameter.fields{2}.value) && ...
          ~isempty(obj1.parameter.fields{2}.inter) && ...
          isempty(obj1.parameter.fields{2}.inter.value) && ...
          isempty(obj1.parameter.fields{1}) && ...
          ~obj1.parameter.fields{3}.isdefined;
            %&& ...
          %~isempty(pref.suffix.parameter.fields{4}.inter) && ...
          %pref.suffix.parameter.fields{4}.inter.value < .5;
end