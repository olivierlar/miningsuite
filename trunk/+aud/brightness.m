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
    options = sig.Signal.frameoptions(.05,.5);
end


%%
function [x type] = init(x,option)
    x = sig.spectrum(x);
    type = 'sig.Signal';
end


function out = main(in,option,postoption)
    x = in{1};
    if 1 %~strcmpi(x.yname,'RMS energy')
        res = sig.compute(@routine,x.Ydata);
        x = sig.signal(res{1},'Name','Brightness',...
                       'Srate',x.Srate,'Ssize',x.Ssize);
    end
    out = {x};
end


function out = routine(d)
    e = d.apply(@algo,{},{'element'},1);
    %e = e.deframe;
    out = {e};
end


function y = algo(x)
    y = x'*x;
end


function x = after(x)
end