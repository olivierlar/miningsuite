% SIG.AUTOCOR.MAIN
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(x,option)
    if iscell(x)
        x = x{1};
    end
    
    if isa(x,'sig.Autocor')
        out = {x};
        return
    end
    
    if isa(x,'sig.Envelope') && option.frame
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
    end
    
    if isempty(option.min)
        option.min.value = 0;
        option.min.unit = 's';
    end
    if isempty(option.max)
        if isa(x,'sig.Envelope')
            option.max.value = 2;
        elseif x.Srate > 1000
            option.max.value = 0.05;
        else
            option.max.value = Inf;
        end
        option.max.unit = 's';
    end
    
    if isa(x,'sig.Spectrum')
        ofspectrum = 1;
        
        x.Ydata = x.Ydata.reframe;
        x.Frate = x.Srate;
        x.Srate = 1./x.xsampling;
        if strcmpi(option.normwin,'')
            option.normwin = 0;
        end
    else
        ofspectrum = 0;
        if isa(x,'sig.Envelope') || x.Srate < 1000
            if strcmpi(option.normwin,'') || isequal(option.normwin,1) || ...
                    strcmpi(option.normwin,'On') || ...
                    strcmpi(option.normwin,'Yes')
                option.normwin = 'Rectangular';
            end
        else
            if strcmpi(option.normwin,'') || isequal(option.normwin,1) || ...
                    strcmpi(option.normwin,'On') || ...
                    strcmpi(option.normwin,'Yes')
                option.normwin = 'hanning';
            end
        end
    end
    if isnan(option.win) 
        if isequal(option.normwin,0) || ...
                   strcmpi(option.normwin,'Off') || ...
                   strcmpi(option.normwin,'No')
            option.win = 0;
        elseif isequal(option.normwin,1) || ...
                       strcmpi(option.normwin,'On') || ...
                       strcmpi(option.normwin,'Yes')
            option.win = 'hanning';
        else
            option.win = option.normwin;
        end
    end

    [d,w,xstart] = sig.compute(@routine,x.Ydata,x.Srate,option);
    y = sig.Autocor(d,'xsampling',1./x.Srate,'Deframe',x,'ofSpectrum',ofspectrum);
    y.window = w;
    y.normwin = option.normwin;
    y.Xaxis.start = xstart;
    
    out = {y};
end


function out = routine(in,sampling,option)
    %x(isnan(x)) = 0;
    l = in.size('sample');
    
    if isstruct(option.min)
        mint = floor(option.min.value*sampling)+1;
        if mint > l
            warning('WARNING IN SIG.AUTOCOR: The specified range of delays exceeds the temporal length of the signal.');
            disp('Minimum delay set to zero.')
            mint = 1;  % lowest index of the lag range
        end
    else
        mint = -Inf;
    end
    
    if isstruct(option.max)
        maxt = ceil(option.max.value*sampling)+1;
    else
        maxt = Inf;
    end
    maxt = min(maxt,ceil(l/2));
    if maxt <= mint
        if in.size('frame') > 1
            warning('WARNING IN SIG.AUTOCOR: Frame length is too small.');    
        else
            warning('WARNING IN SIG.AUTOCOR: The audio sequence is too small.');    
        end
        display('The autocorrelation is not defined for this range of delays.');
    end
    if isinf(mint)
        mint = 1;
    end
    
    x = in.center('sample');
    
    if ischar(option.win) 
        if strcmpi(option.win,'Rectangular')
            w = sig.data(ones(l,1),{'sample'});
        else
            winf = str2func(option.win);
            try
                w = window(winf,l);
            catch
                if strcmpi(option.win,'hamming')
                    disp('Signal Processing Toolbox does not seem to be installed. Recompute the hamming window manually.');
                    w = 0.54 - 0.46 * cos(2*pi*(0:l-1)'/(l-1));
                else
                    warning(['WARNING in SIG.AUTOCOR: Unknown windowing function ',option.win,' (maybe Signal Processing Toolbox is not installed).']);
                    disp('No windowing performed.')
                    w = ones(l,1);
                end
            end
            w = sig.data(w,{'sample'});
            x = x.times(w);
        end
    else
        w = [];
    end
    
    if option.gener == 2
        if strcmpi(option.scaleopt,'coeff')
            c = compute(x,mint,maxt,'none');
            if x.size('freqband') > 1
                x = x.sum('freqband');
            end
            c0 = compute(x,1,1,'none');
            c = c.divide(c0);
        else
            c = compute(x,mint,maxt,option.scaleopt);
        end
        if ~isempty(w)
            w = compute(w,mint,maxt,'coeff');
        end
    else
        c = compute_gen(x,mint,maxt,option.gener);
        w = [];
    end
    
    out = {c w mint};
end
    
    
function x = compute(x,mint,maxt,scaleopt)
    x = x.apply(@xcorr,{maxt-1,scaleopt},{'sample'},1);
    x = x.deframe;
    x = x.extract('element',[maxt+mint-1,2*maxt-1]);
end


function x = compute_gen(x,mint,maxt,gener)
    x = x.apply(@subroutine,{gener},{'sample'},Inf);
    x = x.deframe;
    x = x.extract('element',[mint,maxt]);
end


function y = subroutine(x,gener)
    s = abs(fft(x));
    s = s.^gener;
    y = ifft(s);
end