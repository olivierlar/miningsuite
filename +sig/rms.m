function varargout = rms(varargin)

    if isnumeric(varargin{1})
        [options post] = sig.options(initoptions,varargin,'sig.rms');
        varargout = {sig.signal(varargin{1},'Name','RMS')};
    else
        
        varargout = sig.operate('sig','rms',...
                                initoptions,@init,@main,varargin,'plus');
    end
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
function [x type] = init(x,option)
    type = 'sig.Signal';
end


function out = main(in,option,postoption)
    x = in{1};
    if ~strcmpi(x.yname,'RMS energy')
        res = sig.compute(@routine,x.Ydata);
        x = sig.signal(res{1},'Name','RMS energy',...
                       'Srate',x.Frate,'Ssize',x.Ssize);
    end
    if ~isempty(postoption) && isstruct(postoption) && ...
            isfield(postoption,'notchunking') && postoption.notchunking
        x = after(x);    
    end
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
    x.Ydata = x.Ydata.apply(@afternorm,{x.Ssize},{dim},Inf);
end


function d = afternorm(d,l)
    d = sqrt(d)/sqrt(l);
end