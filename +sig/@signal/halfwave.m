function obj = halfwave(obj)
    obj.Ydata = sig.compute(@main,obj.Ydata);
end
    
   
function out = main(d)
    out = {d.hwr};
end