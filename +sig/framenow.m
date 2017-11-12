function x = framenow(x,frame)

if isstruct(frame) && frame.toggle && frame.size.value
    frate = sig.compute(@sig.getfrate,x{1}.Srate,frame);
    x{1}.Ydata = x{1}.Ydata.frame(frame,x{1}.Srate);
    x{1}.Frate = frate;
end