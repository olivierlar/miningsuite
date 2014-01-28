classdef syntagm
	properties (SetAccess = protected)
		from
		to
    end
    properties
        weight
        descript
	end
	properties (Dependent)
		parameter
        unexplainedparameter
	end
	methods
		function obj = syntagm(from,to)
			obj.from = from;
			obj.to = to;
            if ~isempty(from) && ~isa(from,'seq.syntagm')
                from.from = [from.from obj];
            end
            to.to = [to.to obj];
		end
		function val = get.parameter(obj)
            if isempty(obj.from.parameter) ...
                    || ~isa(obj.from.parameter,'seq.param')
                val = obj.to.parameter;
            else
    			val = obj.from.parameter.paraminter(obj.to.parameter);
            end
        end
		function val = get.unexplainedparameter(obj)
            val = obj.parameter;
            %for i = 1:length(obj.to.occurrences)
            %    val = val.substract(obj.to.occurrences(i).parameter);
            %end
        end
	end
end