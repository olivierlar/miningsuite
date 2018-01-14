% SIG.SIGNAL.RESAMPLE
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = resample(obj,newrate)
    obj.Ydata = sig.compute(@main,obj.Ydata,obj.Srate,newrate);
    obj.Srate = repmat(newrate,size(obj.Srate));
end
    
   
function out = main(data,oldrate,newrate)
    if ~(oldrate == newrate)
        data = data.apply(@resample,{newrate,oldrate},{'sample'},2);
    end
    out = {data};
end
