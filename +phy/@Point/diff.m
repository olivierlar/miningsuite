% PHY.POINT.DIFF
%
% Copyright (C) 2018 Olivier Lartillot
% Copyright (C) 2008 University of Jyvaskyla (MoCap Toolbox)
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = diff(obj,n,butter_order,butter_cutoff,norm)
    if nargin < 5
        norm = 1;
        if nargin < 4
            if nargin < 3
                butter_order = 2;
            end
            butter_cutoff = .2;
        end
    end
    obj.Ydata = sig.compute(@main,obj.Ydata,n,obj.Srate,...
                            butter_order,butter_cutoff,norm);
end


function out = main(d,n,srate,butter_order,cutoff,norm)
    d = d.apply(@differentiate_fast,{n, butter_order, cutoff, srate,norm},...
                                    {'sample'},1);
    out = {d};
end


function d = differentiate_fast(d,n,butter_order,cutoff,srate,norm)
% Part of the MoCap Toolbox, Copyright 2008, 
% University of Jyvaskyla, Finland
    if butter_order
        [b,a]=butter(butter_order, cutoff); % optimal filtering frequency is 0.2 Nyquist frequency
    end
    
    d_mc=mcinitstruct('MoCap data', d, 100);
    [mf mm mgrid]=mcmissing(d_mc);
    if sum(mf)>0 %missing frames need to be filled for the filtering!
        d_mc=mcfillgaps(d_mc,'fillall');%BB FIX 20111212, also beginning and end need filling
        d=d_mc.data;
    end
    
    for k=1:n %differences and filtering
        d=diff(d);
        if butter_order
            d=filtfilt(b,a,d);
        end
        d = [repmat(d(1,:),1,1); d];
    end
    
    if sum(mf)>0 %missing frames set back to NaN
        tmp=1:d_mc.nMarkers;
        tmp=[tmp;tmp;tmp];
        tmp=reshape(tmp,1,[]);
        mgrid=[mgrid(:,tmp)];
        d(mgrid==1)=NaN;
    end
    
    if norm
        d = d .* srate^n;
    end
end