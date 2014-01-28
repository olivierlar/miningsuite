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