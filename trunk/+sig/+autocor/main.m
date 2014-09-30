function out = main(x,option,postoption)
    if isa(x{1},'sig.Autocor')
        out = x;
        return
    end
    if isstruct(option.min) && strcmpi(option.min.unit,'Hz')
        if isstruct(option.max)
            if ~strcmpi(option.max.unit,'Hz')
                error('Syntax error...');
            end
            omax = 1/option.min;
            option.min.value = 1/option.max.value;
            option.max = omax;
            option.min.unit = 's';
            option.max.unit = 's';
        else
            option.max.value = 1/option.min.value;
            option.max.unit = 's';
            option.min.value = 0;
            option.min.unit = 's';
        end
    elseif isstruct(option.max) && strcmpi(option.max.unit,'Hz')
        option.min.value = 1/option.max.value;
        option.min.unit = 's';
        option.max.value = 0.05;
        option.max.unit = 's';
    else
        if isempty(option.min)
            option.min.value = 0;
            option.min.unit = 's';
        end
        if isempty(option.max)
            if isa(x{1},'sig.Envelope')
                option.max.value = 2;
            else
                option.max.value = 0.05;
            end
            option.max.unit = 's';
        end
    end
    
    if isa(x{1},'sig.Spectrum')
        x{1}.Ydata = x{1}.Ydata.reframe;
        x{1}.Frate = x{1}.Srate;
        x{1}.Srate = x{1}.xsampling;
        option.normwin = 0;
        %option.win = 0;
        %postoption.normwin = 0;
        warning('Work in progress')
    elseif isa(x{1},'sig.Envelope')
        option.normwin = 'Rectangular';
        %option.win = 0;
        %postoption.normwin = 0;
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

    res = sig.compute(@routine,x{1}.Ydata,x{1}.Srate,option);
    d = res{1};
    w = res{2};
    xstart = res{3};

    if option.freq
        xname = 'Frequency';
    else
        xname = 'Time';
    end
    out = sig.Autocor(d,'xsampling',1/x{1}.Srate,'Srate',x{1}.Frate);
    out.window = w;
    out.Xaxis.start = xstart;
end


function out = routine(in,sampling,option)
    %x(isnan(x)) = 0;
    l = in.size('sample');
    
    if isstruct(option.min)
        mint = floor(option.min.value*sampling)+1;
        if mint > l
            warning('WARNING IN MIRAUTOCOR: The specified range of delays exceeds the temporal length of the signal.');
            disp('Minimum delay set to zero.')
            mint = 1;  % lowest index of the lag range
        end
    else
        mint = -Inf;
    end
    
    if isstruct(option.max)
        %if strcmpi(option.max.unit,'Hz')
        %    option.max.value = 1/option.max.value;
        %    option.max.unit = 's';
        %end
        maxt = ceil(option.max.value*sampling)+1;
    else
        maxt = Inf;
    end
    maxt = min(maxt,ceil(l/2));
    if maxt <= mint
        if in.size('frame') > 1
            warning('WARNING IN MIRAUTOCOR: Frame length is too small.');    
        else
            warning('WARNING IN MIRAUTOCOR: The audio sequence is too small.');    
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
                    warning(['WARNING in MIRAUTOCOR: Unknown windowing function ',option.win,' (maybe Signal Processing Toolbox is not installed).']);
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
            c0 = compute(x,1,1,'none');
            c = c.divide(c0);
        else
            c = compute(x,mint,maxt,option.scaleopt);
        end
        if ~isempty(w)
            w = compute(w,mint,maxt,option.scaleopt);
        end
    else
        c = compute_gen(x,mint,maxt,option.gener);
        w = [];
        %if ~isempty(w)
        %    w = compute_gen(w,mint,maxt,option.gener);
        %end
    end
    
    out = {c w mint};
end
    
    
function x = compute(x,mint,maxt,scaleopt)
    x = x.apply(@xcorr,{maxt-1,scaleopt},{'sample'},1);
    x = x.deframe;
    x = x.extract('element',[maxt+mint-1,2*maxt-1]);
    %y = xcorr(x,maxt-1,scaleopt);
    %y = flipud(y(maxt+mint-1:end));
end


function x = compute_gen(x,mint,maxt,gener)
    x = x.apply(@subroutine,{gener},{'sample'},Inf);
    x = x.deframe;
    x = x.extract('element',[mint,maxt]);
    %x = x.apply(@flipud,{},{'frame'},Inf);
end


function y = subroutine(x,gener)
    s = abs(fft(x));
    s = s.^gener;
    y = ifft(s);
end