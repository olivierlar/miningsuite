function out = main(x,option,postoption)
    x = x{1};
    d = x.peakpos;
    out = {sig.signal(d,'Name','Pitch','Srate',x.Srate,'Ssize',x.Ssize,'FbChannels',x.fbchannels)};
end