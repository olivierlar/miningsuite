% AUD.PITCH CLASS
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Pitch < sig.Signal
%%
    properties
        amplitude = []
    end
%%
    methods
        function p = Pitch(varargin)
            i = 1;
            amp = [];
            while i < length(varargin)
                if strcmpi(varargin{i},'Amplitude')
                    varargin(i) = [];
                    amp = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            p = p@sig.Signal(varargin{:});
            p.amplitude = amp;
        end
        
        function d = get(obj,field)
            if strcmpi(field,'amplitude')
                d = obj.amplitude;
            else
                d = get@sig.Signal(obj,field);
            end
        end
    end
end