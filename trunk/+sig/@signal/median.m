function obj = median(obj,field,order,offset)
    order = round(order * obj.Srate);
    res = sig.compute(@main,obj.Ydata,field,order,offset);
    obj.Ydata = res{1};
end
    
   
function out = main(d,field,order,offset)
    out = {d.median(field,order,offset)};
end