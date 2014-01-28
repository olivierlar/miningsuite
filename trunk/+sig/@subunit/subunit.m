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