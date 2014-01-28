classdef mode < abst.concept
	properties %(SetAccess = private)
        scale
        pivot
        origins
        ispivot
        degreescores
        currentdegreescores
    end
	methods
		function obj = mode(name,scale,pivot)
            obj = obj@abst.concept(name);
            obj.scale = scale;
            if nargin > 2
                obj.pivot = pivot;
            end
        end
        function obj = activate(obj,pitch)
            pmin = min(pitch.heights);
            pmax = max(pitch.heights)-obj.scale(end);
            if pmax < pmin
                return
            end
            
            t = size(pitch.scores,1);
            if isempty(obj.origins)
                obj.origins = pmin:.5:pmax;
                obj.scores = zeros(1,length(obj.origins));
            else
                if pmin < obj.origins(1)
                    new = pmin:.5:obj.origins(1)-.5;
                    obj.origins = [new obj.origins];
                    obj.scores = [zeros(t-1,length(new)) obj.scores];
                    obj.jinscores = [zeros(t-1,length(new)) obj.jinscores];
                end
                if pmax > obj.origins(end)
                    new = obj.origins(end)+.5:.5:pmax;
                    obj.origins = [obj.origins new];
                    obj.scores = [obj.scores zeros(t-1,length(new))];
                    obj.jinscores = [obj.jinscores zeros(t-1,length(new))];
                end
            end
            for i = 1:length(obj.origins)
                sj = 1;
                for j = 1:length(obj.scale)
                    idx = find(obj.origins(i) + obj.scale(j)...
                                == pitch.heights,1);
                    if isempty(idx)
                        sj = 0;
                        break
                    else
                        sj = sj*pitch.scores(t,idx);
                    end
                end
                obj.scores(t,i) = sj;
            end
        end
    end
end