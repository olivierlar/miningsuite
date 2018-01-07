% SIG.AUTOCOR CLASS
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Autocor < sig.Signal
    properties
        normalized = 0;
        window
        normwin
        ofSpectrum = 0;
    end
    methods
        function s = Autocor(varargin)
            i = 1;
            ofspectrum = 0;
            while i < length(varargin)
                if strcmpi(varargin{i},'ofSpectrum')
                    varargin(i) = [];
                    ofspectrum = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            s = s@sig.Signal(varargin{:});
            s.ofSpectrum = ofspectrum;
            
            if strcmp(s.yname,'Signal')
                s.yname = 'Autocor';
            end
            s.Xaxis.name = 'Lag';
            if ofspectrum
                s.Xaxis.unit.name = 'Hz';
            else
                s.Xaxis.subunit = sig.subunit('Frequency','Hz',@time2freq);
                s.Xaxis.unit.name = 's';
            end
        end
        function d = get(obj,field)
            if strcmpi(field,'ofSpectrum')
                d = obj.ofSpectrum;
            elseif strcmpi(field,'window')
                d = obj.window;
            else
                d = get@sig.Signal(obj,field);
            end
        end        
        obj = normalize(obj,win);
        obj = hwr(obj);
        obj = enhance(obj,param);
    end
end


function f = time2freq(t)
    f = 1./t;
end