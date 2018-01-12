% SIG.SPECTRUM
% decomposes energy along frequencies
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('sig','spectrum',sig.spectrum.options,...
                            @sig.spectrum.init,@sig.spectrum.main,...
                            @after,varargin,'plus');
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    [x,tmp] = sig.spectrum.after1(x,option);
    x = sig.spectrum.after2(x,option);
    out = {x tmp};
end