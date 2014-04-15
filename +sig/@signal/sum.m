function obj = sum(obj,dim)
    sum = sig.compute(@main,obj.Ydata,dim);
    obj.Ydata = sum{1};
end
    
   
function out = main(d,dim)
    out = {d.sum(dim)};
end