function varargout = flatness(varargin)
    varargout = sig.operate('sig','flatness',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',.05,.5);
end


%%
function [x type] = init(x,option,frame)
    if x.istype('sig.signal')
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Flatness')
        res = sig.compute(@routine,x.Ydata);
        x = sig.signal(res,'Name','Flatness',...
                       'Srate',x.Srate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d)
    e = d.apply(@algo,{},{'element'},1);
    out = {e};
end


function y = algo(d)
    n = size(d,1);
    ari = mean(d);
    geo = (prod(d.^(1/n)));
    logZero = warning('query','MATLAB:log:logOfZero');
    warning('off','MATLAB:log:logOfZero');
    y = geo./ari;
    warning(logZero.state,'MATLAB:log:logOfZero');
    y(isinf(y)) = 0;
end


function x = after(x,option)
end