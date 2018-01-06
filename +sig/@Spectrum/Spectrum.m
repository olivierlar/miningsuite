% sig.Spectrum class
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
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
            cq = [];
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
                elseif strcmpi(varargin{i},'ConstantQ')
                    varargin(i) = [];
                    cq = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            s = s@sig.Signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Spectrum';
            end
            if isempty(cq)
                s.Xaxis.unit.name = 'Hz';
            else
                s.Xaxis.subunit = sig.subunit('Frequency','Hz',@exp2freq,cq);
            end
            s.Xaxis.name = 'Frequency';
            s.inputlength = il;
            s.phase = ph;
            s.inputsampling = is;
        end
        function d = get(obj,field)
            if strcmpi(field,'phase')
                d = obj.phase;
            elseif strcmpi(field,'frequency')
                d = obj.xdata;
            elseif strcmpi(field,'power')
                d = obj.power;
            elseif strcmpi(field,'log')
                d = obj.log;
            elseif strcmpi(field,'scale')
                d = obj.xname;
            else
                d = get@sig.Signal(obj,field);
            end
        end
    end
end


function f = exp2freq(t,param)
    f_min = param(1);
    r = param(2);
    f = f_min * r .^ t;
end


function d = sonifier(d,varargin)
end