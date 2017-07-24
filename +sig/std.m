function varargout = std(varargin)
    varargout = sig.operate('sig','std',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = struct;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    res = sig.compute(@routine,x.Ydata);
    x = sig.signal(res,'Name','Standard deviation',...
        'Xsampling',1,'Xstart',1,...
        'Srate',x.Frate,'Ssize',x.Ssize);
    out = {x};
end


function out = routine(d)
    if find(strcmp('element',d.dims)) && d.size('element') > 1
        dim = 'element';
    else
        dim = 'sample';
    end
    out = d.apply(@algo,{},{dim},1);
    if strcmp(dim,'sample')
        out = out.deframe;
    end
end


function n = algo(x)
    n = std(x);
    n = n';
end


function x = after(x,option)
end