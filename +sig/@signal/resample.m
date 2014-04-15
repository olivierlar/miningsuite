function obj = resample(obj,newrate)
    res = sig.compute(@main,obj.Ydata,obj.Srate,newrate);
    obj.Ydata = res{1};
    obj.Srate = repmat(newrate,size(obj.Srate));
end
    
   
function out = main(data,oldrate,newrate)
    if ~(oldrate == newrate)
        data = data.apply(@resample,{newrate,oldrate},{'sample'},2);
    end    
    out = {data};
end