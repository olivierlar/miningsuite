function d = recent(d)

persistent recent

if nargin
    recent = d;
end

d = recent;