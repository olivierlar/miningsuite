% MUS.KEYSOM CLASS
%
% Copyright (C) 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef KeySOM < sig.signal
    methods
        function s = KeySOM(varargin)
            s = s@sig.signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Key SOM';
            end
            s.xname = '?';    
            s.xsampling = 1;
        end
        display(obj)
    end
end