% SIG.SIGNAL.FWR
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = fwr(obj)
    [obj.Ydata] = sig.compute(@main,obj.Ydata);
end
    
   
function out = main(d)
    out = d.apply(@abs,{},{'sample'});
end