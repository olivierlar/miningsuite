% SIG.SIGNAL.DETREND
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = detrend(obj,thr)
    obj.Ydata = sig.compute(@main,obj.Ydata,obj.Srate,thr);
end
    
   
function out = main(data,sr,thr)
    data = data.apply(@algo,{sr,thr},{'sample'},1);
    out = {data};
end


function y = algo(x,sr,thr)
    fr = sr / length(x);
    N = thr / fr;
    f = fft(x);
    f(1) = 0;
    for i = 1:N
        f(1+i) = 0;
        f(end-i+1) = 0;
    end
    y = ifft(f);
end