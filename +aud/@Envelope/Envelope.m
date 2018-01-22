% AUD.ENVELOPE CLASS
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Envelope < sig.Envelope
%%
    properties
        onsets = []
        attacks = []
        decays = []
        offsets = []
    end
%%
    methods
        function e = Envelope(varargin)
            i = 1;
            on = [];
            at = [];
            de = [];
            of = [];
            while i < length(varargin)
                if strcmpi(varargin{i},'Onsets')
                    varargin(i) = [];
                    on = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Attacks')
                    varargin(i) = [];
                    at = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Decays')
                    varargin(i) = [];
                    de = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Offsets')
                    varargin(i) = [];
                    of = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            e = e@sig.Envelope(varargin{:});
            e.onsets = on;
            e.attacks = at;
            e.decays = de;
            e.offsets = of;
        end
        
        function d = get(obj,field)
            if strcmpi(field,'attacks')
                d = obj.attacks;
            elseif strcmpi(field,'decays')
                d = obj.decays;
            else
                d = get@sig.Envelope(obj,field);
            end
        end
        
        display(obj)
    end
end