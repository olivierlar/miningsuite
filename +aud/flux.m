% AUD.FLUX
% auditory modeling of spectral flux
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = flux(varargin)
    varargout = sig.operate('aud','flux',options,...
                            @init,@sig.flux.main,@after,varargin);
end


function options = options    
    options = sig.flux.options;

        sb.key = 'SubBand';
        sb.type = 'String';
        sb.choice = {'Gammatone','2Channels','Manual'};
        sb.default = 'Manual';
    options.sb = sb;
end


function [x type] = init(x,option,frame)
    if x.istype('sig.signal')
        if strcmpi(option.sb,'Manual')
            x = sig.filterbank(x,'Cutoff',[-Inf 50*2.^(0:1:8) Inf],...
                               'Order',2);
        else
            x = aud.filterbank(x,option.sb);
        end
        frame.toggle = 1;
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.signal';
end


function x = after(x,option)
end