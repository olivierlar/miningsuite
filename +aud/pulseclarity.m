% AUD.PULSECLARITY 
% estimates the clarity of the pulsation
%
% Copyright (C) 2017, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = pulseclarity(varargin)
    varargout = sig.operate('aud','pulseclarity',aud.pulseclarity.options,...
                            @aud.pulseclarity.init,...
                            @aud.pulseclarity.main,@after,...
                            varargin,'plus','extensive');
end


function x = after(x,option)
end