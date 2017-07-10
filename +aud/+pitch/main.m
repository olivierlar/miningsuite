function [out,postoption,tmp] = main(x,option,postoption)
    x = x{1};
    d = sig.compute(@routine,x.peakpos);
    out = sig.signal(d,'Name','Pitch','Srate',x.Srate,'Ssize',x.Ssize,'FbChannels',x.fbchannels);
  
end


function out = routine(d)
    e = d.apply(@convert,{},{'element'},1,'{}');
    out = e;
end


function y = convert(x)
    y = 1./x{1};
end