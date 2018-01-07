% SIG.FRAMENOW
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function x = framenow(x,frame)
if iscell(x)
    x = x{1};
end
if isstruct(frame) && frame.toggle && frame.size.value
    frate = sig.compute(@sig.getfrate,x.Srate,frame);
    x.Ydata = x.Ydata.frame(frame,x.Srate);
    x.Frate = frate;
end