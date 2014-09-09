% Copyright (C) 2014, Olivier Lartillot
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
        function [idx memo value] = find(obj,param,group,specif)
            idx = [];
            if isa(param,'seq.paramtype')
                %field = [];
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
            %if length(param) > 1
            %    value2 = param(2).value;
            %else
            %    value2 = [];
            %end
            if isempty(value)
                %field = [];
                memo = [];
                return
            end
                        
            if isempty(obj.values) || length(obj.values) < group
                dist = [];
            else
                [dist idx] = min(abs(value - obj.values{group}));
            end
            if ~isempty(dist) && dist < .02
                value = obj.values{group}(idx);
                %field = pat.val2field(value);
                memo = obj.content{group}{idx};
            else
                memo = [];
                for i = 1:length(specif)
                    if isempty(specif{i}) || ...
                            length(specif{i}.values) < group
                        continue
                    end
                    [dist idx1] = min(abs(value - specif{i}.values{group}));
                    if ~isempty(dist) && dist < .02
                        value = specif{i}.values{group}(idx1);
                        %field = pat.val2field(value,value2);
                        memo = specif{i}.content{group}{idx1};
                        break
                    end
                end
                %if isempty(memo)
                %    field = pat.val2field(value);%,value2);
                %end
            end
        end
        function [obj paramemo] = learn(obj,param,group,occ,succ,parent,specif,cyclic,root)
            paramemo = param;
            if isa(param,'seq.paramtype')
                return
            end
            
            if 1 %isempty(group)
                group = 1;
            else
                switch group
                    case 'open'
                        group = 1;
                    case 'close'
                        group = 2;
                    case 'extend'
                        group = 3;
                end
            end

            [idx memo value] = obj.find(param,group,specif);
            if ~isempty(value)
                if ~isempty(memo)
                    if iscell(memo)
                        if (isa(memo{1}{2},'pat.syntagm') && ...
                                ~isequal(succ.to,memo{1}{2}.to)) || ...
                                (isa(memo{1}{2},'pat.event') && ...
                                ~isequal(succ,memo{1}{2}))
                            newpat = parent.link(memo,occ,succ,cyclic,...
                                                 group,root);
                            if 1 %isempty(newpat)
                                if isempty(idx)
                                    if length(obj.values) < group
                                        obj.values{group} = value;
                                        obj.content{group} = {{{occ,succ}}};
                                    else
                                        obj.values{group}(end+1) = value;
                                        obj.content{group}{end+1} = {{occ,succ}};
                                    end
                                elseif iscell(obj.content{group}{idx})
                                    obj.content{group}{idx}{end+1} = {occ,succ};
                                end
                            else
                                if isempty(idx)
                                    if length(obj.values) < group
                                        obj.values{group} = value;
                                        obj.content{group} = {newpat};
                                    else
                                        obj.values{group}(end+1) = value;
                                        obj.content{group}{end+1} = newpat;
                                    end
                                else
                                    obj.content{group}{idx} = newpat;
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
                                obj.content{group}{idx} = newpat;
                                newpat.occurrence(occ,succ)
                            end
                        end
                    end
                else
                    if length(obj.values) < group
                        obj.values{group} = value;
                        obj.content{group} = {{{occ,succ}}};
                    else
                        obj.values{group}(end+1) = value;
                        obj.content{group}{end+1} = {{occ,succ}};
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
                        obj.inter.learn(inter,group,occ,succ,...
                                        parent,specifi,cyclic,root);
                    obj.inter = obj.inter.combine('general',...
                                        inter,group,occ,succ,...
                                        parent,specifi,cyclic,root);
                end
                obj = obj.combine('general',param,group,occ,succ,...
                                  parent,specif,cyclic,root);
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