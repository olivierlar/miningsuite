% SIG.ENVELOPE.AFTER
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function e = after(e,postoption)
    e.Ydata = sig.compute(@main,e.Ydata,postoption,e.log);
end


function d = main(d,postoption,elog)
    if postoption.aver
        d = d.apply(@smooth,{postoption.aver},{'sample'},1);
    end
    
    if postoption.gauss
        sigma = postoption.gauss;
        gauss = 1/sigma/2/pi*exp(- (-4*sigma:4*sigma).^2 /2/sigma^2);
        d = d.apply(@gausssmooth,{sigma,gauss},{'sample'},1);
    end
    
    if postoption.chwr
        d = d.center('sample');
        d = d.hwr;
    end
    
    if postoption.hwr
        d = d.hwr;
    end
    
    if postoption.center
        d = d.center('sample');
    end
    
    if elog
        if postoption.minlog
            d = d.apply(@minlog,{postoption.minlog},{'sample'});
        end
    elseif postoption.norm == 1
            d = d.apply(@norm,{},{'sample'},1);
    elseif ischar(postoption.norm) && ...
            strcmpi(postoption.norm,'AcrossSegments')
        d = d./repmat(mdk,[size(d,1),1,1]); % not ready yet!
    end
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