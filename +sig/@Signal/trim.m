% SIG.SIGNAL.TRIM
%
% Copyright (C) 2014, 2019 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = trim(obj,where,threshold)
    [obj.Ydata start] = sig.compute(@main,obj.Ydata,obj.sdata,where,threshold);
    obj.Sstart = obj.Sstart + (start-1) / obj.Srate;
end
    
   
function out = main(d,t,where,threshold)
    if not(threshold)
        threshold = 0.06;
    end
    
    trimframe = 100;
    trimhop = 10;
    nframes = floor((length(t)-trimframe)/trimhop)+1;
    rms = zeros(1,nframes);
    sd = d.sum('channel');
    
    % replace by sig.rms
    for j = 1:nframes
        st = floor((j-1)*trimhop)+1;
        d0 = sd.content(st:st+trimframe-1);
        rms(j) = norm(d0)/sqrt(trimframe);
    end
    
    rms = (rms-min(rms))./(max(rms)-min(rms));
    nosil = find(rms>threshold);

    if strcmpi(where,'JustStart') || strcmpi(where,'BothEnds')
        nosil1 = min(nosil);
        if nosil1 > 1
            nosil1 = nosil1-1;
        end
        n1 = floor((nosil1-1)*trimhop)+1;
    else
        n1 = 1;
    end
    if strcmpi(where,'JustEnd') || strcmpi(where,'BothEnds')
        nosil2 = max(nosil);
        if nosil2 < length(rms)
            nosil2 = nosil2+1;
        end
        n2 = floor((nosil2-1)*trimhop)+1;
    else
        n2 = length(t);
    end
    
    d = d.extract('sample',[n1,n2]);    
    out = {d n1};
end
