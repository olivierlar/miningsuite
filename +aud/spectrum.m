% AUD.SPECTRUM
% auditory modeling of spectrum decomposition
%
% Copyright (C) 2017, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('aud','spectrum',aud.spectrum.options,...
                            @sig.spectrum.init,@sig.spectrum.main,...
                            @aud.spectrum.after,varargin,'sum');
end