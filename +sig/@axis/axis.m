% SIG.AXIS class
% generates on the fly axis information such as time positions in signal.
% Internally called by sig.signal
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

classdef axis
%%
    properties
        name
        start
        unit = [];
        subunit = [];
    end
%%
    methods
        function obj = axis(name,start,varargin)
            obj.name = name;
            obj.start = start;
            if nargin > 2
               obj.unit = sig.unit(varargin{:});
            end
        end
        %%
        function x = index(obj,sd,segment)
            x = obj.start;
            if length(x) > 1
                if iscell(x)
                    x = x{segment};
                else
                    x = x(segment);
                end
            end
            x = x + (1:sd)-1;
        end
        
        function x = data(obj,sd,segment)
            if iscell(sd)
                x = cell(1,length(sd));
                for i = 1:length(sd)
                    x{i} = data(obj,sd{i},i);
                end
                return
            end
            if nargin < 3
                segment = 1;
            end
            x = obj.unit.generate(obj.index(sd,segment),segment);
            if ~isempty(obj.subunit) && ...
                    strcmpi(obj.name,obj.subunit.dimname)
                x = obj.subunit.converter(x);
            end
        end
        
        function index = find(obj,param)
            if strcmpi(param.unit,'sp')
                index = param.value;
            else
                if ~isempty(obj.subunit) && ...
                        strcmpi(param.unit,obj.subunit.unitname)
                    param.value = obj.subunit.converter(param.value);
                    param.value = param.value(end:-1:1);
                    %param.unit = obj.unit.name;
                end
                index = obj.unit.finder(obj.unit,param.value);
            end
            index = index - obj.start + 1;
        end
    end
end