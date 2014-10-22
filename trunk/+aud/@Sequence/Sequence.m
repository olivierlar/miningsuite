classdef Sequence < seq.Sequence
%%
    methods
        function obj = Sequence(varargin)
            obj = obj@seq.Sequence(varargin{:});
        end
        function display(obj,h)
            if nargin < 2
                h = [];
            end
            disp(obj.name)
            if iscell(obj.files)
                for i = 1:length(obj.content)
                    aud.score(obj,h,i);
                end
            else
                aud.score(obj,h);
            end
        end
    end
end