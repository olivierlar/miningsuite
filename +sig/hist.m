function varargout = hist(varargin)
    varargout = sig.operate('sig','hist',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
        n.key = 'Number';
        n.type = 'Numeric';
        n.default = 10;
    options.n = n;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Histogram')
        res = sig.compute(@routine,x.Ydata,option.n);
        x = sig.signal(res,'Name','Histogram',...
                       'Xsampling',1,'Xstart',1,...res{2},...
                       'Srate',x.Frate,'Ssize',x.Ssize);
    end
    out = {x};
end


function out = routine(d,nbins)
    if find(strcmp('element',d.dims)) && d.size('element') > 1
        dim = 'element';
    else
        dim = 'sample';
    end
    out = d.apply(@algo,{nbins},{dim},1);
    if strcmp(dim,'sample')
        out = out.deframe;
    end
end


function [n, xout] = algo(x,nbins)
    [n xout] = hist(x,nbins);
    n = n';
end


function x = after(x,option)
end