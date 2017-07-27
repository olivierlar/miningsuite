% AUD.MFCC CLASS
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Mfcc < sig.signal
    properties (Constant)
    end
    properties   
        delta = 0;
    end
    methods
        function c = Mfcc(varargin)
            i = 1;
            delta = 0;
            while i < length(varargin)
                if strcmpi(varargin{i},'Delta')
                    varargin(i) = [];
                    delta = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            c = c@sig.signal(varargin{:});
            if strcmp(c.yname,'Signal')
                c.yname = 'Mel-frequency cepstrum coefficient';
            end
            c.xname = 'Rank';
            c.delta = delta;
        end
    end
end


function d = sonifier(d,varargin)
end