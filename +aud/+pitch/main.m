% AUD.PITCH.MAIN
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(x,option,postoption)
    x = x{1};
    d = x.peakpos;
    out = {sig.Signal(d,'Name','Pitch','Srate',x.Srate,'Ssize',x.Ssize,'FbChannels',x.fbchannels)};
end