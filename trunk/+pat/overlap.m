% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function ov = overlap(val)

persistent overlap

if nargin
    overlap = val;
else
    if isempty(overlap)
        overlap = 1;
    end
end

ov = overlap;