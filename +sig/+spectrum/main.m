% SIG.SPECTRUM.MAIN
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(x,option)
    if iscell(x)
        x = x{1};
    end

    if isa(x,'sig.Spectrum') && (isempty(option) || ~option.alongbands)
        out = {x};
        return
    end
    
    if option.phase && (~isempty(option.msum) || ~isempty(option.mprod) ...
            || option.log || option.db || option.pow ...
            || option.aver || option.gauss)
        option.phase = 0;
    end
    [d,ph,constq] = sig.compute(@routine,x.Ydata,x.Srate,option);
    if iscell(constq)
        constq = constq{1};
    end

    dsize = d.size('element');
    if option.constq
        if iscell(dsize)
            xrate = zeros(1,length(dsize));
            for i = 1:length(xrate)
                xrate(i) = 1;
            end
        else
            xrate = 1;
        end 
    else
        if iscell(dsize)
            xrate = zeros(1,length(dsize));
            for i = 1:length(xrate)
                xrate(i) = x.Srate/2/dsize{i};
            end
        else
            xrate = x.Srate/2/dsize;
        end
    end
    
    xsize = x.Ssize;
    if iscell(xsize)
        il = zeros(size(xsize));
        for i = 1:length(xsize)
            il(i) = xsize{i}./x.Srate;
        end
    else
        il = xsize./x.Srate;
    end
    
    out = {sig.Spectrum(d,'Phase',ph,'xsampling',xrate,'Deframe',x,...
                        'InputSampling',x.Srate,'InputLength',il,...
                        'ConstantQ',constq)};
end


function out = routine(in,sampling,option)
    dim = 'sample';
    N = in.size(dim);

    if option.constq
        % Constant Q Transform
        r = 2^(1/option.constq);
        Q = 1 / (r - 1);
        f_max = min(sampling/2,option.max);
        f_min = option.min;
        if not(f_min)
            f_min = 16.3516;
        end
        B = floor(log(f_max/f_min) / log(r)); % number of bins
        N0 = round(Q*sampling/f_min); % maximum Nkcq
        j2piQn = -1i*2*pi*Q*(0:N0-1)';

        fj = f_min * r.^(0:B-1)';
        %transf = NaN(B,size(dj,2),size(dj,3));
        
        out = in.zeros({'sample','element',B},{'frame','sample'});
        for kcq = 1:B
            Nkcq = round(Q*sampling/fj(kcq));
            w = window(option.win,Nkcq);
            w = sig.data(w,{'sample'});
            if in.size('sample') > Nkcq
                ink = in.extract('sample',[1,Nkcq]);
            elseif in.size('sample') < Nkcq
                ink = in.edit('sample',Nkcq,0);
            else
                ink = in;
            end
            ink = ink.times(w);
            exq = exp(j2piQn(1:Nkcq)/Nkcq);
            exq = sig.data(exq,{'sample'});
            ink = ink.times(exq).sum('sample').divide(Nkcq);
            ink = ink.apply(@abs,{},{'sample'});
            out = out.edit('element',kcq,ink);
        end
        phase = [];
        param = [f_min, r];
    else
        if ischar(option.win) 
            if strcmpi(option.win,'Rectangular')
                w = sig.data(ones(N,1),{dim});
            else
                winf = str2func(option.win);
                try
                    w = window(winf,N);
                catch
                    if strcmpi(option.win,'hamming')
                        disp('Signal Processing Toolbox does not seem to be installed. Recompute the hamming window manually.');
                        w = 0.54 - 0.46 * cos(2*pi*(0:N-1)'/(N-1));
                    else
                        warning(['WARNING in MIRAUTOCOR: Unknown windowing function ',option.win,' (maybe Signal Processing Toolbox is not installed).']);
                        disp('No windowing performed.')
                        w = ones(N,1);
                    end
                end
                w = sig.data(w,{dim});
            end
            in = in.times(w);
        end
        
        if isfield(option,'missing') && option.missing && ~in.size('frame')
            option.zp = option.zp + option.missing;
        end
        
        if option.zp
            if isinf(option.zp)
                option.zp = N;
            end
            N = N+option.zp;
            %in = in.edit(dim,N,0);
        end
        
        if option.octave
            res = (2.^(1/option.mr)-1)*option.octave;
                % Minimal freq ratio between 2 first bins.
                % freq resolution should be > option.min * res
            Nrec = sampling/(option.min*res);
                % Recommended minimal sample length.
            if Nrec > N
                    % If actual sample length is too small.
                option.min = sampling/N / res;
                warning('WARNING IN SIG.SPECTRUM: The input signal is too short to obtain the desired octave resolution. Lowest frequencies will be ignored.');
                display(['(The recommended minimal input signal length would be ' num2str(Nrec/sampling) ' s.)']);
                display(['New low frequency range: ' num2str(option.min) ' Hz.']);
            end
            N = 2^nextpow2(N);
        elseif isnan(option.length)
            if isnan(option.res)
                if option.mr && N < sampling/option.mr
                    if option.wr && N < sampling/option.wr
                        warning('WARNING IN SIG.SPECTRUM: The input signal is too short to obtain the desired frequency resolution. Performed zero-padding will not guarantee the quality of the results.'); 
                    end                
                    N = max(N,sampling/option.mr);
                end
                N = 2^nextpow2(N);
            else
                N = ceil(sampling/option.res);
            end
        else
            N = option.length;
        end

        % FFT computation
        out = in.apply(@fft,{N},{dim});
        out = out.extract(dim,[1,N/2]);
        if ~option.alongbands
            out = out.deframe;
            if option.phase
                phase = out.apply(@angle,{},{'element'});
            else
                phase = [];
            end
            out = out.apply(@abs,{},{'element'});
        else
            out = out.rename('element','freqband');
            out = out.rename('sample','element');
            phase = [];
            out = out.apply(@abs,{},{'element'});
        end
        param = [];
    end
    out = {out phase param};
end