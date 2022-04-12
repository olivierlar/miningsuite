% Copyright (C) 2014, 2022 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef memoparam < pat.memory
    properties (SetAccess = private)
        pattern
    end
    properties
        values
        content %= struct('values',[]);
        general
        inter
    end
	methods
        function obj = memoparam(param,pattern)
            obj = obj@pat.memory(param);
            if ...not(isa(param,'seq.paramval')) && ...
                    not(isempty(param.general))
                obj.general = memory(param.general(1),pattern);
                for i = 2:length(param.general)
                    obj.general(i) = memory(param.general(i),pattern);
                end
            end
            if ...~isa(param,'seq.paramval') && ~isa(param,'seq.paramdesc') && ...
                    ~(isempty(param.inter))
                obj.inter = memory(param.inter(1),pattern);
                for i = 2:length(param.inter)
                    obj.inter(i) = memory(param.inter(i),pattern);
                end
            end
        end

        %% Checking if the parameter param already exists as a continuation
        % of the pattern
        function [idx, memo, value] = find(obj,param,specif)
            % Output:
            %   memo: the content in the retrieved memory
            %   idx: the index of the retrieved parameter in the memory 
            %   value: the parameter value. In case of approximate
            %       matching, value output the similar value already stored.
            idx = [];
            if isa(param,'seq.paramtype')
                memo = [];
                value = [];
                return
            elseif isa(param,'seq.paramval')
                value = param.value;
            else
                value = param;
            end
            if isstruct(value)
                if isfield(value,'letter')
                    value = value.letter;
                elseif isfield(value,'number')
                    value = value.number;
                elseif isfield(value,'inbar')
                    value = value.inbar;
                end
            end
            if isempty(value)
                memo = [];
                return
            end
                        
            [dist, idx] = min(abs(value - obj.values));
            if ~isempty(dist) && dist < .02
                value = obj.values(idx);
                memo = obj.content{idx};
            else
                memo = [];
                idx = [];
                for i = 1:length(specif)
                    if isempty(specif{i})
                        continue
                    end
                    [dist, idx1] = min(abs(value - specif{i}.values));
                    if ~isempty(dist) && dist < .02
                        value = specif{i}.values(idx1);
                        memo = specif{i}.content{idx1};
                        break
                    end
                end
            end
        end

        %% Core part of the pattern discovery mechanism
        % Now we are considering the continuation of a given pattern
        % occurrence and check whether one particular parametrical
        % description of the extension has been already memorised before or
        % not
        function [obj, paramemo] = learn(obj,param,occ,succ,parent,...
                                         specif,cyclic,root,options,detect)
            paramemo = param;
            if isa(param,'seq.paramtype')
                return
            end
            
            %% 
            [idx, memo, value] = obj.find(param,specif);
            if ~isempty(value)
                if ~isempty(memo)
                    if iscell(memo)
                        if (isa(memo{1}{2},'pat.syntagm') && ...
                                ~isequal(succ.to,memo{1}{2}.to) && ...
                                ~isequal(memo{1}{1},occ)) || ...
                                (isa(memo{1}{2},'pat.event') && ...
                                ~isequal(succ,memo{1}{2}))
                            if detect
                                %% If we find a new parametric repetition,
                                % we can check pattern closure
                                parent.link(memo,occ,succ,cyclic,root,...
                                            options);
                                % by calling pat.pattern.link
                            end
                            if 1 %isempty(newpat) %% Should we turn back to previous version?
                                if isempty(idx)
                                    if 0 %length(obj.values) < group
                                        obj.values = value;
                                        obj.content = {{{occ,succ}}};
                                    else
                                        obj.values(end+1) = value;
                                        obj.content{end+1} = {{occ,succ}};
                                    end
                                elseif iscell(obj.content{idx}) && ...
                                        ~isequal(succ,...
                                                 obj.content{idx}{end}{2})
                                    obj.content{idx}{end+1} = {occ,succ};
                                end
                            else
                                if isempty(idx)
                                    if 0 %length(obj.values) < group
                                        obj.values{group} = value;
                                        obj.content{group} = {newpat};
                                    else
                                        obj.values(end+1) = value;
                                        obj.content{end+1} = newpat;
                                    end
                                else
                                    obj.content{idx} = newpat;
                                    memo = newpat;
                                end
                            end
                        end
                    elseif isa(memo,'seq.paramstruct') ...
                             && ~succ.parameter.implies(memo)
                        found = 0;
                        for i = 1:length(parent.children)
                            if succ.parameter.implies(...
                                    parent.children{i}.parameter)
                                found = 1;
                                break
                            end
                        end
                        if ~found
                            newparam = memo.common(succ.parameter);
                            if newparam.isdefined(parent)
                                newpat = pat.pattern(root,parent,newparam,...
                                                     parent.memory);
                                if isempty(idx)
                                    if 0 %length(obj.values) < group
                                        obj.values{group} = value;
                                        obj.content{group} = {newpat.parameter};
                                    else
                                        obj.values(end+1) = value;
                                        obj.content{end+1} = newpat.parameter;
                                    end
                                else
                                     obj.content{idx} = newpat.parameter;
                                end
                                newpat.occurrence(occ,succ)
                            end
                        end
                    end
                else
                    if 0 %length(obj.values) < group
                        obj.values{group} = value;
                        obj.content{group} = {{{occ,succ}}};
                    else
                        obj.values(end+1) = value;
                        obj.content{end+1} = {{occ,succ}};
                    end
                    %if length(param) > 1
                    %    value(end+1) = param(2).value;
                    %end
                end
            end
            paramemo.value = memo;
            if isa(param,'seq.paramval')
                if ~isempty(obj.inter) && ~isempty(parent.parent)
                    specifi = {};
                    for i = 1:length(specif)
                        if isempty(specif{i})
                            specifi{i} = [];
                        else
                            specifi{i} = specif{i}.inter;
                        end
                    end
                    if length(paramemo) == 1
                        inter = param.inter;
                    else
                        inter = [param(1).inter param(2)];
                    end
                    [obj.inter paramemo(1).inter] = ...
                        obj.inter.learn(inter,occ,succ,...
                                        parent,specifi,cyclic,root,...
                                        options,detect);
                    obj.inter = obj.inter.combine('general',...
                                        inter,occ,succ,...
                                        parent,specifi,cyclic,root,...
                                        options);
                end
                obj = obj.combine('general',param,occ,succ,...
                                  parent,specif,cyclic,root,detect);
            end
        end
        %function obj = real(obj,paramemo,occ,succ,parent)
        %    if isa(paramemo.inter.value,'pat.pattern')
        %        param = paramemo.inter.value.parameter;
        %        param.fields{2}.value = 1;
        %        for i = 1:length(parent.children)
        %            if parent.children{i}.parameter.implies(param)
        %                return
        %            end
        %        end
        %        new = parent.link(memo,occ,succ);
        %        %new = pat.pattern(parent,param,parent.memory);
        %        %new.occurrence(occ,succ,0)
        %    end
        %end
        %function obj = shortcut(obj,param,newpat)  % obsolete
        %    %display('shortcut');
        %    %display(obj);
        %    %display(param);
        %    field = obj.find(param);
        %    if ~isempty(field)
        %        obj.content.(field) = newpat;
        %    end
        %    if isa(param,'seq.paramval')
        %        if ~isempty(obj.inter)
        %            obj.inter = obj.inter.shortcut(param.inter,newpat);
        %        end
        %        obj = obj.combine('shortcut','general',param,newpat);
        %    end
        %end
    end
end


function obj = memory(param,pattern)
    if isa(param,'seq.paramstruct')
        obj = pat.memostruct(param,pattern);
    else
        obj = pat.memoparam(param,pattern);
    end
end