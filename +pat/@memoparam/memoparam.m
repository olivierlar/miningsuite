% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef memoparam < pat.memory
    properties (SetAccess = private)
        pattern
    end
    properties
        content = struct('values',[]);
        general
        inter
    end
	methods
        function obj = memoparam(param,pattern)
            obj = obj@pat.memory(param);
            if not(isa(param,'seq.paramval')) && ...
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
        function [field memo value] = find(obj,param,specif)
            if isa(param,'seq.paramtype')
                field = [];
                memo = [];
                return
            elseif isa(param,'seq.paramval')
                value = param.value;
            else
                value = param;
            end
            if isempty(value)
                field = [];
                memo = [];
                return
            end
            [dist idx] = min(abs(value - obj.content.values));
            if ~isempty(dist) && dist < .02
                value = obj.content.values(idx);
                field = pat.val2field(value);
                memo = obj.content.(field);
            else
                memo = [];
                for i = 1:length(specif)
                    if isempty(specif{i})
                        continue
                    end
                    [dist idx] = min(abs(value - specif{i}.content.values));
                    if ~isempty(dist) && dist < .02
                        value = specif{i}.content.values(idx);
                        field = pat.val2field(value);
                        memo = specif{i}.content.(field);
                        break
                    end
                end
                if isempty(memo)
                    field = pat.val2field(value);
                end
            end
        end
        function [obj paramemo] = learn(obj,param,occ,succ,parent,specif)
            [field memo value] = obj.find(param,specif);
            paramemo = param;
            if ~isempty(field)
                if ~isempty(memo)
                    if iscell(memo)
                        if (isa(memo{1}{2},'pat.syntagm') && ...
                                ~isequal(succ.to,memo{1}{2}.to)) || ...
                                (isa(memo{1}{2},'pat.event') && ...
                                ~isequal(succ,memo{1}{2}))
                            newpat = parent.link(memo,occ,succ);
                            if isempty(newpat)
                                if ~isfield(obj.content,field)
                                    obj.content.(field) = {{occ,succ}};
                                elseif iscell(obj.content.(field))
                                    obj.content.(field){end+1} = {occ,succ};
                                end
                            else
                                obj.content.(field) = newpat;
                                memo = newpat;
                            end
                        end
                    elseif isa(memo,'seq.paramstruct') ...
                             && ~succ.parameter.implies(memo)
                        found = 0;
                        for i = 1:length(parent.children)
                            if succ.parameter.implies(parent.children{i}.parameter)
                                found = 1;
                                break
                            end
                        end
                        if ~found
                            newparam = memo.common(succ.parameter);
                            if newparam.isdefined(parent)
                                newpat = pat.pattern(parent,newparam,parent.memory);
                                obj.content.(field) = newpat;
                                newpat.occurrence(occ,succ)
                            end
                        end
                    end
                else
                    obj.content.(field) = {{occ,succ}};
                    obj.content.values(end+1) = value;
                end
            end
            paramemo.value = memo;
            if isa(param,'seq.paramval')
                if ~isempty(obj.inter) && ~isempty(parent.parent)
                    specifi = {};
                    for i = 1:length(specif)
                        specifi{i} = specif{i}.inter;
                    end
                    [obj.inter paramemo.inter] = ...
                        obj.inter.learn(param.inter,occ,succ,parent,specifi);
                end
                obj = obj.combine('general',param,occ,succ,parent,specif);
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