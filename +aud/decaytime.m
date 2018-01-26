% AUD.DECAYTIME
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = decaytime(varargin)
    out = sig.operate('aud','decaytime',...
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
    x = aud.events(x,option.envmeth,'Decays',...
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
    if ~strcmpi(x.yname,'Decay Time')
        res = sig.compute(@routine,x.offsets_s,x.decays_s,option.scale);
        x = sig.Signal(res,'Name','Decay Time',...
                       'Srate',0,'Sstart',x.decays_s.content{1}); % Does not work for multi-channel
    end
    out = {x in{1}};
end


function out = routine(op,dp,sc)
    e = op.apply(@algo,{dp,sc},{'sample'},1,'{}');
    out = {e};
end


function dt = algo(op,dp,sc)
    if isempty(dp)
        dt = [];
        return
    end
    op = sort(op{1});
    dp = sort(dp{1});
    if length(op) > length(dp)
        op(length(dp)+1:end) = [];
    end
    dt = op-dp;
    dt = dt';
    if strcmpi(sc,'Log')
        dt = log10(dt);
    end
end


function x = after(x,option)
end