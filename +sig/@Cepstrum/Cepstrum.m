% sig.Cepstrum class
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Cepstrum < sig.Signal
%%
    properties   
        phase
    end
%%
    methods
        function c = Cepstrum(varargin)
            i = 1;
            f = 0;
            ph = [];
            while i < length(varargin)
                if strcmpi(varargin{i},'Freq')
                    varargin(i) = [];
                    f = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Phase')
                    varargin(i) = [];
                    ph = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            c = c@sig.Signal(varargin{:});
            if strcmp(c.yname,'Signal')
                c.yname = 'Cepstrum';
            end
            if f
                c.xunit = 'Hz';
                c.Xaxis.name = 'Frequency';
                c.Xaxis.unit.generator = @freq;
            else
                c.xunit = 's';
                c.Xaxis.name = 'Quefrency';
            end
            c.phase = ph;
        end
        function d = get(obj,field)
            if strcmpi(field,'phase')
                d = obj.phase;
            else
                d = get@sig.Signal(obj,field);
            end
        end
    end
end


function x = freq(unit,index,segment)
    x = 1./((index - 1 + unit.origin) * unit.rate);
end