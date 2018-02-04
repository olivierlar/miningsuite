% mus.Keystrength class
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Keystrength < sig.Signal
    properties (Constant)
    end
    properties   
        
    end
    methods
        function s = Keystrength(varargin)
            s = s@sig.Signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Keystrength';
            end
            s.Xaxis.name = 'Keys';    
            s.xsampling = 1;
            s.xunsampled = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B','c','c#','d','d#','e','f','f#','g','g#','a','a#','b'};
        end
    
        function d = get(obj,field)
            if strcmpi(field,'strength')
                d = obj.Ydata;
            elseif strcmpi(field,'key')
                d = obj.xdata;
            else
                d = get@sig.Signal(obj,field);
            end
        end
    end
end