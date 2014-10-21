function [out,postoption,tmp] = main(x,option,postoption)
    x = x{1};

    if strcmpi(option.method,'Spectro')
        d = x.Ydata.rename('element','channel');
        tmp = [];
        postoption.trim = 0;
        postoption.ds = 0;
        
    elseif strcmpi(option.method,'Filter')
        if isnan(option.zp)
            if strcmpi(option.filter,'IIR')
                option.zp = 1;
            else
                option.zp = 0;
            end
        end
        if option.zp == 1
            option.decim = 0;
        end

        [d tmp] = sig.compute(@routine_filter,x.Ydata,x.Srate,option);
        
        if isfield(postoption,'ds') && isnan(postoption.ds)
            if option.decim
                postoption.ds = 0;
            else
                postoption.ds = 16;
            end
        end
    end
    out = sig.Envelope(d,'Srate',x.Srate,...
                       'Sstart',x.Sstart,'Ssize',x.Ssize,...
                       'Method',option.method,'Frate',x.Frate);    
end


function out = routine_filter(in,sampling,option)
    if isfield(option,'tmp')
        tmp = option.tmp;
    else
        tmp = [];
    end
    
    if option.decim
        sampling = sampling/option.decim;
    end

    if strcmpi(option.filter,'IIR')
        a2 = exp(-1/(option.tau*sampling)); % filter coefficient 
        a = [1 -a2];
        b = 1-a2;
    elseif strcmpi(option.filter,'HalfHann')
        a = 1;
        b = hann(sampling*.4);
        b = b(ceil(length(b)/2):end);
    elseif strcmpi(option.filter,'Butter')
        % From Timbre Toolbox
        w = 5 / ( sampling/2 );
        [b,a] = butter(3, w);
    end
    
    if option.zp == 2
        in = in.flip('sample');
    end
    
    if option.hilb
        try
            in = in.apply(@hilbert,{},{'sample'});
        catch
            disp('Signal Processing Toolbox does not seem to be installed. No Hilbert transform.');
        end    
    end
    
    in = in.apply(@abs,{},{'sample'});
    
    if option.decim
        in = in.apply(@decimate,{option.decim},{'sample'});
    end
    
    notmp = isempty(tmp);
    if notmp
        [out tmp] = in.apply(@filter,{b,a,'self'},{'sample'});
    else
        [out tmp] = in.apply(@filter,{b,a,'self',tmp},{'sample'});
    end
    
    out = out.apply(@max,{0},{'sample'}); % For security reason...
    
    if option.zp == 2
        out = out.flip('sample');
    end
    
    out = {out tmp};
end