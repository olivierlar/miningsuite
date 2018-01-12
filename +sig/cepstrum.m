% SIG.CEPSTRUM
% computes the cepstrum, which indicates periodicities, and is used for 
% instance for pitch detection
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = cepstrum(varargin)
    out = sig.operate('sig','cepstrum',options,...
                            @init,@main,@after,varargin);
%     if isa(out{1},'sig.design')
%         out{1}.nochunk = 1;
%     end
    varargout = out;
end


function options = options
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    
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
    options.fr = fr;

        complex.key = 'Complex';
        complex.type = 'Boolean';
        complex.default = 0;
    options.complex = complex;
end


%%
function [x,type] = init(x,option,frame)
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
        x = sig.spectrum(x);   
    end
    type = 'sig.Cepstrum';
end


function out = main(x,option)
    x = x{1};
    if isa(x,'sig.Cepstrum')
        out = {x};
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
                           'Ssize',x.Ssize,'Freq',option.fr,...
                           'FbChannels',x.fbchannels);
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
    d = d.apply(@real_cepstrum,{len,start},{'element'},5);
end


function y = real_cepstrum(x,len,start)
    x = [x(1:end-1,:,:,:,:) ; flipud(x)];
        % Reconstitution of the complete abs(FFT)
    y = log(x + 1e-12);
    y = fft(y);
    len = min(len,floor(size(y,1)/2));
    y = abs(y(start:len,:,:,:,:));
end


%%
function out = after(in,option)
    x = in{1};
    start = ceil(option.mi/x.xsampling)+1;
    idx = max(start - x.xstart,0);
    if idx > 0
        x.xstart = start;
        x.Xaxis.start = start;
    end
    newlen = ceil(option.ma/x.xsampling);
    x.Ydata = sig.compute(@extract,x.Ydata,newlen,x.xstart,idx);
    
    if option.fr
        x.Xaxis.name = 'Frequency';
        x.Xaxis.unit.name = 'Hz';
        x.Xaxis.unit.generator = @freq;
    end

    out = {x};
end


function d = extract(d,newlen,xstart,idx)
    oldlen = d.size('element');
    if idx > 0 || newlen < oldlen
        len = newlen - xstart;
        d = d.extract('element',[max(idx,1) len]);
    end
end


function x = freq(unit,index,segment)
    x = 1./((index - 1 + unit.origin) * unit.rate);
end