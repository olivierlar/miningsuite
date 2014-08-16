% AUD.SPECTRUM
% auditory modeling of spectrum decomposition
%
% Copyright (C) 2014, Olivier Lartillot
% Copyright (C) 1998, Malcolm Slaney, Interval Research Corporation
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('aud','spectrum',initoptions,...
                            @init,@main,varargin,'sum');
end


function options = initoptions
    options = sig.spectrum.options;
    options.phase.default = 0;
    
        band.type = 'String';
        band.choice = {'Freq','Mel','Bark','Cents'};
        band.default = 'Freq';
        band.when = 'Both';
    options.band = band;

        nbbands.key = 'Bands';
        nbbands.type = 'Numeric';
        nbbands.default = 0;
        nbbands.when = 'After';
    options.nbbands = nbbands;

        reso.key = 'Resonance';
        reso.type = 'String';
        reso.choice = {'ToiviainenSnyder','Fluctuation','Meter',0,'no','off'};
        reso.default = 0;
        reso.when = 'After';
    options.reso = reso;
    
        terhardt.key = 'Terhardt';
        terhardt.type = 'Boolean';
        terhardt.default = 0;
        terhardt.when = 'After';
    options.terhardt = terhardt;

        mask.key = 'Mask';
        mask.type = 'Boolean';
        mask.default = 0;
        mask.when = 'After';
    options.mask = mask;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.Spectrum';
end


function out = main(x,option,postoption)
    y = sig.spectrum.main(x,option,postoption);
    if isempty(postoption)
        out = {y};
    else
        out = after(y,postoption);
    end
end


