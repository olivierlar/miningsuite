% AUD.ATTACKSLOPE
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = attackslope(varargin)
    out = sig.operate('aud','attackslope',...
                            initoptions,@init,@main,@after,varargin);
    varargout = out;
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameManual');

        mix.key = 'Mix';
        mix.type = 'Boolean';
        mix.default = 1;
    options.mix = mix;
    
        meth.type = 'String';
        meth.choice = {'Diff','Gauss'};
        meth.default = 'Diff';
    options.meth = meth;
    
        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = NaN;
    options.cthr = cthr;

        single.key = 'Single';
        single.type = 'Boolean';
        single.default = 0;
    options.single = single;
    
        log.key = {'LogOnset','LogCurve'};
        log.type = 'Boolean';
        log.default = 0;
    options.log = log;
    
        minlog.key = 'MinLog';
        minlog.type = 'Numeric';
        minlog.default = 0;
    options.minlog = minlog;
 
        presilence.key = 'PreSilence';
        presilence.type = 'Boolean';
        presilence.default = 0;
    options.presilence = presilence;

        postsilence.key = 'PostSilence';
        postsilence.type = 'Boolean';
        postsilence.default = 0;
    options.postsilence = postsilence;
    
        attack.key = {'Attack','Attacks'};
        attack.type = 'String';
        attack.choice = {'Derivate','Effort'};
        attack.default = 'Derivate';
    options.attack = attack;
    
        normal.key = 'Normal';
        normal.type = 'String';
        normal.choice = {0,1,'AcrossSegments'};
        normal.default = 'AcrossSegments';
    options.normal = normal;

        envmeth.type = 'String';
        envmeth.choice = {'Filter','Spectro'};
        envmeth.default = 'Spectro';
    options.envmeth = envmeth;
    
        ds.key = {'Down','PostDecim'};
        ds.type = 'Numeric';
        ds.default = NaN;
    options.ds = ds;
    
        cutoff.key = 'CutOff';
        cutoff.type = 'Numeric';
        cutoff.default = 37;
    options.cutoff = cutoff;
end


%%
function [x,type] = init(x,option)
    if isnan(option.ds)
        if x.istype('sig.Envelope')
            option.ds = 1;
        elseif strcmpi(option.envmeth,'Spectro')
            option.ds = 0;
        else
            option.ds = 16;
        end
    end
    x = aud.events(x,option.envmeth,'Attacks',option.attack,...
                     'Down',option.ds,'Contrast',option.cthr,...
                     'Single',option.single,...
                     'Log',option.log,'MinLog',option.minlog,...
                     'Presilence',option.presilence,...
                     'PostSilence',option.postsilence,...
                     'Normal',option.normal,...
                     'CutOff',option.cutoff);
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'AttackSlope')
        res = sig.compute(@routine,x.onsets,x.attacks,...
                          x.onsets_s,x.attacks_s,x.Ydata,...
                          option.meth,x.Srate);
        x = sig.Signal(res,'Name','Attack Slope',...
                       'Srate',0,'Sstart',x.onsets_s.content{1}); % Does not work for multi-channel
    end
    out = {x in{1}};
end


function out = routine(po,pa,pou,pau,d,meth,sr)
    e = po.apply(@algo,{pa,pou,pau,d,meth,sr},{'sample'},1,'{}');
    out = {e};
end


function sl = algo(po,pa,pou,pau,d,meth,sr)
    if isempty(pa)
        sl = [];
        return
    end
    pa = sort(pa{1});
    po = sort(po{1});
    pau = sort(pau{1});
    pou = sort(pou{1});
    sl = zeros(1,length(pa));
    for i = 1:length(pa)
        switch meth
            case 'Diff'
                sl(i) = (d(pa(i))-d(po(i)))/(pau(i)-pou(i));
            case 'Gauss'
                l = pa(i)-po(i);
                h = ceil(l/2);
                gauss = exp(-(1-h:l-h).^2/(l/4)^2);
                dat = diff(d(po(i):pa(i))).*gauss';
                sl(i) = mean(dat)*sr;
        end
    end
end


function x = after(x,option)
end