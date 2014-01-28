classdef Sequence < seq.Sequence
%%
    properties
        scale
        concept
    end
%%
    methods
        function res = get(obj,param)
            c = obj.content;
            if iscell(obj.files)
            else
                l = length(c);
                v = zeros(l,1);
                for i = 1:l
                    p = c{i}.parameter.getfield(param);
                    v(i) = p.value;
                end
                d = sig.data(v,{'sample'});
                res = sig.Signal(d,param,'','','',0,0,1,0,l,0);
                res.design = sig.design('musi','get','','',[],[],[],0,[],[],[],0,0);
                res.design.evaluated = 1;
            end
        end
        function display(obj)
            disp(obj.name)
            if iscell(obj.files)
                for i = 1:length(obj.content)
                    mus.pianoroll(obj.content{i},obj.concept{i});
                end
            else
                mus.pianoroll(obj.content,obj.concept);
            end
        end
    end
end