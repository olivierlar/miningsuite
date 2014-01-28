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