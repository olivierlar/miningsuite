% SIG.KURTOSIS
%
% Copyright (C) 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = kurtosis(varargin)
    varargout = sig.operate('sig','kurtosis',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
end


%%
function [x type] = init(x,option,frame)
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                          'FrameHop',option.fhop.value,option.fhop.unit);
        end
        x = sig.spectrum(x);   
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Kurtosis')
        res = sig.compute(@routine,x.Ydata,x.xdata);
        x = sig.Signal(res,'Name','Kurtosis',...
                       'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
                       'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d,f)
    e = d.apply(@algo,{f},{'element'},1);
    out = {e};
end


function y = algo(d,f)
    [s,c] = sig.spread.algo(d,f);
    y = sum((f'-c).^4.*(d/sum(d))) ./ s.^4;
end


function x = after(x,option)
end