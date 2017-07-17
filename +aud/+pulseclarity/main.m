function out = main(in,option)
    x = in{2};
    if option.model == 2
        option.stratg = 'InterfAutocor';
    end
    if option.m == 1 && ...
            (strcmpi(option.stratg,'InterfAutocor') || ...
             strcmpi(option.stratg,'MeanPeaksAutocor'))
        option.m = Inf;
    end
    if strcmpi(option.stratg,'MaxAutocor')
        d = sig.compute(@max,x.Ydata);
        pc = sig.signal(d,'Name','Pulse Clarity','Srate',in{1}.Srate,'FbChannels',in{1}.fbchannels);
        out = {pc x};
    end
end