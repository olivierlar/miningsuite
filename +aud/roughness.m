% AUD.ROUGHNESS 
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% ? 2009-2013 Olivier Lartillot & University of Jyvaskyla
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = roughness(varargin)
    varargout = sig.operate('aud','roughness',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    options.frame.default = 1;
    
        meth.type = 'String';
        meth.choice = {'Sethares','Vassilakis'};
        meth.default = 'Sethares';
    options.meth = meth;
    
        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = .01;
    options.cthr = cthr;

        omin.key = 'Min';
        omin.type = 'Boolean';
        omin.default = 0;
    options.min = omin;

        normal.key = 'Normal';
        normal.type = 'Boolean';
        normal.default = 0;
    options.normal = normal;
end


%%
function [x type] = init(x,option,frame)
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
        x = sig.spectrum(x);   
    end
    x = sig.peaks(x,'Contrast',option.cthr);
    type = {'sig.Signal','sig.Spectrum'};
end


function out = main(in,option)
    x = in{1};
    d = sig.compute(@routine,x.peakpos,x.peakval,x.Ydata,option);
    x = sig.Signal(d,'Name','Roughness','Srate',x.Srate,'Ssize',x.Ssize,...
                   'FbChannels',x.fbchannels);
    out = {x};
end


function out = routine(pf,pv,d,option)
    e = pf.apply(@algo,{pv,d,option},{'element'},1);
    out = {e};
end


function rg = algo(pf,pv,d,option)
    pf = pf{1};
    pv = pv{1};
    f1 = repmat(pf,[1 length(pf)]);
    f2 = repmat(pf',[length(pf) 1]);
    v1 = repmat(pv,[1 length(pv)]);
    v2 = repmat(pv',[length(pv) 1]);
    rj = plomp(f1,f2);
    if option.min
        v12 = min(v1,v2);
    else
        v12 = v1.*v2;
    end
    if strcmpi(option.meth,'Sethares')
        rj = v12.*rj;
    elseif strcmpi(option.meth,'Vassilakis')
        rj = (v1.*v2).^.1.*.5.*(2*v2./(v1+v2)).^3.11.*rj;
    end
    rg = sum(sum(rj));
    if option.normal
        % 'Normal' option
        rg = rg / sum(d.^2);
    end
end


function pd = plomp(f1, f2)
    % returns the dissonance of two pure tones at frequencies f1 & f2 Hz
    % according to the Plomp-Levelt curve (see Sethares)
    b1 = 3.51;
    b2 = 5.75;
    xstar = .24;
    s1 = .0207;
    s2 = 18.96;
    s = tril(xstar ./ (s1 * min(f1,f2) + s2 ));
    pd = exp(-b1*s.*abs(f2-f1)) - exp(-b2*s.*abs(f2-f1));
end


function x = after(x,option)
end