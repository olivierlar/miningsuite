% SIG.SUBUNIT CLASS
%
% Copyright (C) 2014, 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef subunit
%%
    properties
        dimname = ''
        unitname = ''
        converter
        parameter = NaN
    end
%%
    methods
        function obj = subunit(dimname,unitname,converter,parameter)
            obj.dimname = dimname;
            obj.unitname = unitname;
            obj.converter = converter;
            if nargin > 3
                obj.parameter = parameter;
            end
        end
    end
end