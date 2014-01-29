% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef event < seq.event
	properties
		occurrences
	end
	methods
		function obj = event(sequence,param,prev,suffix)
            if nargin<3
                prev = [];
            end
            if nargin<4
                suffix = [];
            end
            obj = obj@seq.event(sequence,param,prev,suffix);
        end
        function obj = occurrence(obj,occ)
            if isempty(obj.occurrences)
                obj.occurrences = occ;
            else
                obj.occurrences(end+1) = occ;
            end
        end
        function val = overlaps(obj1,obj2)
            if isa(obj2,'pat.occurrence')
                if isempty(obj2.prefix)
                    val = overlaps(obj1,obj2.suffix);
                else
                    val = overlaps(obj1,obj2.prefix);
                end
            else
                val = isequal(obj1,obj2);
            end
        end
    end
    %methods (Access = protected)
    %    function connect(obj1,obj2)
    %        pat.succession(obj1,obj2);
    %    end
    %end
end