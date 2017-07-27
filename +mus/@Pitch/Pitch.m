% MUS.PITCH CLASS
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Pitch < abst.concept
	properties %(SetAccess = private)
        heights
        pivottimescores
        pivoteventscores
    end
	methods
		function obj = Pitch
            obj = obj@abst.concept;
        end
        function obj = activate(obj,pitch,ioi,time,address)
            if isempty(obj.timescores)
                obj.timescores = 0;
                obj.pivottimescores = 0;
            elseif time > size(obj.timescores,1)
                obj.timescores(time,:,:) = obj.timescores(end,:,:);
                obj.pivottimescores(time,:,:) = obj.pivottimescores(end,:,:);
            end
            f = find(pitch == obj.heights,1);
            %fnear = []; %find(abs(pitch - obj.heights) < 1 & pitch~=obj.heights);
            ioiscore = max(0,ioi-.5);
            obj.pivoteventscores(address) = ioiscore;
            if isempty(f)
                % New pitch height detected
                %if ~isempty(fnear) && ...
                %        ~isempty(find(obj.timescores(end,fnear) > .5,1))
                %    if ~ornam
                %        obj.heights(end+1) = pitch;
                %        obj.timescores(end,end+1) = .5;
                %        for j = 1:length(fnear)
                %            obj.timescores(end,fnear(j)) = ...
                %                obj.timescores(end,fnear(j)) / 2;
                %        end
                %    end
                %else
                if isempty(obj.heights)
                    obj.heights = pitch;
                    obj.timescores(end,1) = 1;
                    obj.pivottimescores(end,1) = ioiscore;
                else
                    obj.heights(end+1) = pitch;
                    obj.timescores(end,end+1) = 1;
                    obj.pivottimescores(end,end+1) = ioiscore;
                end
            else
                % Further notes of the candidate mode detected
                %if ~isempty(fnear) && ...
                %        ~isempty(find(obj.timescores(end,fnear) > .5,1))
                %    if ~ornam
                %        obj.timescores(end,f) = .5;
                %        for j = 1:length(fnear)
                %            obj.timescores(end,fnear(j)) = ...
                %                obj.timescores(end,fnear(j)) / 2;
                %        end
                %    end
                %else
                    obj.timescores(end,f) = 1;
                    obj.pivottimescores(end,f) = ...
                        max(obj.pivottimescores(end,f),ioiscore);
                %end
            end
        end
    end
end