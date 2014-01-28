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