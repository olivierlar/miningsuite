% SIG.SUBUNIT CLASS
%
% Copyright (C) 2014 Olivier Lartillot
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
    end
%%
    methods
        function obj = subunit(dimname,unitname,converter)
            obj.dimname = dimname;
            obj.unitname = unitname;
            obj.converter = converter;
        end
    end
end