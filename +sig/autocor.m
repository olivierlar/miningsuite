% SIG.AUTOCOR
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = autocor(varargin)
    varargout = sig.operate('sig','autocor',sig.autocor.options,...
                            @sig.autocor.init,@sig.autocor.main,@sig.autocor.after,...
                            varargin,@sig.autocor.combinechunks);
end