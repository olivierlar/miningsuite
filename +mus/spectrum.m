% MUS.SPECTRUM
% music-theoretical representation of spectrum decomposition
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2012 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('mus','spectrum',initoptions,...
                            @sig.spectrum.init,@main,@after,varargin,'sum');
end


function options = initoptions
    options = aud.spectrum.options;
    
        cent.key = 'Cents';
        cent.type = 'Boolean';
        cent.default = 0;
    options.cent = cent;
    
        collapsed.key = 'Collapsed';
        collapsed.type = 'Boolean';
        collapsed.default = 0;
    options.collapsed = collapsed;
    
    options.reso.choice = {'ToiviainenSnyder','Fluctuation','Meter',0,'no','off'};
    options.reso.keydefault = 'ToiviainenSnyder';
end


function out = main(x,option)
    if option.min && isnan(option.res) && (option.cent || option.collapsed)
        option.res = option.min *(2^(1/1200)-1)*.9;
    end       
    out = sig.spectrum.main(x,option);
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end

    if ischar(option.reso) && strcmpi(option.reso,'ToiviainenSnyder')
        x.Ydata = sig.compute(@resonance,x.Ydata,x.xdata);
    end

    res = aud.spectrum.after(x,option);
    x = res{1};
    tmp = res{2};
    
    if strcmp(x.xname,'Frequency') && (option.cent || option.collapsed)
        f = x.xdata;
        isgood = f*(2^(1/1200)-1) >= f(2)-f(1);
        good = find(isgood);
        if isempty(good)
            error('ERROR in MUS.SPECTRUM: The frequency resolution of the spectrum is too low to be decomposed into cents.');
        end
        if good>1
            warning(['MIRSPECTRUM: Frequency resolution in cent is achieved for frequencies over ',...
                num2str(floor(f(good(1)))),' Hz. Lower frequencies are ignored.'])
            display('Hint: if you specify a minimum value for the frequency range (''Min'' option)');
            display('      and if you do not specify any frequency resolution (''Res'' option), ');
            display('      the correct frequency resolution will be automatically chosen.');
        end
        f = f(good);
        x.Ydata = x.Ydata.extract('element',[good(1),good(end)]);
        f2cents = 440*2.^(1/1200*(-1200*10:1200*10-1)');
            % The frequencies corresponding to the cent range
        cents = repmat((0:1199)',[20,1]);
            % The cent range is for the moment centered to A440
        octaves = ones(1200,1)*(-10:10);
        select = find(f2cents>f(1) & f2cents<f(end));
            % Cent range actually used in the current spectrum
        f2cents = f2cents(select);
        cents = cents(select);
        octaves = octaves(select);
        x.Ydata = x.Ydata.apply(@interp,{f,f2cents},{'element'});
        x.Xaxis.name = 'Pitch';
        x.Xaxis.unit.name = 'cents';
        x.Xaxis.start = 0;
        x.Xaxis.unit.origin = octaves(1)*1200 + cents(1) + 6900;
        x.Xaxis.unit.rate = 1;
        % Now the cent range is expressed in midicent
        x.yname = 'cent-Spectrum';
        x.phase = [];
    end
    
    if strcmp(x.Xaxis.unit.name,'Pitch') && option.collapsed
        f = x.xdata;
        centclass = rem(f,1200);
        x.Ydata = x.Ydata.apply(@collapse,{centclass},{'element'});
        x.Xaxis.unit.name = 'cents (collapsed)';
        x.Xaxis.unit.origin = 0;
        x.Xaxis.unit.rate = 1;
    end
        
    out = {x,tmp};
end


function d = resonance(d,f)
    w = max(0, 1 - 0.25*(log2(max(1./max(f,1e-12),1e-12)/0.5)).^2);
    if max(w) == 0
        warning('The resonance curve, not defined for this range of delays, will not be applied.')
    else
        w = sig.data(w',{'element'});
        d = d.times(w);
    end
end


function y = interp(x,f,f2cents)
    y = interp1(f,x,f2cents);
end


function y = collapse(x,cc)
    y = NaN(1200,size(x,2),size(x,3));
    for k = 0:1199
        y(k+1,:,:) = sum(x(find(cc==k),:,:),1);
    end
end