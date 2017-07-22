% sig.Simatrix class
%
% Copyright (C) 2017, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Simatrix < sig.signal
    properties
        diagwidth
        view
        half
        similarity
    end
    methods
        function s = Simatrix(varargin)
            s = s@sig.signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Simatrix';
            end
            s.xname = '?';    
            s.xsampling = 1;
        end
        display(obj)
    end
end