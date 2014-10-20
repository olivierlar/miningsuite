% SIG.UNIT class
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

classdef unit
%%
    properties
        name = ''
        origin = 0
        rate = 0
        generator = @defaultval
        finder = @defaultfind
    end
    methods
        function obj = unit(name,origin,rate,generator,finder)
            obj.name = name;
            obj.origin = origin;
            if nargin>2
                obj.rate = rate;
                if nargin>3
                    obj.generator = generator;
                    if nargin>4
                        obj.finder = finder;
                    end
                end
            end
        end
        function x = generate(obj,index,segment)
            if nargin < 3
                x = obj.generator(obj,index);
            else
                x = obj.generator(obj,index,segment);
            end
        end
    end
end


function x = defaultval(unit,index,segment)
    if nargin < 2
        segment = 1;
    end
    if length(unit.rate) == 1
        rate = unit.rate;
    else
        rate = unit.rate(segment);
    end
    x = (index - 1 + unit.origin) * rate;
end


function index = defaultfind(unit,x)
    index = round(x / unit.rate) - unit.origin + 1;
end