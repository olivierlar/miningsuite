% MUS.AUTOCOR
% music-theoretical representation of autocorrelation function
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% ? 2007-2012 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = autocor(varargin)
    varargout = sig.operate('mus','autocor',initoptions,...
                            @sig.autocor.init,@sig.autocor.main,@after,...
                            varargin,@sig.autocor.combinechunks);
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


function out = after(x,option)
    x = sig.autocor.after(x,option);
    x = x{1};    
    if ischar(option.reso) && ...
            ~strcmpi(option.reso,'no') && ~strcmpi(option.reso,'off') && ...
            ...(~isa(x,'mus.Autocor') || 
            isempty(x.resonance)%)
        x.Ydata = sig.compute(@resonance,x.Ydata,x.xdata,x.Xaxis.name,option.reso);
        %if isa(x,'mus.Autocor')
            x.resonance = option.reso;
%         else
%             x = mus.Autocor(x,'Resonance',option.reso);
%         end
    end
    out = {x};
end


function d = resonance(d,f,xname,type)
    if strcmp(xname,'Frequency')
        f = 1./f;
    end
    if strcmpi(type,'ToiviainenSnyder')
        w = max(0, 1 - 0.25*(log2(max(f,1e-12)/0.5)).^2);
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