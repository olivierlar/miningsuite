% SIG.ENVELOPE CLASS
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Envelope < sig.Signal
%%
    properties
        processed = 0
        log = 0
        diff = 0
        method
    end
%%
    methods
        function e = Envelope(varargin)
            i = 1;
            method = '';
            while i < length(varargin)
                if strcmpi(varargin{i},'Method')
                    varargin(i) = [];
                    method = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            e = e@sig.Signal(varargin{:});
            if strcmp(e.yname,'Signal')
                e.yname = 'Envelope';
            end
            e.method = method;
        end
        
        playclass(obj,options)
        
        function func = sonifier(obj)
            func = @sonify;
        end

        function d = get(obj,field)
            if strcmpi(field,'log')
                d = obj.log;
            elseif strcmpi(field,'diff')
                d = obj.diff;
            else
                d = get@sig.Signal(obj,field);
            end
        end
    end
end


%%
function [d,sr] = sonify(d,sr)
    d = resample(d,11025,round(sr));
    d = d/max(d);
    d = rand(length(d),1).*d;
    sr = 11025;
end