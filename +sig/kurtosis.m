% SIG.KURTOSIS
%
% Copyright (C) 2017 Olivier Lartillot
% © 2007-2009 Olivier Lartillot & University of Jyvaskyla
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
    if ~strcmpi(x.yname,'Kurtosis')
        res = sig.compute(@routine,x.Ydata,x.xdata);
        x = sig.signal(res,'Name','Kurtosis',...
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
    [s,c] = sig.spread.algo(d,f);
    y = sum((f'-c).^4.*(d/sum(d))) ./ s.^4;
end


function x = after(x,option)
end