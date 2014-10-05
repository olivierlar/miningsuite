function obj = halfwave(obj)
    res = sig.compute(@main,obj.Ydata);
    obj.Ydata = res{1};
end
    
   
function out = main(d)
    out = {d.hwr};
end