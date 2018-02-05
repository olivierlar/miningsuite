% SIG.AUTOCOR.INIT
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [x,type] = init(x,option)
    if option.frame
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
    end
    type = 'sig.Autocor';
end