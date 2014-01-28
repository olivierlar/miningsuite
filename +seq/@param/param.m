classdef param
    properties % (SetAccess = private)
        name
    end
	methods
        function obj = param(name)
            if nargin < 1
                name = '';
            end
            obj.name = name;
        end
    end
end