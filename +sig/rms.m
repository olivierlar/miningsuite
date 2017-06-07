function varargout = rms(varargin)
    varargout = sig.operate('sig','rms',...
                            initoptions,@init,@main,varargin,'plus');
end


%%
function options = initoptions
    options = sig.signal.signaloptions(.05,.5);
    
        notchunking.type = 'Boolean';
        notchunking.when = 'After';
        notchunking.default = 1;
    options.notchunking = notchunking;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option,postoption)
    x = in{1};
    if ~strcmpi(x.yname,'RMS')
        d = sig.compute(@routine,x.Ydata);
        x = sig.signal(d,'Name','RMS',...
                       'Srate',x.Frate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    x = after(x);
    out = {x};
end


function out = routine(d)
    if find(strcmp('element',d.dims))
        dim = 'element';
    else
        dim = 'sample';
    end
    e = d.apply(@algo,{},{dim},1);
    e = e.deframe;
    out = {e};
end


function y = algo(x)
    y = x'*x;
end


function x = after(x)
    if find(strcmp('element',x.Ydata.dims))
        dim = 'element';
    else
        dim = 'sample';
    end
    x.Ydata = sig.compute(@routine_norm,x.Ydata,x.Ssize,dim);
end


function d = routine_norm(d,Ssize,dim)
    d = d.apply(@afternorm,{Ssize},{dim},Inf);
end


function d = afternorm(d,l)
    d = sqrt(d/l);
end