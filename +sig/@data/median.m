% SIG.DATA.MEDIAN
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = median(obj,field,order,offset)
    obj = obj.apply(@routine,{order,offset},{field},1);
end


function y = routine(x,order,offset)
    y = x;
    sz = length(x);
    for i = 1:sz
        y(i) = x(i) - offset * median(x(max(1,i-order):min(sz,i+order)));
    end
end