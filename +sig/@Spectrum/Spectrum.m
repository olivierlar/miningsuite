% sig.Spectrum class
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Spectrum < sig.Signal
    properties (Constant)
        spectrumsonify = @sonifier;
    end
    properties   
        inputsampling
        power = 1;
        log = 0;
        inputlength
        phase
    end
    methods
        function s = Spectrum(varargin)
            i = 1;
            il = NaN;
            ph = [];
            is = [];
            while i < length(varargin)
                if strcmpi(varargin{i},'InputLength')
                    varargin(i) = [];
                    il = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Phase')
                    varargin(i) = [];
                    ph = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'InputSampling')
                    varargin(i) = [];
                    is = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            s = s@sig.Signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Spectrum';
            end
            s.xname = 'Frequency';
            s.xunit = 'Hz';
            s.inputlength = il;
            s.phase = ph;
            s.inputsampling = is;
        end
    end
end


function d = sonifier(d,varargin)
end