function e = after(e,postoption)

    if postoption.aver
        e.Ydata = e.Ydata.apply(@smooth,{postoption.aver},{'sample'},1);
    end
    
    if postoption.gauss
        sigma = postoption.gauss;
        gauss = 1/sigma/2/pi*exp(- (-4*sigma:4*sigma).^2 /2/sigma^2);
        e.Ydata = e.Ydata.apply(@gausssmooth,{sigma,gauss},{'sample'},1);
    end
    
    if postoption.chwr
        e.Ydata = e.Ydata.center('sample');
        e.Ydata = e.Ydata.apply(@hwr,{},{'sample'});
    end
    
    if postoption.hwr
        e.Ydata = e.Ydata.apply(@hwr,{},{'sample'});
    end
    
    if postoption.center
        e.Ydata = e.Ydata.center('sample');
    end
    
    if e.log
        if postoption.minlog
            e.Ydata = e.Ydata.apply(@minlog,{postoption.minlog},{'sample'});
        end
    else
        if postoption.norm == 1
            e.Ydata = e.Ydata.apply(@norm,{},{'sample'});
        elseif ischar(postoption.norm) && ...
                strcmpi(postoption.norm,'AcrossSegments')
            d{k}{i} = d{k}{i}./repmat(mdk,[size(d{k}{i},1),1,1]);
        end
    end
end


function y = hwr(x)
    % Half-Wave Rectifier
    y = 0.5 * (x + abs(x));
end


function c = center(x)
    if isempty(x)
        c = [];
    else
        if find(isnan(x))
            warning('NaNs detected. Centering does not handle NaNs and will return NaN.');
        end
        c = x - repmat(mean(x),[size(x,1),1,1]);
    end
end


function x = minlog(x,thr)
    x(x<-thr) = NaN;
end


function x = norm(x)
    x = x / (max(abs(x)));
end


function x = smooth(x,n)
    x = filter(ones(1,n),1,[x;zeros(n,1)]);
    x = x(1+ceil(n/2):end-floor(x/2));
end


function x = gausssmooth(x,sigma,gauss)
    x = filter(gauss,1,[x;zeros(4*sigma,1)]);
    x = x(4*sigma:end);
end