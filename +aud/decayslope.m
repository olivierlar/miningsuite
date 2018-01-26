% AUD.DECAYSLOPE
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = decayslope(varargin)
    out = sig.operate('aud','decayslope',...
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
    x = aud.events(x,option.envmeth,'Decays',...
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
    if ~strcmpi(x.yname,'Decay Slope')
        res = sig.compute(@routine,x.offsets,x.decays,...
                          x.offsets_s,x.decays_s,x.Ydata,...
                          option.meth,x.Srate);
        x = sig.Signal(res,'Name','Decay Slope',...
                       'Srate',0,'Sstart',x.offsets_s.content{1}); % Does not work for multi-channel
    end
    out = {x in{1}};
end


function out = routine(po,pd,pou,pdu,d,meth,sr)
    e = po.apply(@algo,{pd,pou,pdu,d,meth,sr},{'sample'},1,'{}');
    out = {e};
end


function sl = algo(po,pd,pou,pdu,d,meth,sr)
    if isempty(pd)
        sl = [];
        return
    end
    pd = sort(pd{1});
    po = sort(po{1});
    pdu = sort(pdu{1});
    pou = sort(pou{1});
    sl = zeros(1,length(pd));
    for i = 1:length(pd)
        switch meth
            case 'Diff'
                sl(i) = (d(pd(i))-d(po(i)))/(pou(i)-pdu(i));
            case 'Gauss'
                l = po(i)-pd(i);
                h = ceil(l/2);
                gauss = exp(-(1-h:l-h).^2/(l/4)^2);
                dat = diff(d(pd(i):po(i))).*gauss';
                sl(i) = mean(dat)*sr;
        end
    end
end


function x = after(x,option)
end