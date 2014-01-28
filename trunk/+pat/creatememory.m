function obj = creatememory(param,pattern)
    if isa(param,'seq.paramstruct') || isa(param,'pat.memostruct')
        obj = pat.memostruct(param,pattern);
    else
        obj = pat.memoparam(param,pattern);
    end
end