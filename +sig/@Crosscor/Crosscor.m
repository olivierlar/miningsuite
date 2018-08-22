% Sig.Crosscor class
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Crosscor < sig.Signal
    properties
        maxlag
    end
    methods
        function s = Crosscor(varargin)
            i = 1;
            while i < length(varargin)
                if strcmpi(varargin{i},'maxlag')
                    varargin(i) = [];
                    maxlag = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            s = s@sig.Signal(varargin{:});
            s.maxlag = maxlag;
            if strcmp(s.yname,'Signal')
                s.yname = 'Crosscorrelation Matrix';
            end
            s.Xaxis.name = '?';    
            s.xsampling = 1;
        end
        display(obj)
    end
end