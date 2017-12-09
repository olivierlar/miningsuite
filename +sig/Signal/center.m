function obj = center(obj,dim)
    obj.Ydata = sig.compute(@main,obj.Ydata,dim);
end
    
   
function out = main(d,dim)
    out = {d.center(dim)};
end
