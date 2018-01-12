% MUS.HCDF
%
% Copyright (C) 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = hcdf(varargin)
    varargout = sig.operate('mus','hcdf',initoptions,@init,@main,@after,...
                            varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameManual',.743,.1);
end


%%
function [x,type] = init(x,option,frame)
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
    end
    x = mus.tonalcentroid(x);
    x = sig.flux(x);
    type = {'sig.Signal'};
end


function x = main(x,option)
    x{1}.yname = 'HCDF';
end


function x = after(x,option)
end