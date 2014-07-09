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
        envelopesonify = @sonifier
    end
    properties
        log = 0
        diff = 0
        method
    end
%%
    methods
        function e = Envelope(varargin)
            i = 1;
            method = '';
            while i < length(varargin)
                if strcmpi(varargin{i},'Method')
                    varargin(i) = [];
                    method = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            e = e@sig.signal(varargin{:});
            if strcmp(e.yname,'Signal')
                e.yname = 'Envelope';
            end
            e.method = method;
        end
        %%
    end
end


%%
function d = sonifier(d,varargin)
end