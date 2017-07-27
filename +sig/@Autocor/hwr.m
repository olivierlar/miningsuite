% SIG.SPECTRUM.HWR
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = hwr(obj)
    obj.Ydata = sig.compute(@main,obj.Ydata);
end


function out = main(d)
    d = d.apply(@routine,{},{'element'},Inf);
    out = {d};
end


function y = routine(x)
    y = 0.5 * (x + abs(x));
end