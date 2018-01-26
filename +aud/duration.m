% AUD.DURATION
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = duration(varargin)
    out = sig.operate('aud','duration',...
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
        envmeth.default = 'Filter';
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
                     'Decays',...
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
    if ~strcmpi(x.yname,'Duration')
        res = sig.compute(@routine,x.onsets,x.attacks,x.decays,x.offsets,...
                          x.sdata,x.Ydata);
        x = sig.Signal(res,'Name','Duration',...
                       'Srate',0,'Sstart',x.onsets_s.content{1}); % Does not work for multi-channel
    end
    out = {x in{1}};
end


function out = routine(on,at,de,of,t,d)
    e = on.apply(@algo,{at,de,of,t,d},{'sample'},1,'{}');
    out = {e};
end


function du = algo(on,at,de,of,t,d)
    if isempty(at)
        du = [];
        return
    end
    on = on{1};
    at = at{1};
    de = de{1};
    of = of{1};
    du = zeros(1,length(at));
    for i = 1:length(at)
        [mv,mp] = max(d(at(i):de(i)));
        mp = at(i) + mp - 1;
        f1 = find(d(mp:-1:on(i)) < mv * .4,1);
        if isempty(f1)
            t1 = t(at(i));
        else
            t1 = t(mp - f1);
        end
        f2 = find(d(mp:of(i)) < mv * .4,1);
        if isempty(f2)
            t2 = t(de(i));
        else
            t2 = t(mp + f2);
        end
        du(i) = t2 - t1;
    end
end


function x = after(x,option)
end