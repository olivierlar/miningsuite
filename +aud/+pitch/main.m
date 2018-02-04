% AUD.PITCH.MAIN
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(x,option,postoption)
    x = x{1};
    d = x.peakprecisepos;
    out = {sig.Signal(d,'Name','Pitch','Srate',x.Srate,...
                      'Sstart',x.Sstart,'Send',x.Send,...
                      'Ssize',x.Ssize,'FbChannels',x.fbchannels)};
end