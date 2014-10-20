function e = rescale(e,postoption)
    if postoption.log && ~e.log
        e.Ydata = sig.compute(@main,e.Ydata,@log10);
        e.log = 1;
    end
        
    if postoption.power
        e.Ydata = sig.compute(@main,e.Ydata,@square);
    end
end


function d = main(d,func)
    d = d.apply(func,{},{'sample'});
end


function x = square(x)
    x = x.^2;
end