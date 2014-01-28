classdef paramgeneral < seq.paramtype
	properties (SetAccess = private)
		func
    end
	methods
        function obj = paramgeneral(def)
            if ischar(def)
                name = def;
            else
                name = func2str(def);
            end
            obj = obj@seq.paramtype(name);
            if isa(def,'function_handle')
                f = def;
            else
                f = str2func(def);
            end
            obj.func = f;
        end
	end
end