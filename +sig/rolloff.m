function varargout = rolloff(varargin)
    out = sig.operate('sig','rolloff',...
                      initoptions,@init,@main,@after,varargin);
    if isa(out{1},'sig.design')
        out{1}.nochunk = 1;
    end
    varargout = out;
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',.05,.5);

        p.key = 'Threshold';
        p.type = 'Numeric';
        p.default = 85;
    options.p = p;

        minrms.key = 'MinRMS';
        minrms.when = 'After';
        minrms.type = 'Numerical';
        minrms.default = .005;
    options.minrms = minrms;
end


%%
function [x type] = init(x,option,frame)
    x = sig.spectrum(x);
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if option.p>1
        option.p = option.p/100;
    end
    if ~strcmpi(x.yname,'Roll-off')
        res = sig.compute(@routine,x.Ydata,x.xdata,option.p);
        x = sig.signal(res,'Name','Roll-off','Unit','Hz.',...
                       'Srate',x.Srate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d,f,p)
    d = d.apply(@algo,{f,p},{'element'},1);
    out = {d};
end


function v = algo(m,f,p)
    cs = cumsum(m);          % accumulation of spectrum energy
    thr = cs(end)*p;   % threshold corresponding to the rolloff point
    fthr = find(cs >= thr,1); % find the location of the threshold
    if isempty(fthr)
        v = NaN;
    else
        v = f(fthr);
    end
end


function x = after(x,option)
end