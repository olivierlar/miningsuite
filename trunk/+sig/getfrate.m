function frate = getfrate(sr,param)
if strcmpi(param.hop.unit,'/1') || strcmpi(param.hop.unit,'%')
    if strcmpi(param.size.unit,'s')
        l = param.size.value*sr;
    elseif strcmpi(param.size.unit,'sp')
        l = param.size.value;
    end
    if strcmpi(param.hop.unit,'/1')
        frate = sr/param.hop.value/l;
    else
        frate = sr/param.hop.value/l/.01;
    end
elseif strcmpi(param.hop.unit,'s')
    frate = 1/param.hop.value;
elseif strcmpi(param.hop.unit,'sp')
    frate = sr/param.hop.value;
elseif strcmpi(param.hop.unit,'Hz')
    frate = param.hop.value;
end