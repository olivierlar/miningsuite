% SIG.FLUX
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = flux(varargin)
    varargout = sig.operate('sig','flux',sig.flux.options,...
                            @init,@sig.flux.main,@after,varargin);
end


function [x,type] = init(x,option,frame)
    if x.istype('sig.signal')
        frame.toggle = 1;
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.signal';
end


function x = after(x,option)
end