% SIG.SPECTRUM
% decomposes energy along frequencies
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('sig','spectrum',sig.spectrum.options,...
                            @sig.spectrum.init,@sig.spectrum.main,...
                            @sig.spectrum.after,varargin,'sum');
end