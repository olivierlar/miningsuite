% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function cc = cyclic(val)

persistent cyclic

if nargin
    cyclic = val;
else
    if isempty(cyclic)
        cyclic = 1;
    end
end

cc = cyclic;