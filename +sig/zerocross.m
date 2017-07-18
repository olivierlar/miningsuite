function varargout = zerocross(varargin)
    varargout = sig.operate('sig','zerocross',...
                            initoptions,@init,@main,@after,varargin,'plus');
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',.05,.5);

        per.key = 'Per';
        per.type = 'String';
        per.choice = {'Second','Sample'};
        per.default = 'Second';
    options.per = per;

        dir.key = 'Dir';
        dir.type = 'String';
        dir.choice = {'One','Both'};
        dir.default = 'One';
    options.dir = dir;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Brightness')
        res = sig.compute(@routine,x.Ydata,x.Srate,option);
        x = sig.signal(res,'Name','Zero-crossing rate',...
                       'Deframe',x);
    end
    out = {x};
end


function out = routine(d,sr,option)
    d = d.apply(@algo,{option,sr},{'sample'},3);
    d = d.deframe;
    out = {d};
end


function y = algo(x,option,sr)
    y = sum(x(2:end,:,:).*x(1:end-1,:,:) < 0);
    if strcmp(option.per,'Sample')
        y = y / sr;
    end
    if strcmp(option.dir,'One')
        y = y / 2;
    end
end


function out = after(in,option)
    x = in{1};
    x.Ydata = sig.compute(@routine_norm,x.Ydata,x.Ssize);
    out = {x};
end


function d = routine_norm(d,Ssize)
    d = d.apply(@afternorm,{Ssize},{'sample'},Inf);
end


function d = afternorm(d,l)
    d = d/l;
end