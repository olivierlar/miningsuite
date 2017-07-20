% AUD.PITCH
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = pitch(varargin)
    varargout = sig.operate('aud','pitch',aud.pitch.options,...
                            @aud.pitch.init,@aud.pitch.main,@after,varargin);
end


function x = after(x,option)
end