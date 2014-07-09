function e = rescale(e,postoption)

    if postoption.log && ~e.log
        e.Ydata = e.Ydata.apply(@log10,{},{'sample'});
        e.log = 1;
    end
        
    if postoption.power
        e.Ydata = e.Ydata.apply(@square,{},{'sample'});
    end
end


function x = square(x)
    x = x.^2;
end