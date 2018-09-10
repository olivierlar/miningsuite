% SIG.SIGNAL.CHANNEL
%
% Copyright (C) 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = channel(obj,param,keyword)
    if nargin < 3
        keyword = 'channel';
    end
    obj.Ydata = sig.compute(@main,obj.Ydata,param,keyword);
end
    
   
function out = main(d,param,keyword)
    d = d.extract(keyword,param);
    out = {d};
end