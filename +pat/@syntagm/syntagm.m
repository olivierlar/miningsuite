% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef syntagm < seq.syntagm
	methods
		function obj = syntagm(event1,event2,root,memorize,options)
            obj = obj@seq.syntagm(event1,event2);
            
            if nargin < 4
                memorize = 1;
            end
            if ~memorize
                return
            end
            
            event1 = obj.from;
            occ = event1.occurrences;
            if isempty(occ)
                return
            end
            
            cyc = [];
            nocyc = [];
            for i = 1:length(occ)
                if ~isempty(occ(i).cycle)
                %    nocyc = [nocyc occ(i)];
                %else
                %    cyc = [cyc occ(i)];
                %end
            %end
            %for i = 1:length(cyc)
            %    cyc(i).memorize(obj,root,[],1);
            %end
                    occ(i).track_cycle(obj,root);
                end
            end
            
            %occ = nocyc;
            genpool{length(occ)} = [];
            if length(occ) > 1
                genpool{length(occ)-1} = [occ(end).pattern ...
                                          occ(end).pattern.general];
                for i = length(occ)-1:-1:2
                    genpool{i-1} = union(genpool{i},...
                                         [occ(i).pattern ...
                                          occ(i).pattern.general]);
                end
            end
            for i = 1:length(occ)
                occ(i).memorize(obj,root,options,genpool{i});
            end
        end
        function val = overlaps(obj1,obj2)
            val = overlaps(obj1.to,obj2);
        end
	end
end