function varargout = brightness(varargin)
    out = sig.operate('aud','brightness',...
                            initoptions,@init,@main,@after,varargin);
    if isa(out{1},'sig.design')
        out{1}.nochunk = 1;
    end
    varargout = out;
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',.05,.5);
    
        cutoff.key = 'CutOff';
        cutoff.type = 'Numeric';
        cutoff.default = 1500;
    options.cutoff = cutoff;
end


%%
function [x type] = init(x,option,frame)
    if ~istype(x,'sig.Spectrum')
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.signal';
end


function out = main(in,option)
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


function x = after(x,option)
end