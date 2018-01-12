% SIG.FLUX
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = flux(varargin)
    varargout = sig.operate('sig','flux',options,@init,@sig.flux.main,...
                            @after,varargin);
end


function options = options    
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    options = sig.flux.options(options);
end


function [x,type] = init(x,option,frame)
    if x.istype('sig.Signal')
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
            'FrameHop',option.fhop.value,option.fhop.unit);
        x = sig.spectrum(x);   
    end
    type = 'sig.Signal';
end


function out = after(x,option)
    x = x{1};
    if option.median(1)
        lr = round(option.median(1)*x.Srate);
        x.Ydata = sig.compute(@median_routine,x.Ydata,lr,option.median(2));
    end
    if option.hwr
        x = x.halfwave;
    end
    out = {x};
end


function out = median_routine(d,winlength,scalfact)
    d = d.apply(@routine,{winlength,scalfact},{'sample'},2);
    out = {d};
end


function y = routine(x,wl,scalfact)
    y = zeros(size(x));
    l = size(x,1);
    for i = 1:size(x,1)
        y(i,:) = x(i,:) - scalfact * median(x(max(1,i-wl):min(l,i+wl),:));
    end
end