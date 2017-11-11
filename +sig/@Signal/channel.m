% SIG.SIGNAL.CHANNEL
%
% Copyright (C) 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = channel(obj,param)
    obj.Ydata = sig.compute(@main,obj.Ydata,param);
end
    
   
function out = main(d,param)
    d = d.extract('channel',param);
    out = {d};
end