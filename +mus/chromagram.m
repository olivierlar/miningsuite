% MUS.CHROMAGRAM
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = chromagram(varargin)
    varargout = sig.operate('mus','chromagram',initoptions,...
                            @init,@main,varargin);
end


function options = initoptions
    options = sig.signal.signaloptions(2,.05);
    
        cen.key = 'Center';
        cen.type = 'Boolean';
        cen.default = 0;
    options.cen = cen;
    
        nor.key = {'Normal','Norm'};
        nor.type = 'Numeric';
        nor.default = Inf;
    options.nor = nor;
    
        wth.key = 'Weight';
        wth.type = 'Numeric';
        wth.default = .5;
    options.wth = wth;
    
        tri.key = 'Triangle';
        tri.type = 'Boolean';
        tri.default = 0;
    options.tri = tri;
    
        wrp.key = 'Wrap';
        wrp.type = 'Boolean';
        wrp.default = 1;
    options.wrp = wrp;
    
        plabel.key = 'Pitch';
        plabel.type = 'Boolean';
        plabel.default = 1;
    options.plabel = plabel;
    
        thr.key = {'Threshold','dB'};
        thr.type = 'Numeric';
        thr.default = 20;
    options.thr = thr;
    
        min.key = 'Min';
        min.type = 'Numeric';
        min.default = 100;
    options.min = min;
    
        max.key = 'Max';
        max.type = 'Numeric';
        max.default = 5000;
    options.max = max;

        res.key = 'Res';
        res.type = 'Numeric';
        res.default = 12;
        res.when = 'Both';
    options.res = res;

        origin.key = 'Tuning';
        origin.type = 'Numeric';
        origin.default = 261.6256;
    options.origin = origin;
    
        transp.key = 'Transpose';
        transp.type = 'Numeric';
        transp.default = 0;
    options.transp = transp;
end


%%
function [x type] = init(x,option,frame)
    if ~istype(x,'mus.Chromagram')
        freqmin = option.min;
        freqmax = freqmin*2;
        while freqmax < option.max
            freqmax = freqmax*2;
        end
        x = sig.spectrum(x,'dB',option.thr,'Min',freqmin,'Max',freqmax,...
                          'NormalInput','MinRes',option.res,'OctaveRatio',.85);
    end
    type = {'mus.Chromagram','sig.Spectrum'};
end


function out = main(orig,option,postoption)
    orig = orig{1};
    if isempty(option)
        out = {after(orig,option)};
    else
        if option.res == 12
            chromascale = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
        else
            chromascale = 1:option.res;
            option.plabel = 0;
        end
        [m,c,p,fc,o] = sig.compute(@routine,orig.Ydata,orig.xdata,option,chromascale);
        chro = mus.Chromagram(m,'ChromaClass',c,...%'XData',p
                           'ChromaFreq',fc,'Register',o,...
                           'Srate',orig.Srate,'Ssize',orig.Ssize);
        chro.Xaxis.unit.rate = 1;
        chro = after(chro,option);
        out = {chro orig};
    end
end


function out = routine(m,f,option,chromascale)
    % Let's remove the frequencies exceeding the last whole octave.
    minf = min(min(min(f)));
    maxf = max(max(max(f)));
    maxf = minf*2^(floor(log2(maxf/minf)));
    fz = find(f > maxf);
    f(fz) = [];
        
    c = freq2chro(f,option.res,option.origin);
    if not(ismember(min(c)+1,c))
        warning('WARNING IN MUS.CHROMAGRAM: Frequency resolution of the spectrum is too low.');
        display('The conversion of low frequencies into chromas may be incorrect.');
    end
    cc = min(min(min(c))):max(max(max(c)));
    sc = length(cc);   % The size of range of absolute chromas.
    mat = zeros(length(f),sc);
    fc = chro2freq(cc,option.res,option.origin);   % The absolute chromas in Hz.
    fl = chro2freq(cc-1,option.res,option.origin); % Each previous chromas in Hz.
    fr = chro2freq(cc+1,option.res,option.origin); % Each related next chromas in Hz.
    for k = 1:sc
        rad = find(and(f > fc(k)-option.wth*(fc(k)-fl(k)),...
            f < fc(k)-option.wth*(fc(k)-fr(k))));
        if option.tri
            dist = fc(k) - f(:,1,1,1);
            rad1 = dist/(fc(k) - fl(k))/option.wth;
            rad2 = dist/(fc(k) - fr(k))/option.wth;
            ndist = max(rad1,rad2);
            mat(:,k) = max(min(1-ndist,1),0)/length(rad);
        else
            mat(rad,k) = ones(length(rad),1)/length(rad);
        end
        if k ==1 || k == sc
            mat(:,k) = mat(:,k)/2;
        end
    end
    c = mod(cc',option.res);
    o = floor(cc/option.res)+4;
    if option.plabel
        p = strcat(chromascale(c+1)',num2str(o'));
    else
        p = cc'+60;
    end
    m = m.apply(@algo,{mat,fz},{'element'},1);
    out = {m,c,p,fc,o};
end


function m = algo(m,mat,fz)
    m(fz) = [];
    m = m'*mat;
    m = m';
end


function c = freq2chro(f,res,origin)
    c = round(res*log2(f/origin));
end


function f = chro2freq(c,res,origin)
    f = 2.^(c/res)*origin;
end


%%
function x = after(x,postoption)
    if postoption.wrp && ~x.wrap
        x.Ydata = sig.compute(@wrap,x.Ydata,x.chromaclass,postoption.res);
    end
end


function x = wrap(x,cc,res)
    x = x.apply(@wrap_algo,{cc,res},{'element'},1);
end


function m2 = wrap_algo(m,cc,res)
    m2 = zeros(res,1);
    for i = 1:length(m)
        m2(cc(i)+1) = m2(cc(i)+1) + m(i);
    end
end