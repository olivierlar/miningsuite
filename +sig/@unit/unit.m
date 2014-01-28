classdef unit
%%
    properties
        name = ''
        origin = 0
        rate = 0
        generator = @defaultval
        finder = @defaultfind
    end
    methods
        function obj = unit(name,origin,rate,generator,finder)
            obj.name = name;
            obj.origin = origin;
            if nargin>2
                obj.rate = rate;
                if nargin>3
                    obj.generator = generator;
                    if nargin>4
                        obj.finder = finder;
                    end
                end
            end
        end
        function x = generate(obj,index)
            x = obj.generator(obj,index);
        end
    end
end


function x = defaultval(unit,index)
    x = (index - 1 + unit.origin) * unit.rate;
end


function index = defaultfind(unit,x)
    index = round(x / unit.rate) - unit.origin + 1;
end