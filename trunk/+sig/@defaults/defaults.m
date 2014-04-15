% SIG.DEFAULTS class
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

classdef defaults < handle
    properties
        signal = struct('Mix',0,'Center',0);
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