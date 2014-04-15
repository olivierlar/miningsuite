% sig.Spectrum class
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Spectrum < sig.signal
%%
    properties (Constant)
        spectrumsonify = @sonifier;
    end
    properties   
        Xsampling
        powered = 0;
        loged = 0;
        terharded = 0;
        resonance = '';
        masked = 0;
    end
%%
    methods
        function s = Spectrum(varargin)
            s = s@sig.signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Spectrum';
            end
            s.xname = 'Frequency';
            s.xunit = 'Hz';
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