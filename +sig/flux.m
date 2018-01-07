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
        frame.toggle = 1;
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.Signal';
end


function x = after(x,option)
end