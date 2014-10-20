% SIG.CEPSTRUM
% computes the cepstrum, which indicates periodicities, and is used for 
% instance for pitch detection
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = cepstrum(varargin)
    varargout = sig.operate('sig','cepstrum',options,...
                            @init,@main,varargin,'sum');
end


function options = options
    options = sig.signal.signaloptions(.05,.5);
    
        mi.key = 'Min';
        mi.type = 'Numeric';
        mi.default = 0.0002;
        mi.unit = {'s','Hz'};
        mi.defaultunit = 's';
        mi.opposite = 'ma';
    options.mi = mi;

        ma.key = 'Max';
        ma.type = 'Numeric';
        ma.default = .05;
        ma.unit = {'s','Hz'};
        ma.defaultunit = 's';
        ma.opposite = 'mi';
    options.ma = ma;
        
        fr.key = 'Freq';
        fr.type = 'Boolean';
        fr.default = 0;
        fr.when = 'After';
    options.fr = fr;

        complex.key = 'Complex';
        complex.type = 'Boolean';
        complex.default = 0;
    options.complex = complex;
end


%%
function [x type] = init(x,option,frame)
    if ~x.istype('sig.Cepstrum')
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.Cepstrum';
end


function out = main(x,option,postoption)
    x = x{1};
    if isa(x,'sig.Cepstrum')
        if ~isempty(option)
            out = modify(x,option,postoption);
        else
            out = x;
        end
    else
        sr = x.inputsampling;
        ph = x.phase;
        len = ceil(option.ma*sr);
        start = ceil(option.mi*sr)+1;
        if option.complex
            out = sig.compute(@routine_complex,x.Ydata,ph,len,start);
            
            d = out;
            ph = out;
            if iscell(d.content{1})
                for i = 1:length(out.content)
                    d.content{i} = out.content{i}{1};
                    ph.content{i} = out.content{i}{2};
                end
            else
                d.content = out.content{1};
                ph.content = out.content{2};
            end
        else
            d = sig.compute(@routine_real,x.Ydata,len,start);
            ph = [];
        end
        xrate = 1/sr;
        out = sig.Cepstrum(d,'Phase',ph,...
                           'xsampling',xrate,'Xstart',start,...
                           'Srate',x.Srate,'Sstart',x.Sstart,...
                           'Ssize',x.Ssize,'Freq',option.fr);
    end
    out = {out};
end


%%
function out = routine_complex(d,ph,len,start)
    out = d.apply(@complex_cepstrum,{ph.content,len,start},{'element'});
end


function out = complex_cepstrum(x,pha,len,start)
    x = x.*exp(1i*pha);
    x = [x(1:end-1,:) ; conj(flipud(x))];
        % Reconstitution of the complete FFT
    y = log(x + 1e-12);
    y = fft(y);
    len = min(len,floor(size(y,1)/2));
    y = y(start:len,:,:);
    out = {abs(y), unwrap(angle(y))};    
end


%%
function d = routine_real(d,len,start)
    d = d.apply(@real_cepstrum,{len,start},{'element'});
end


function y = real_cepstrum(x,len,start)
    x = [x(1:end-1,:) ; flipud(x)];
        % Reconstitution of the complete abs(FFT)
    y = log(x + 1e-12);
    y = fft(y);
    len = min(len,floor(size(y,1)/2));
    y = abs(y(start:len,:,:));
end


%%
function obj = modify(obj,option,postoption)
    start = ceil(option.mi/obj.xsampling)+1;
    idx = max(start - obj.xstart,0);
    if idx > 0
        obj.xstart = start;
        obj.Xaxis.start = start;
    end
    newlen = ceil(option.ma/obj.xsampling);
    obj.Ydata = sig.compute(@extract,obj.Ydata,newlen,obj.xstart,idx);
    
    if postoption.fr
        obj.xname = 'Frequency';
        obj.xunit = 'Hz';
        obj.Xaxis.unit.generator = @freq;
    end
end


function d = extract(d,newlen,xstart,idx)
    oldlen = d.size('element');
    if idx > 0 || newlen < oldlen
        len = newlen - xstart;
        d = d.extract('element',[max(idx,1) len]);
    end
end


function x = freq(unit,index)
    x = 1./((index - 1 + unit.origin) * unit.rate);
end