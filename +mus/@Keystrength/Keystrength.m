% mus.Keystrength class
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Keystrength < sig.signal
    properties (Constant)
    end
    properties   
        
    end
    methods
        function s = Keystrength(varargin)
            s = s@sig.signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Keystrength';
            end
            s.xname = 'Keys';    
            s.xsampling = 1;
        end
    end
end