function obj = combinechunks(obj,new)
    do = obj.Ydata;
    dn = new.Ydata;
    lo = do.size('element');
    ln = dn.size('element');
    if lo == ln
    elseif abs(lo-ln) <= 2  % Probleme of border fluctuation
        mi = min(lo,ln);
        do = do.extract('element',[1,mi]);
        dn = dn.extract('element',[1,mi]);
    elseif ln < lo
        dn = dn.edit('element',lo,0);   % Zero-padding
    elseif lo < ln
        do = do.edit('element',ln,0);   % Zero-padding
    end
    obj.Ydata = do.plus(dn);
end