function obj = hwr(obj)
    res = sig.compute(@main,obj.Ydata);
    obj.Ydata = res{1};
end


function out = main(d)
    d = d.apply(@routine,{},{'element'},Inf);
    out = {d};
end


function y = routine(x)
    y = 0.5 * (x + abs(x));
end