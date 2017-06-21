function varargout = zerocross(varargin)
    varargout = sig.operate('sig','zerocross',...
                            initoptions,@init,@main,varargin,'plus');
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


function out = main(in,option,postoption)
    x = in{1};
    if ~strcmpi(x.yname,'Brightness')
        res = sig.compute(@routine,x.Ydata,x.Srate,option);
        x = sig.signal(res,'Name','Zero-crossing rate',...
                       'Deframe',in{1});
    end
    out = {x};
end


function out = routine(d,sr,option)
    d = d.apply(@algo,{option,sr},{'sample'},3);
    d = d.deframe;
    out = {d};
end


function out = algo(x,option,sr)
    n = sum(x(2:end,:,:).*x(1:end-1,:,:) < 0) / size(x,1);
    if strcmp(option.per,'Second')
        n = n * sr;
    end
    if strcmp(option.dir,'One')
        n = n / 2;
    end
    out = n;
end