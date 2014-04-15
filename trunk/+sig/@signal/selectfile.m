function obj = selectfile(obj,index)
    obj.celllayers(1) = [];
    cfields = obj.combinables;
    for i = 1:length(cfields)
        if isa(obj.(cfields{i}),'sig.data')
            obj.(cfields{i}).content = obj.(cfields{i}).content{index};
        elseif isa(obj.(cfields{i}),'sig.axis')
            obj.(cfields{i}).start = obj.(cfields{i}).start(index);
        elseif iscell(obj.(cfields{i}))
            obj.(cfields{i}) = obj.(cfields{i}){index};
        else
            obj.(cfields{i}) = obj.(cfields{i})(index);
        end
    end
end