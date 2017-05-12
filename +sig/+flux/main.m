function out = main(x,option,postoption)
    if isempty(option)
        x = {x};
        return
    end
    x = x{1};
    name = x.yname;
    if isa(x,'sig.Spectrum')
        name = 'Spectral flux';
    elseif strcmp(name,'Tonal centroid')
        name = 'Harmonic Change Detection Function';
    else
        name = [name,' flux'];
    end
    if option.complex
        if ~isa(x,'sig.Spectrum')
            error('ERROR IN SIG.FLUX: ''Complex'' option only defined for spectral flux.');
        end
        res = sig.compute(@complex_routine,x.Ydata,option,x.phase);
    else
        if option.inc
            method = @inc;
        else
            method = @flux;
        end
        res = sig.compute(@routine,x.Ydata,option,method);
    end
    x = sig.signal(res,'Name',name,'Srate',x.Srate,'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    out = {x};
end


function out = routine(in,option,method)
    out = in.apply(method,{option.dist},{'element','sample'},2);
end


function y = flux(x,dist)
    siz = size(x,2) - 1;
    y = zeros(1,siz);
    for i = 1:siz
        y(1,i) = pdist(x(:,[i,i+1])',dist);
    end
end


function y = inc(x,dist)
    dist = str2func(dist);
    siz = size(x,2) - 1;
    y = zeros(1,siz);
    for i = 1:siz
        y(1,i) = dist(x(:,i),x(:,i+1));
    end
end


function y = Euclidean(mi,mj)
    y = sqrt(sum(max(0,(mj-mi)).^2));
end


function y = City(mi,mj)
    y = sum(max(0,(mj-mi)));
end


function out = complex_routine(in,option,phase)
    out = in.apply(@complex,{phase},{'element','sample'},2);
end


function y = complex(x,phi)
    d = diff(phi,2,2);
    d = d/(2*pi) - round(d/(2*pi));
    g = sqrt(x(:,3:end).^2 + x(:,2:(end-1)).^2 ...
                            - 2.*x(:,3:end).*x(:,2:(end-1)).*cos(d));
    y = sum(g);
end