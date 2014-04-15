% sig.Envelope class
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Envelope < sig.signal
%%
    properties (Constant)
        envelopesonify = @sonifier;
    end
    properties
        loged = 0;
    end
%%
    methods
        function e = Envelope(varargin)
            e = e@sig.signal(varargin{:});
            if strcmp(e.yname,'Signal')
                e.yname = 'Envelope';
            end
        end
        %%
        function obj = after(obj,option)
            obj = sig.signal.aftermethod(obj,option);
        end
    end
end


%%
function d = sonifier(d,varargin)
end