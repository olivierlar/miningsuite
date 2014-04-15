% SIG.AUTOCOR
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = autocor(varargin)
    varargout = sig.operate('sig','autocor',initoptions,@init,@main,varargin);
end


function options = initoptions
    options = sig.signal.signaloptions(.05,.5);

        min.key = 'Min';
        min.type = 'Unit';
        min.unit = {'s','Hz'};
        %min.defaultunit = 's';
        min.default = [];
        min.opposite = 'max';
        min.when = 'Both';
    options.min = min;
        
        max.key = 'Max';
        max.type = 'Unit';
        max.unit = {'s','Hz'};
        %max.defaultunit = 's';
        max.default = [];
        max.opposite = 'min';
        max.when = 'Both';
    options.max = max;
        
        scaleopt.type = 'String';
        scaleopt.choice = {'biased','unbiased','coeff','none'};
        scaleopt.default = 'coeff';
    options.scaleopt = scaleopt;
            
        gener.key = {'Generalized','Compres'};
        gener.type = 'Numeric';
        gener.default = 2;
        gener.keydefault = .67;
    options.gener = gener;

        hwr.key = 'Halfwave';
        hwr.type = 'Boolean';
        hwr.when = 'After';
        hwr.default = 0;
    options.hwr = hwr;
        
        enhance.key = 'Enhanced';
        enhance.type = 'Numeric';
        enhance.default = [];
        enhance.keydefault = 2:10;
        enhance.when = 'After';
    options.enhance = enhance;
        
        freq.key = 'Freq';
        freq.type = 'Boolean';
        freq.default = 0;
        freq.when = 'Both';
    options.freq = freq;
        
        win.key = 'Window';
        win.type = 'String';
        win.default = 'hamming';
    options.win = win;

        normwin.key = 'NormalWindow';
        normwin.when = 'Both';
        %if isamir(orig,'mirspectrum')
        %    nw.default = 0;
        %elseif isamir(orig,'mirenvelope')
        %    nw.default = 'rectangular';
        %else
            normwin.default = 'hanning';
        %end
    options.normwin = normwin;
end


%%
function x = xfreq(obj)
    x = xtime(obj);
    ndims = length(obj.Xstart);
    if ndims == 0
        x = [];
    elseif ndims == 1
        l = obj.Ydata.size;
        x = 1./flipud(x);
    else
        x = cell(1,ndims);
        for i = 1:ndims
            l = obj.Ydata{i}.size;
            x{i} = 1./flipud(x);
        end
    end
end


%%
function [x type] = init(x,option)
    type = '?';
end


function out = main(x,option,postoption)
    if isempty(option.min)
        option.min.value = 0;
        option.min.unit = 's';
    end
    if isempty(option.max)
        option.max.value = 0.05;
        option.max.unit = 's';
    end
    
    if isa(x{1},'sig.Autocor')
        obj = x{1};
    else
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
                option.win = postoption.normwin;
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
        obj = sig.Autocor(d,'xsampling',1/x{1}.Srate,'Srate',x{1}.Frate);
        obj.window = w;
    end
    
    out = {obj.after(postoption)};
end


function out = routine(in,sampling,option)
    %x(isnan(x)) = 0;
    l = in.size('sample');
    
    omin = option.min;
    omax = option.max;
    if isstruct(omin) && strcmpi(omin.unit,'Hz')
        option.max.value = 1/omin.value;
        option.max.unit = 's';
        option.min = [];
    end
    if isstruct(omax) && strcmpi(omax.unit,'Hz')
        option.min.value = 1/omax.value;
        option.min.unit = 's';
        option.max = [];
    end
    
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
        if strcmpi(option.max.unit,'Hz')
            option.max.value = 1/option.max.value;
            option.max.unit = 's';
        end
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
        if ~isempty(w)
            w = compute_gen(w,mint,maxt,option.gener);
        end
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


function f = time2freq(t)
    f = 1./t;
end