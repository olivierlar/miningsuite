classdef syntagm < seq.syntagm
	methods
		function obj = syntagm(event1,event2)
            obj = obj@seq.syntagm(event1,event2);
            occ = event1.occurrences;
            cyc = [];
            nocyc = [];
            for i = 1:length(occ)
                if isempty(occ(i).cycle)
                    nocyc = [nocyc occ(i)];
                else
                    cyc = [cyc occ(i)];
                end
            end
            occ = [cyc nocyc];
            for i = 1:length(occ)
                %if isempty(occ(i).cycle)
                completed = 0;
                while ~completed
                    for j = i+1:length(occ)
                        if ismember(occ(j),occ(i).specific)
                            occj = occ(j);
                            occ(j) = occ(i);
                            occ(i) = occj;
                            completed = -1;
                            break
                        end
                    end
                    completed = completed+1;
                end
                occ(i).memorize(obj);
            end
        end
        function val = overlaps(obj1,obj2)
            val = overlaps(obj1.to,obj2);
        end
	end
end