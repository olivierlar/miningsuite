% AUD.BRIGHTNESS
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

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
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    
        cutoff.key = 'CutOff';
        cutoff.type = 'Numeric';
        cutoff.default = 1500;
    options.cutoff = cutoff;
end


%%
function [x type] = init(x,option)
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
    if ~strcmpi(x.yname,'Brightness')
        res = sig.compute(@routine,x.Ydata,x.xdata,option.cutoff);
        x = sig.Signal(res,'Name','Brightness',...
                       'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
                       'Ssize',x.Ssize,'FbChannels',x.fbchannels);
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