function out = after(x,postoption)
    if iscell(x)
        x = x{1};
    end
    
    if isfield(postoption,'tmp')
        tmp = postoption.tmp;
    else
        tmp = [];
    end
        
    if postoption.min || postoption.max < Inf
        d = x.xdata;
        range = find(d >= postoption.min & d <= postoption.max);
        if ~isempty(range)
            x.Ydata = x.Ydata.extract('element',range([1,end]));
        end
        x.Xaxis.start = x.Xaxis.start + range(1);
    end
    
    if postoption.timesmooth
        [d tmp] = x.Ydata.apply(@timesmooth,{postoption.timesmooth,tmp},...
                                {'sample'});
        x.Ydata = d;
    end
    
    if x.power == 1 && (postoption.pow || any(postoption.mprod) ...
                        || any(postoption.msum)) 
                % mprod could be tried without power?
        x.Ydata = x.Ydata.apply(@square,{},{'sample'});
        x.power = 2;
        x.yname = ['Power ',x.yname];
    end
    
    if any(postoption.mprod)
        x.Ydata = x.Ydata.apply(@mprodsum,{postoption.mprod,@times},...
                                {'element'},1);
        x.yname = 'Spectral product';
    end
    
    if any(postoption.mprod)
        x.Ydata = x.Ydata.apply(@mprodsum,{postoption.msum,@sum},...
                                {'element'},1);
        x.yname = 'Spectral sum';
    end
    
    if postoption.norm
        nx = x.Ydata.apply(@norm,{},{'element'});
        x.Ydata = x.Ydata.divide(nx);
    end
    
    if postoption.nl
        x.Ydata = x.Ydata.divide(x.inputlength);
    end
    
    if postoption.log || postoption.db
        if ~x.log
            x.Ydata = x.Ydata.sum(1e-16).apply(@log10,{},{'element'});
            x.log = 1;
        end
        if postoption.db && x.log == 1
            x.Ydata = x.Ydata.times(10);
            if x.power == 1
                x.Ydata = x.Ydata.times(2);
            end
            x.log = 10;
            x.power = 2;
        end
        if postoption.db>0 && postoption.db < Inf
            x.Ydata = x.Ydata.apply(@crop,{postoption.db},{'element'},1);
        end
        x.phase = [];
    end
    
    if postoption.aver
        x.Ydata = x.Ydata.apply(@smooth,{postoption.aver},{'element'},1);
    end

    if postoption.gauss
        sigma = postoption.gauss;
        gauss = 1/sigma/2/pi*exp(- (-4*sigma:4*sigma).^2 /2/sigma^2);
        x.Ydata = x.Ydata.apply(@gausssmooth,{sigma,gauss},{'element'},1);
    end
    
    out = {x,tmp};
end


function [x tmp] = timesmooth(x,N,tmp)
    B = ones(1,N)/N;
    [x tmp] = filter(B,1,x,tmp);
end


function x = square(x)
    x = x.^2;
end


function y = mprodsum(x,coefs,func)
    y = x;
    for i = 1:length(coefs)
        mpr = coefs(i);
        if mpr
            xi = ones(size(x));
            xi(1:floor(end/mpr)) = x(mpr:mpr:end);
            x = func(x,xi);
        end
    end
end


function x = crop(x,N)
    x = x - max(x);
    x = max(x,-N) + N;
end


function x = smooth(x,n)
    x = filter(ones(1,n),1,x);
end


function x = gausssmooth(x,sigma,gauss)
    x = filter(gauss,1,[x;zeros(4*sigma,1)]);
    x = x(4*sigma:end);
end