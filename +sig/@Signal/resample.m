% SIG.SIGNAL.RESAMPLE
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

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
