function obj = normalize(obj)
    if isempty(obj.window)
        return
    end
    res = sig.compute(@main,obj.Ydata,obj.window);
    obj.Ydata = res{1};
end


function out = main(d,win)
    d = d.divide(win);
    out = {d};
end