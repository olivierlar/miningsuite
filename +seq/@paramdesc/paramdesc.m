classdef paramdesc < sig.param
    properties (SetAccess = private)
        type
        value
        general
    end
	methods
        function obj = paramdesc(type,genval)
            obj = obj@sig.param(type.name);
            obj.type = type;
            obj.value = NaN;
            obj.general = genval;
        end
        function txt = display(obj,varargin)
            txt = display(obj.general,varargin{:});
        end
	end
end