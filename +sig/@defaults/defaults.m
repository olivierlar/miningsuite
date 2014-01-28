classdef defaults < handle
    properties
        Signal = struct('Mix',0,'Center',0);
        Sequence = struct('Mix',0);
    end
    methods (Access = private)
        function obj = defaults
        end
    end
    methods (Static)
        function single = getInstance
            persistent local
            if isempty(local) || ~isvalid(local)
                local = sig.defaults;
            end
            single = local;
        end
        function d = get(class,field)
            h = sig.defaults.getInstance;
            d = h.(class);
            if nargin>1
                d = d.(field);
            end
        end
        function d = set(class,field,val)
            h = sig.defaults.getInstance;
            h.(class).(field) = val;
            d = h.(class);
        end
    end
end