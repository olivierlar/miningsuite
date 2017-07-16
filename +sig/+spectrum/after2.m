function x = after2(x,option)
    if option.log || option.db
        if ~x.log
            x.Ydata = sig.compute(@routine_log,x.Ydata);
            x.log = 1;
        end
        if option.db && x.log == 1
            x.Ydata = sig.compute(@routine_db,x.Ydata,x.power);
            x.log = 10;
            x.power = 2;
        end
        if option.db>0 && option.db < Inf
            x.Ydata = sig.compute(@routine_crop,x.Ydata,option.db);
        end
        x.phase = [];
    end
    
    if option.aver
        x.Ydata = sig.compute(@routine_smooth,x.Ydata,option.aver);
    end

    if option.gauss
        sigma = option.gauss;
        gauss = 1/sigma/2/pi*exp(- (-4*sigma:4*sigma).^2 /2/sigma^2);
        x.Ydata = sig.compute(@routine_gausssmooth,x.Ydata,sigma,gauss);
    end
end


%%
function d = routine_log(d)
    d = d.sum(1e-16).apply(@log10,{},{'element'});
end


%%
function d = routine_db(d,power)
    d = d.times(10);
    if power == 1
        d = d.times(2);
    end
end


%%
function d = routine_crop(d,N)
    d = d.apply(@crop,{N},{'element'},1);
end


function d = crop(d,N)
    d = d - max(d);
    d = max(d,-N) + N;
end


%%
function d = routine_smooth(d,N)
    d = d.apply(@smooth,{N},{'element'},1);
end


function d = smooth(d,N)
    d = filter(ones(1,N),1,d);
end


%%
function d = routine_gausssmooth(d,sigma,gauss)
    d = d.apply(@gausssmooth,{sigma,gauss},{'element'},1);
end


function x = gausssmooth(x,sigma,gauss)
    x = filter(gauss,1,[x;zeros(4*sigma,1)]);
    x = x(4*sigma:end);
end