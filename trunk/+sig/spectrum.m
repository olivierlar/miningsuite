% SIG.SPECTRUM
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('sig','spectrum',initoptions,@init,@main,...
                                             varargin,'sum');
end


function options = initoptions
    options = sig.signal.signaloptions(.05,.5);
    
        min.key = 'Min';
        min.type = 'Integer';
        min.default = 0;
    options.min = min;
        
        max.key = 'Max';
        max.type = 'Integer';
        max.default = Inf;
    options.max = max;
    
        win.key = 'Window';
        win.type = 'String';
        win.default = 'hamming';
    options.win = win;
    
        db.key = 'dB';
        db.type = 'Integer';
        db.default = 0;
        db.keydefault = Inf;
        db.when = 'After';
    options.db = db;   
end


%%
function [x type] = init(x,option)
    type = '?';
end


function out = main(x,option,postoption)
    if isa(x{1},'sig.Spectrum')
        obj = x{1};
    else
        d = sig.compute(@routine,x{1}.Ydata,x{1}.Srate,option);
        xrate = x{1}.Srate/x{1}.Ydata.size('sample');
        obj = sig.Spectrum(d,'xsampling',xrate,'Srate',x{1}.Frate,'Sstart',0);
    end
    if isempty(postoption)
        out = {obj};
    else
        out = {obj.after(postoption)};
    end
end


function out = routine(in,sampling,option)
    l = in.size('sample');

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
            in = in.times(w);
        end
    else
        w = [];
    end
    
    out = in.apply(@fft,{l},{'sample'});
    out = out.apply(@abs,{},{'sample'});
    out = out.deframe;
    out = out.extract('element',[1,l/2]); 
end