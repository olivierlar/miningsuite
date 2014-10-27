function obj = hwr(obj)
    obj.Ydata = sig.compute(@main,obj.Ydata);
end


function out = main(d)
    d = d.apply(@routine,{},{'element'},Inf);
    out = {d};
end


function y = routine(x)
    y = 0.5 * (x + abs(x));
end