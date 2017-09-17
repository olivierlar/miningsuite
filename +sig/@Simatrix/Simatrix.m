% sig.Simatrix class
%
% Copyright (C) 2017, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Simatrix < sig.Signal
    properties
        diagwidth
        view
        half
        similarity
    end
    methods
        function s = Simatrix(varargin)
            s = s@sig.Signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Dissimilarity Matrix';
            end
            s.xname = '?';    
            s.xsampling = 1;
        end
        display(obj)
    end
end