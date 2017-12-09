function obj = median(obj,field,order,offset)
    order = round(order * obj.Srate);
    obj.Ydata = sig.compute(@main,obj.Ydata,field,order,offset);
end
    
   
function out = main(d,field,order,offset)
    out = {d.median(field,order,offset)};
end
