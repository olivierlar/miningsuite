% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function cl = closed(val)

persistent closed

if nargin
    closed = val;
else
    if isempty(closed)
        closed = 1;
    end
end

cl = closed;