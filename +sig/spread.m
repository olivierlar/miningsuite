function varargout = spread(varargin)
    varargout = sig.operate('sig','spread',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',.05,.5);
end


%%
function [x type] = init(x,option,frame)
    if x.istype('sig.signal')
        x = sig.spectrum(x);
    end
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Spread')
        res = sig.compute(@routine,x.Ydata,x.xdata);
        x = sig.signal(res,'Name','Spread',...
                       'Srate',x.Srate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d,f)
    e = d.apply(@algo,{f},{'element'},1);
    out = {e};
end


function y = algo(d,f)
    c = sig.centroid.algo(d,f);
    y = sqrt( sum((f'-c).^2 .* (d/sum(d)) ) );
end


function x = after(x,option)
end