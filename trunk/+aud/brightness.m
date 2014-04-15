function varargout = brightness(varargin)

    if 0 %isnumeric(varargin{1})
        [options post] = sig.options(initoptions,varargin,'sig.rms');
        varargout = {sig.signal(varargin{1},'Name','RMS')};
    else
        
        varargout = sig.operate('audi','brightness',...
                                initoptions,@init,@main,varargin,'plus');
    end
end


%%
function options = initoptions
    options = sig.signal.frameoptions(.05,.5);
    
        cutoff.key = 'CutOff';
        cutoff.type = 'Numeric';
        cutoff.default = 1500;
    options.cutoff = cutoff;
end


%%
function [x type] = init(x,option)
    x = sig.spectrum(x);
    type = 'sig.Signal';
end


function out = main(in,option,postoption)
    x = in{1};
    if ~strcmpi(x.yname,'Brightness')
        res = sig.compute(@routine,x.Ydata,x.xdata,option.cutoff);
        x = sig.signal(res{1},'Name','Brightness',...
                       'Srate',x.Srate,'Ssize',x.Ssize);
    end
    out = {x};
end


function out = routine(d,f,f0)
    e = d.apply(@algo,{f,f0},{'element'},3);
    out = {e};
end


function y = algo(m,f,f0)
    y = sum(m(f > f0,:,:)) ./ sum(m);
end


function x = after(x)
end