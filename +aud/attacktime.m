% AUD.ATTACKTIME
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = attacktime(varargin)
    out = sig.operate('aud','attacktime',...
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
    
        scale.type = 'String';
        scale.choice = {'Lin','Log'};
        scale.default = 'Lin';
    options.scale = scale;
    
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
                     ...'Normal','AcrossSegments',...
                     'CutOff',option.cutoff);
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'AttackTime')
        res = sig.compute(@routine,x.onsets_s,x.attacks_s,option.scale);
        x = sig.Signal(res,'Name','Attack Time',...
                       'Srate',0,'Sstart',x.onsets_s.content{1}); % Does not work for multi-channel
    end
    out = {x in{1}};
end


function out = routine(op,ap,sc)
    e = op.apply(@algo,{ap,sc},{'sample'},1,'{}');
    out = {e};
end


function at = algo(op,ap,sc)
    if isempty(ap)
        at = [];
        return
    end
    op = sort(op{1});
    ap = sort(ap{1});
    if length(op) > length(ap)
        op(length(ap)+1:end) = [];
    end
    at = ap-op;
    at = at';
    if strcmpi(sc,'Log')
        at = log10(at);
    end
end


function x = after(x,option)
end