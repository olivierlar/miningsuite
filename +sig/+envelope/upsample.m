function e = upsample(e,postoption)
    if postoption.up
        [z,p,gain] = butter(6,10/e.Srate/postoption.up*2,'low');
        [sos,g] = zp2sos(z,p,gain);
        Hd = dfilt.df2tsos(sos,g);
        e.Ydata = sig.compute(@main,e.Ydata,Hd,postoption.up);
        e.Srate = e.Srate*postoption.up;
    end
end


function d = main(d,Hd,N)
    d = d.apply(@routine,{Hd,N},{'sample','','channel'},3);
end


function y = routine(x,Hd,N)
    y = zeros(size(x,1).*N,size(x,2),size(x,3));
    y(1:N:end,:,:) = x;
    y = filter(Hd,[y;zeros(6,size(x,2),size(x,3))]);
    y = y(1+ceil(6/2):end-floor(6/2),:,:);
%     y = zeros(size(x,1).*N,1);
%     y(1:N:end,:,:) = x;
%     y = filter(Hd,[y;zeros(6,1)]);
%     y = y(1+ceil(6/2):end-floor(6/2),1);
end