% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef memory < hgsetget
    properties (SetAccess = private)
        name
    end
    properties
        fields = {}
    end
	methods
        function obj = memory(param)
            obj.name = param.name;
            obj.fields = param.fields;
        end
        function obj = combine(obj,field,param,occ,succ,parent,specif,...
                               cyclic,root,options,detect)
            if nargin < 8
                cyclic = 0;
            end
            if isempty(obj.(field))
                return 
            end
            specifields = {}; 
            for i = 1:length(specif)
                if ~isempty(specif{i})
                    specifields{end+1} = specif{i}.(field);
                end
            end
            if ~length(param(1).(field))
                return
            end
            paramemo = [];
            for i = 1:length(obj.(field))
                if strcmp(field,'fields') && ...
                        (i < 2 || i > 4 || ...
                         (i == 2 && ~options.chro) || ...
                         (i == 3 && ~options.dia) || ...
                         (i == 4 && ~options.onset))
                    continue
                end
                specifieldi = [];
                if iscell(param(1).(field))
                    paramfieldi = param(1).(field){i};
                    for j = 1:length(specifields)
                        specifieldi{j} = specifields{j}{i};
                    end
                else
                    paramfieldi = param(1).(field)(i);
                    for j = 1:length(specifields)
                        if ~isempty(specifields{j})
                            specifieldi{j} = specifields{j}(i);
                        end
                    end
                end
                if isempty(paramfieldi)
                    continue
                end
                %if strcmp(field,'fields') && ...
                %        isa(param.fields{9},'seq.paramval')
                %    paramfieldi = [paramfieldi param.fields{9}];
                %end
                if iscell(obj.(field))
                    if ~isempty(obj.(field){i})
                        [obj.(field){i} paramemo] = ...
                            obj.(field){i}.learn(paramfieldi,occ,succ,...
                                                 parent,specifieldi,...
                                                 cyclic,root,options,...
                                                 detect);
                    end
                else
                    [obj.(field)(i) paramemo] = ...
                        obj.(field)(i).learn(paramfieldi,occ,succ,...
                                             parent,specifieldi,cyclic,...
                                             root,options,detect);
                end
            end
            if isfield(paramemo,'inter') && ...
                    ~isempty(paramemo.inter) && ...
                    isa(paramemo.inter.value,'pat.pattern')
                error(1)
                patt = paramemo.inter.value;
                param2 = patt.parameter;

                for i = 1:length(parent.children)
                    if parent.children{i}.parameter.implies(param2)
                        return
                    end
                end

                memo = [];
                all = 1;
                for i = 1:length(patt.occurrences)
                    if isequal(patt.occurrences(i).suffix,succ)
                        continue
                    end
                    if patt.occurrences(i).suffix.parameter.fields{4}.value ...
                            == param.fields{4}.value
                        if isempty(memo)
                            memo = patt.occurrences(i);
                        else
                            memo(end+1) = patt.occurrences(i);
                        end
                    else
                        all = 0;
                    end
                end
                if all
                    %1
                elseif ~isempty(memo)
                    parent.link(memo,occ,succ,cyclic,param2,root);
                end
            end
        end
    end
end