% AUD.TEMPO
% detects event periodicity
%
% Copyright (C) 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = tempo(varargin)
    varargout = sig.operate('aud','tempo',aud.tempo.options,...
                            @aud.tempo.init,@aud.tempo.main,@after,varargin);
end


function x = after(x,option)
end