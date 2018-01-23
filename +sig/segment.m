% SIG.SEGMENT
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = segment(varargin)
    out = sig.operate('sig','segment',initoptions,...
                     @init,@main,@after,varargin);
    if isa(out{1},'sig.design')
        out{1}.nochunk = 1;
    end
    varargout = out;
                 
end
                    
                    
%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,1);
    
        mfc.key = {'Rank','MFCC'};
        mfc.type = 'Numeric';
        mfc.default = 1:13;
    options.mfc = mfc;

        K.key = 'KernelSize';
        K.type = 'Numeric';
        K.default = 128;
    options.K = K;
    
        distance.key = 'Distance';
        distance.type = 'String';
        distance.default = 'cosine';
    options.distance = distance;

        measure.key = {'Measure','Similarity'};
        measure.type = 'String';
        measure.default = 'exponential';
    options.measure = measure;

        tot.key = 'Total';
        tot.type = 'Numeric';
        tot.default = Inf;
    options.tot = tot;

        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = .1;
    options.cthr = cthr;

        ana.type = 'String';
        ana.choice = {'Spectrum','Keystrength','AutocorPitch','Pitch'};
        ana.default = 0;
    options.ana = ana;
    
%       f = mirsegment(...,'Spectrum')    
    
            band.choice = {'Mel','Bark','Freq'};
            band.type = 'String';
            band.default = 'Freq';
        options.band = band;

            mi.key = 'Min';
            mi.type = 'Numeric';
            mi.default = 0;
        options.mi = mi;

            ma.key = 'Max';
            ma.type = 'Numeric';
            ma.default = 0;
        options.ma = ma;

            norm.key = 'Normal';
            norm.type = 'Boolean';
            norm.default = 0;
        options.norm = norm;

            win.key = 'Window';
            win.type = 'String';
            win.default = 'hamming';
        options.win = win;
    
%       f = mirsegment(...,'Silence')    
    
            throff.key = 'Off';
            throff.type = 'Numeric';
            throff.default = .01;
        options.throff = throff;

            thron.key = 'On';
            thron.type = 'Numeric';
            thron.default = .02;
        options.thron = thron;

        strat.choice = {'Novelty','HCDF','RMS','Silence'}; % should remain as last field
        strat.default = 'Novelty';
        strat.position = 2;
    options.strat = strat;
    
        pos.default = [];
        pos.position = 2;
    options.pos = pos;
end


%%
function [out,type] = init(x,option)
    if isempty(option.pos)
        if iscell(x)
            x = x{1};
        end
        if ischar(option.strat)
            if strcmpi(option.strat,'Novelty')
                if x.istype('sig.Signal')
                    y = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
                else
                    y = x;
                end
                fe = aud.mfcc(y,'Rank',option.mfc);
                n = sig.novelty(fe,'Distance',option.distance,...
                                'Measure',option.measure,...
                                'KernelSize',option.K);
                z = sig.peaks(n,'Total',option.tot,...
                                'Contrast',option.cthr,...
                                'Order','Abscissa','NoBegin','NoEnd');
            elseif strcmpi(option.strat,'RMS')
                if x.istype('sig.Signal')
                    y = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
                else
                    y = x;
                end
                z = sig.rms(y);
            end
        end
        out = {x,z};
    else
        out = x;
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if length(in) > 1
        y = in{2};
        if strcmpi(option.strat,'Novelty')
            pos = y.peakprecisepos.content{1};
        elseif strcmpi(option.strat,'RMS')
            pos = sig.compute(@RMS,y.Ydata,y.sdata,option);
            pos = pos.content;
        end
    else
        pos = option.pos;
        if isa(pos,'sig.design')
            pos = pos.eval(x.files);
            if iscell(pos)
                pos = pos{1};
            end
        end
        if isa(pos,'sig.Signal')
            if isa(pos,'aud.Envelope') && ~isempty(pos.attacks)
                ap = pos.attacks.content{1};
                pos = pos.saxis.data(ap);
            else
                if isempty(pos.peakindex)
                    pos = sig.peaks(pos,'Total',option.tot,...
                        'Contrast',option.cthr,...
                        'Chrono','NoBegin','NoEnd');
                end
                pos = sort(pos.peakprecisepos.content{1});
            end
        end
    end
    
%     if 0 %strcmp(type,'sp')
%         pos(pos > x.Ssize) = [];
%         if pos(1) > 1
%             pos = [1 pos];
%         end
%         %if pos(end) < x.Ydata.size('sample')
%             pos(end+1) = x.Ydata.size('sample')+1;
%         %end
%         s = cell(1,length(pos)-1);
%         Sstart = zeros(1,length(pos)-1);
%         for i = 1:length(pos)-1
%             s{i} = x.Ydata.content(pos(i):pos(i+1)-1);
%             Sstart(i) = unit.generate(pos(i));
%         end
%    elseif strcmp(type,'s')
        s = {};
        Sstart = x.Sstart;
        si1 = 1;
        pos(end+1) = Inf;
        for i = 1:length(pos)
            si2 = find(x.sdata > pos(i),1);
            if isempty(si2)
                if si1
                    if si1 < x.Ssize
                        s{end+1} = x.Ydata.view('sample',[si1,x.Ydata.size('sample')]);
                    end
                else
                    s{end+1} = x.Ydata.content;
                end
                break
            end
            if si2 > si1
                s{end+1} = x.Ydata.view('sample',[si1,si2-1]);
            end
            si1 = si2;
            if i < length(pos)
                Sstart(end+1) = pos(i);
            end
        end
%    end
    x.Ydata.content = s;
    x.Ydata.layers = 2;
    x.Sstart = Sstart;
    x.Send = [Sstart(2:end),x.Send];
    out = {x};
end


function out = RMS(d,fp,option)
    d = d.apply(@findsilenceRMS,{fp,option.thron,option.throff},{'sample'},1);
    out = {d};
end


function p = findsilenceRMS(d,t,throff,thron)
    d = [0;d;0];
    begseg = find(d(1:end-1)<thron & d(2:end)>=thron);
    nseg = length(begseg);
    endseg = zeros(1,nseg);
    removed = [];
    for i = 1:nseg
        endseg(i) = begseg(i) + find(d(begseg(i)+1:end)<=throff, 1)-1;
        if i>1 && endseg(i) == endseg(i-1)
            removed = [removed i];
        end
    end
    begseg(removed) = [];
    p = t(begseg)';
end

function x = after(x,option)
end