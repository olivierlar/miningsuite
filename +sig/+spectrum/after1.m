% SIG.SPECTRUM.AFTER1
%
% Copyright (C) 2017-2019 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [x,tmp] = after1(x,option)        
    if option.min || option.max < Inf
        [x.Ydata, x.Xaxis.start] = ...
            sig.compute(@extract,x.Ydata,x.xdata,x.Xaxis.start,option);
        
    end
    
    if isfield(option,'tmp')
        tmp = option.tmp;
    else
        tmp = [];
    end
    if option.timesmooth
        [x.Ydata, tmp] = ...
            sig.compute(@routine_timesmooth,x.Ydata,...
                        option.timesmooth,tmp);
    end
    
    if x.power == 1 && (option.pow || any(option.mprod) ...
                        || any(option.msum)) 
                % mprod could be tried without power?
        x.Ydata = sig.compute(@routine_square,x.Ydata);
        x.power = 2;
        x.yname = ['Power ',x.yname];
    end
    
    if any(option.mprod)
        x.Ydata = sig.compute(@routine_mprodsum,x.Ydata,...
                              option.mprod,@times);
        x.yname = 'Spectral product';
    end
    
    if any(option.msum)
        x.Ydata = sig.compute(@routine_mprodsum,x.Ydata,...
                              option.msum,@plus);
        x.yname = 'Spectral sum';
    end
    
    if option.norm
        x.Ydata = sig.compute(@routine_norm,x.Ydata);
    end
    
    if option.nl
        x.Ydata = sig.compute(@divide,x.Ydata,x.inputlength);
    end
end


%%
function out = extract(d,x,start,postoption)
    range = find(x >= postoption.min & x <= postoption.max);
    if ~isempty(range)
        d = d.extract('element',range([1,end]));
    end
    start = start + range(1) - 1;
    out = {d,start};
end


%%
function out = routine_timesmooth(d,N,tmp)
    [d, tmp] = d.apply(@timesmooth,{N,tmp},{'element','channel'});
    out = {d,tmp};
end


function [d, tmp] = timesmooth(d,N,tmp)
    B = ones(1,N)/N;
    [d, tmp] = filter(B,1,d,tmp,2);
end


%%
function d = routine_square(d)
    d = d.apply(@square,{},{'sample'});
end

function x = square(x)
    x = x.^2;
end


%%
function d = routine_mprodsum(d,coefs,func)
    d = d.apply(@mprodsum,{coefs,func},{'element'},1);
end


function y = mprodsum(x,coefs,func)
    y = x;
    for i = 1:length(coefs)
        mpr = coefs(i);
        if mpr
            xi = ones(size(x));
            xi(1:floor(end/mpr)) = x(mpr:mpr:end);
            y = func(y,xi);
        end
    end
end


%%
function d = routine_norm(d)
    n = d.apply(@norm,{},{'element'});
    d = d.divide(n);
end


%%
function d = divide(d,N)
    d = d.divide(N);
end