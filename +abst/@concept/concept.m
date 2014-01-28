classdef concept < hgsetget
	properties %(SetAccess = private)
		name
    end
    properties
        timescores = []
        currentscores = []
        eventscores = []
        dependent = []
        depending = []
    end
    %properties (Dependent)
    %    score
    %end
	methods
		function obj = concept(name)
            if nargin<1
                name = '';
            end
            obj.name = name;
        end
        function obj = update(obj,score,event)
            if isempty(obj.scores)
                obj.scores = score;
            else
                obj.scores(:,event) = score;
            end
            if ~score
                for i = 1:length(obj.dependent)
                    if ~isempty(obj.dependent(i).scores) && ...
                            obj.dependent(i).scores(1,end)
                        alldown = 1;
                        for j = 1:length(obj.dependent(i).depending)
                            if obj.dependent(i).depending(j).scores(1,end)
                                alldown = 0;
                                break
                            end
                        end
                        if alldown
                            obj.dependent(i) = ...
                                obj.dependent(i).update(0,event);
                        end
                    end
                end
            end
        end
        function score = currentscore(obj)
            if isempty(obj.scores)
                score = [0;0];
            else
                score = obj.scores(:,end);
            end
        end
        
        %function s = get.score(obj)
        %    if isempty(obj.scores)
        %        s = [];
        %    elseif size(obj.scores,1) == 1
        %        s = obj.scores;
        %    else
        %        s = atan(obj.scores(1,:))/(pi/2) + ...
        %            atan(obj.scores(2,:))/(pi/2);
        %    end
        %end
        
        function display(obj)
            %if isempty(obj(1).score)
            %    return
            %end
            %figure
            %hold on
            %for i = 1:length(obj)
            %    plot(obj(i).score,'+-','Color',num2col(i));
            %end
            %legend(obj.name);
        end
        
        function obj = accentuate(obj,param,score)
            
        end
        function obj = activate(obj,param,score)
            
        end
    end
end