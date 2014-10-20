% MUS.AUTOCOR
% music-theoretical representation of autocorrelation function
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = autocor(varargin)
    varargout = sig.operate('mus','autocor',initoptions,...
                            @init,@main,varargin,...
                            @sig.autocor.combinechunks,'extensive');
end


function options = initoptions
    options = sig.autocor.options;
    
        reso.key = 'Resonance';
        reso.type = 'String';
        reso.choice = {'ToiviainenSnyder','vanNoorden',0,'no','off'};
        reso.default = 0;
        reso.keydefault = 'ToiviainenSnyder';
        reso.when = 'After';
    options.reso = reso;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.Autocor';
end


function out = main(x,option,postoption)
    y = sig.autocor.main(x,option,postoption);
    if isempty(postoption)
        out = {y};
    else
        out = after(y,postoption);
    end
end


function out = after(x,postoption)
    x = sig.autocor.after(x,postoption);
    if iscell(x)
        x = x{1};
    end
    
    if postoption.reso
        x.Ydata = sig.compute(@resonance,x.Ydata,x.xdata,postoption.reso);
    end
        
    out = {x};
end


function d = resonance(d,f,type)
    if strcmpi(type,'ToiviainenSnyder')
        w = max(0, 1 - 0.25*(log2(max(1./max(f,1e-12),1e-12)/0.5)).^2);
    elseif strcmpi(type,'vanNoorden')
        f0=2.193; b=0.5; 
        f=1./f; a1=(f0*f0-f.*f).^2+b*f.^2; a2=f0^4+f.^4;
        w=(1./sqrt(a1))-(1./sqrt(a2));
    end
    if max(w) == 0
        warning('The resonance curve, not defined for this range of delays, will not be applied.')
    else
        w = sig.data(w',{'element'});
        d = d.times(w);
    end
end