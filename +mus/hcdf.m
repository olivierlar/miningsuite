% MUS.HCDF
%
% Copyright (C) 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = hcdf(varargin)
    varargout = sig.operate('mus','hcdf',initoptions,@init,@main,@after,...
                            varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameManual',.743,.1);
end


%%
function [x,type] = init(x,option,frame)
    if ~istype(x,'mus.tonalcentroid')
        frame.toggle = 1;
        x = mus.tonalcentroid(x,'FrameConfig',frame);
    end
    x = sig.flux(x);
    type = {'sig.signal'};
end


function x = main(x,option)
    x{1}.yname = 'HCDF';
end


function x = after(x,option)
end