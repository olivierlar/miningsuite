classdef occurrence < hgsetget
	properties (SetAccess = private)
		pattern
		prefix
		suffix
    end
    properties
        specific
        general
		extensions
    end
	methods
		function obj = occurrence(patt,pref,suff,cycle)                
            if nargin<4
                if isempty(pref)
                    cycle = [];
                else
                    cycle = pref.cycle;
                end
            end
            obj.pattern = patt;
            obj.prefix = pref;
            obj.suffix = suff;
            obj.cycle = cycle;
            if isa(suff,'pat.succession')
                suff.to.occurrence(obj);
            else
                suff.occurrence(obj);
            end
            if isempty(pref)
                for i = 1:length(suff.occurrences)
                    if ~isequal(suff.occurrences(i),obj)
                        if suff.occurrences(i).pattern.parameter.implies(...
                                suff.parameter)
                            suff.occurrences(i).general = ...
                                [suff.occurrences(i).general obj];
                            obj.specific = [obj.specific suff.occurrences(i)];
                        elseif isempty(suff.occurrences(i).prefix) ...
                                && suff.parameter.implies(...
                                        suff.occurrences(i).pattern.parameter)
                            suff.occurrences(i).specific = ...
                                [suff.occurrences(i).specific obj];
                            obj.general = [obj.general suff.occurrences(i)];
                        end
                    end
                end
            else
                pref.extensions = [pref.extensions obj];
                for i = 1:length(pref.specific)
                    for j = 1:length(pref.specific(i).extensions)
                        if pref.specific(i).extensions(j)...
                                .pattern.parameter.implies(suff.parameter)
                            obj.specific = [obj.specific ...
                                 pref.specific(i).extensions(j)];
                            pref.specific(i).extensions(j).general = ...
                                [pref.specific(i).extensions(j).general ...
                                 obj];
                        end
                    end
                end
                for i = 1:length(pref.general)
                    for j = 1:length(pref.general(i).extensions)
                        if suff.parameter.implies(pref.general(i) ...
                                .extensions(j).pattern.parameter)
                            obj.general = ...
                                [obj.general ...
                                 pref.general(i).extensions(j)];
                            pref.general(i).extensions(j).specific = ...
                                [pref.general(i).extensions(j).specific ...
                                 obj];
                        end
                    end
                end
            end
            %disp(' ');
            %display('Occurrence:');
            %display(obj.pattern);
            %display('::::');
            %display(obj.pattern.parameter);
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
        function pat = memorize(obj,varargin)
            pat = obj.pattern.memorize(obj,varargin{:});
        end
        function f = first(obj)
            if isempty(obj.prefix)
                f = obj;
            else
                f = obj.prefix.first;
            end
        end
        function txt = display(obj,varargin)
            if isempty(obj.prefix)
                txt = '';
            else
                txt = [display(obj.prefix,1) ' '];
            end
            txt = [txt display(obj.pattern.parameter,1)];%.fields{2},1)];
            if nargin < 2 && ~isempty(txt) && pat.verbose
                if isempty(obj.cycle)
                    disp(['Occurrence: ',txt]);
                else
                    disp(['Occurrence: ',txt,' towards:']);
                    display(obj.cycle);
                end
            end
        end
	end
end