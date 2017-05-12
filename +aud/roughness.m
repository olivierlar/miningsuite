function varargout = roughness(varargin)
    varargout = sig.operate('aud','roughness',...
                            initoptions,@init,@main,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions(.05,.5);
    
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
    if ~istype(x,'sig.Spectrum')
        if ~frame.toggle
            x = sig.frame(x,'FrameSize',frame.size.value,frame.size.unit,...
                            'FrameHop',frame.hop.value,frame.hop.unit);
        end
        x = sig.spectrum(x);
    end
    x = sig.peaks(x,'Contrast',option.cthr);
    type = {'sig.signal','sig.Spectrum'};
end


function out = main(in,option,postoption)
    x = in{1};
    d = sig.compute(@routine,x.peakpos,x.peakval,x.Ydata,option);
    x = sig.signal(d,'Name','Roughness','Srate',x.Srate,'Ssize',x.Ssize,...
                   'FbChannels',x.fbchannels);
    out = {x};
end


function out = routine(pf,pv,d,option)
    e = pf.apply(@algo,{pv,d,option},{'element'},1);
    out = {e};
end


function rg = algo(pf,pv,d,option)
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