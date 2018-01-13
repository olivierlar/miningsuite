function obj = resample(obj,newrate)
    [obj.Ydata,obj.Sstart] = sig.compute(@main,obj.Ydata,obj.Srate,newrate,obj.Sstart);
    obj.Srate = repmat(newrate,size(obj.Srate));
end
    
   
function out = main(data,oldrate,newrate,Sstart)
    if ~(oldrate == newrate)
        data = data.apply(@resample,{newrate,oldrate},{'sample'},2);
    end
    Sstart = Sstart * newrate / oldrate;
    out = {data,Sstart};
end
