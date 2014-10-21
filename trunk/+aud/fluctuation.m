function varargout = fluctuation(varargin)
    varargout = sig.operate('aud','fluctuation',...
                            initoptions,@init,@main,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions();
    
        sum.key = 'Summary';
        sum.type = 'Boolean';
        sum.when = 'After';
        sum.default = 0;
    options.sum = sum;

        mr.key = 'MinRes';
        mr.type = 'Numeric';
        mr.default = .01;
    options.mr = mr;
    
        max.key = 'Max';
        max.type = 'Numeric';
        max.default = 10;
    options.max = max;

        band.type = 'String';
        band.choice = {'Mel','Bark'};
        band.default = 'Bark';
    options.band = band;
    
        inframe.key = 'InnerFrame';
        inframe.type = 'Numeric';
        inframe.number = 2;
        inframe.default = [.023 80];
    options.inframe = inframe;
    
        outframe.key = 'OuterFrame';
        outframe.type = 'Numeric';
        outframe.number = 2;
        outframe.default = [0 0];
        outframe.keydefault = [1 10];
    options.outframe = outframe;
end


%%
function [x type] = init(x,option,frame)
    if option.inframe(2) < option.max * 2
        option.inframe(2) = option.max * 2;
    end
    if ~istype(x,'sig.Spectrum')
        x = sig.frame(x,'FrameSize',option.inframe(1),'s',...
                      'FrameHop',option.inframe(2),'Hz');
    end
    x = aud.spectrum(x,'Power','Terhardt',option.band,'dB','Mask');
    x = aud.spectrum(x,'AlongBands','Max',option.max,...
                       'Window',0,... 'NormalLength',...(not working: we need to keep track of audio input length)
                       'Resonance','Fluctuation','MinRes',option.mr);
    type = 'sig.Spectrum';
end


function out = main(in,option,postoption)
    x = in{1};
    if postoption.sum
        x = sig.sum(x);
        %x.Ydata = sig.compute(@summary,x.Ydata);
    end
    x.yname = 'Fluctuation';
    out = {x};
end


function d = summary(d)
    d = d.sum('channel');
end