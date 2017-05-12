function varargout = brightness(varargin)
    varargout = sig.operate('aud','brightness',...
                            initoptions,@init,@main,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions(.05,.5);
    
        cutoff.key = 'CutOff';
        cutoff.type = 'Numeric';
        cutoff.default = 1500;
    options.cutoff = cutoff;
end


%%
function [x type] = init(x,option,frame)
    if ~istype(x,'sig.Spectrum')
        x = sig.spectrum(x);
    end
    type = 'sig.signal';
end


function out = main(in,option,postoption)
    x = in{1};
    if ~strcmpi(x.yname,'Brightness')
        res = sig.compute(@routine,x.Ydata,x.xdata,option.cutoff);
        x = sig.signal(res,'Name','Brightness',...
                       'Srate',x.Srate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
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