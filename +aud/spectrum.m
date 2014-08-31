% AUD.SPECTRUM
% auditory modeling of spectrum decomposition
%
% Copyright (C) 2014, Olivier Lartillot
% Copyright (C) 1998, Malcolm Slaney, Interval Research Corporation
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('aud','spectrum',aud.spectrum.options,...
                            @init,@main,varargin,'sum');
end


function [x type] = init(x,option,frame)
    type = 'sig.Spectrum';
end


function out = main(x,option,postoption)
    y = sig.spectrum.main(x,option,postoption);
    if isempty(postoption)
        out = {y};
    else
        out = aud.spectrum.after(y,postoption);
    end
end