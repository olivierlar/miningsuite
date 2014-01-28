classdef paraminter < seq.paramtype
	properties (SetAccess = private)
		func
    end
	methods
        function obj = paraminter(def,fields)
            if nargin < 2
                fields = {};
            end
            if ischar(def)
                name = def;
            else
                name = func2str(def);
            end
            obj = obj@seq.paramtype(name,fields);
            if isa(def,'function_handle')
                f = def;
            else
                f = str2func(def);
            end
            obj.func = f;
        end
	end
end