function out = after(x,postoption)
    x = sig.spectrum.after(x,postoption);
    if iscell(x)
        x = x{1};
    end
    f = x.xdata;
    
    if postoption.terhardt && isa(x,'sig.Spectrum')
    % Code taken from Pampalk's MA Toolbox
        W_Adb = zeros(size(f));
        W_Adb(2:end) = + 10.^((-3.64*(f(2:end)/1000).^-0.8 ...
                       + 6.5 * exp(-0.6 * (f(2:end)/1000 - 3.3).^2) ...
                       - 0.001*(f(2:end)/1000).^4)/20);
        W_Adb = W_Adb.^2;
        W_Adb = sig.data(W_Adb',{'element'});
        x.Ydata = x.Ydata.times(W_Adb);
    end
    
    if postoption.reso
        if strcmpi(postoption.reso,'ToiviainenSnyder') ...
                || strcmpi(postoption.reso,'Meter')
            w = max(0,...
                1 - 0.25*(log2(max(1./max(f,1e-12),1e-12)/0.5)).^2);
        elseif strcmpi(postoption.reso,'Fluctuation')
            w1 = f / 4; % ascending part of the fluctuation curve;
            w2 = 1 - 0.3 * (f - 4)/6; % descending part;
            w = min(w1,w2);
        end
        if max(w) == 0
            warning('The resonance curve, not defined for this range of delays, will not be applied.')
        else
            w = sig.data(w',{'element'});
            x.Ydata = x.Ydata.times(w);
        end
    end
    
    if strcmp(x.xname,'Frequency')
        if strcmpi(postoption.band,'Mel') 
            % Computing Mel-frequency spectral representation
            %%
            % The following is largely based on the source code from Auditory Toolbox 
            lowestFrequency = 133.3333;
            if not(postoption.nbbands)
                postoption.nbbands = 40;
            end
            linearFilters = min(13,postoption.nbbands);
            linearSpacing = 66.66666666;
            logFilters = postoption.nbbands - linearFilters;
            logSpacing = 1.0711703;
            totalFilters = postoption.nbbands;

            % Figure the band edges.  Interesting frequencies are spaced
            % by linearSpacing for a while, then go logarithmic.  First figure
            % all the interesting frequencies.  Lower, center, and upper band
            % edges are all consequtive interesting frequencies. 
            freqs = lowestFrequency + (0:linearFilters-1)*linearSpacing;
            freqs(linearFilters+1:totalFilters+2) = ...
                          freqs(linearFilters) * logSpacing.^(1:logFilters+2);
            lower = freqs(1:totalFilters);
            center = freqs(2:totalFilters+1);
            upper = freqs(3:totalFilters+2);

            % Figure out the height of the triangle so that each filter has 
            % unit weight, assuming a triangular weighting function.
            triangleHeight = 2./(upper-lower);

            % We now want to combine FFT bins and figure out 
            % each frequencies contribution
            weights = zeros(totalFilters,length(f));
            for chan=1:totalFilters
                 weights(chan,:) = triangleHeight(chan).*...
                    ((f > lower(chan) & f <= center(chan)).* ...
                     (f-lower(chan))/(center(chan)-lower(chan)) + ...
                     (f > center(chan) & f < upper(chan)).* ...
                     (upper(chan)-f)/(upper(chan)-center(chan)));
            end
            
            %%
            if find(diff(not(sum(weights,2)))==-1)
                % If one channel has no weight whereas the higher one
                % has a positive weight.
                warning('WARNING in AUD.SPECTRUM: The frequency resolution of the spectrum is too low for the Mel transformation. Some Mel components are undefined.')
                display('Recommended frequency resolution: at least 66 Hz.')
            end
            
            x.Ydata = x.Ydata.apply(@matprod,{weights},{'element'},2);
            
            x.xname = 'Mel bands';
            x.Xaxis.unit.origin = 1;
            x.Xaxis.unit.rate = 1;
            x.yname = 'Mel-Spectrum';
            %x.Ydata = x.Ydata.rename('element','channels');
            x.phase = [];
        elseif strcmpi(postoption.band,'Bark')   
            %% Code inspired by Pampalk's MA Toolbox.
            % zwicker & fastl: psychoacoustics 1999, page 159
            bark_upper = [10 20 30 40 51 63 77 92 108 127 148 172 200 232 270 315 370 440 530 640 770 950 1200 1550]*10; %% Hz
            
            % ignore critical bands outside of sampling rate range
            totalFilters = find(bark_upper>f(end),1);
            if isempty(totalFilters)
                totalFilters = length(bark_upper);
            end
            weights = zeros(totalFilters,length(f));
            k = 1;
            for chan=1:totalFilters
                idx = find(f(k:end)<=bark_upper(chan));
                idx = idx + k-1;
                weights(chan,idx) = 1;
                k = max(idx)+1;
            end
            
            x.Ydata = x.Ydata.apply(@matprod,{weights},{'element'},2);
            
            x.xname = 'Bark bands';
            x.Xaxis.unit.origin = 1;
            x.Xaxis.unit.rate = 1;
            x.yname = 'Bark-Spectrum';
            %x.Ydata = x.Ydata.rename('element','channels');
            x.phase = [];
        end
    end
    
    if postoption.mask
        if strcmp(x.xname,'Frequency')
            warning('WARNING IN AUD.SPECTRUM: ''Mask'' option available only for Mel-spectrum and Bark-spectrum.');
            disp('''Mask'' option ignored');
        else
            %% Code inspired by Pampalk's MA Toolbox.
            % spreading function: schroeder et al., 1979, JASA, optimizing
            % digital speech coders by exploiting masking properties of the human ear
            cb = x.Ydata.size('element');  % Number of bands.
            spread = zeros(cb);
            for i = 1:cb, 
                spread(i,:) = 10.^((15.81+7.5*((i-(1:cb))+0.474) ...
                                    -17.5*(1+((i-(1:cb))+0.474).^2) ...
                                    .^0.5)/10);
            end
            x.Ydata = x.Ydata.apply(@matprod,{spread},{'element'},2);
        end
    end
    
    out = {x};
end

    
function y = matprod(x,weights)
    y = weights * x + 1e-16;
end