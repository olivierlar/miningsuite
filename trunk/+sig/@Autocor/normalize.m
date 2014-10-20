function obj = normalize(obj)
    if isempty(obj.window)
        return
    end
    obj.Ydata = sig.compute(@main,obj.Ydata,obj.window);
end


function out = main(d,win)
    d = d.divide(win);
    out = {d};
end