function obj = center(obj,dim)
    res = sig.compute(@main,obj.Ydata,dim);
    obj.Ydata = res{1};
end
    
   
function out = main(d,dim)
    out = {d.center(dim)};
end