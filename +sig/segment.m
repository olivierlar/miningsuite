% SIG.SEGMENT
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = segment(varargin)
    varargout = sig.operate('sig','segment',initoptions,...
                     @init,@main,@after,varargin);
end
                    
                    
%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,1);
    
        mfc.key = {'Rank','MFCC'};
        mfc.type = 'Integers';
        mfc.default = 0;
        mfc.keydefault = 1:13;
    options.mfc = mfc;

        K.key = 'KernelSize';
        K.type = 'Integer';
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
        tot.type = 'Integer';
        tot.default = Inf;
    options.tot = tot;

        cthr.key = 'Contrast';
        cthr.type = 'Integer';
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
            mi.type = 'Integer';
            mi.default = 0;
        options.mi = mi;

            ma.key = 'Max';
            ma.type = 'Integer';
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
            throff.type = 'Integer';
            throff.default = .01;
        options.throff = throff;

            thron.key = 'On';
            thron.type = 'Integer';
            thron.default = .02;
        options.thron = thron;

        strat.choice = {'Novelty','HCDF','RMS','Silence'}; % should remain as last field
        strat.default = 'Novelty';
        strat.position = 2;
    options.strat = strat;
    
        pos.type = 'Numeric';
        pos.default = [];
    options.pos = pos;
end


%%
function [out type] = init(x,option,frame)
    if isempty(option.pos)
        if iscell(x)
            x = x{1};
        end
        if ischar(option.strat)
            if strcmpi(option.strat,'Novelty')
                if ~frame.size.value
                    if strcmpi(option.ana,'Keystrength')
                        frame.size.value = .5;
                        frame.hop.value = .2;
                    elseif strcmpi(option.ana,'AutocorPitch') ...
                            || strcmpi(option.ana,'Pitch')
                        frame.size.value = .05;
                        frame.hop.value = .01;
                    else
                        frame.size.value = .05;
                        frame.hop.value = 1;
                    end
                end
                frame.toggle = 1;
                if not(isequal(option.mfc,0))
                    fe = aud.mfcc(x,'FrameConfig',frame,'Rank',option.mfc);
                elseif strcmpi(option.ana,'Spectrum')
                    fe = mirspectrum(fr,'Min',option.mi,'Max',option.ma,...
                        'Normal',option.norm,option.band,...
                        'Window',option.win);
                elseif strcmpi(option.ana,'Keystrength')
                    fe = mirkeystrength(fr);
                elseif strcmpi(option.ana,'AutocorPitch') ...
                        || strcmpi(option.ana,'Pitch')
                    [unused,fe] = mirpitch(x,'Frame');
                else
                    fe = x;
                end
                n = sig.novelty(fe,'Distance',option.distance,...
                                'FrameConfig',frame,...
                                'Measure',option.measure,...
                                'KernelSize',option.K);
                p = sig.peaks(n,'Total',option.tot,...
                                'Contrast',option.cthr,...
                                'Chrono','NoBegin','NoEnd');
            end
        end
        out = {x,p};
    else
        out = x;
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if length(in) > 1
        y = in{2};
        pos = y.peakprecisepos.content{1};
    else
        pos = option.pos;
        if isa(pos,'sig.design')
            pos = pos.eval(x.files);
            if iscell(pos)
                pos = pos{1};
            end
        end
        if isa(pos,'sig.Signal')
            if isempty(pos.peakpos)
                pos = sig.peaks(pos,'Total',option.tot,...
                                    'Contrast',option.cthr,...
                                    'Chrono','NoBegin','NoEnd');
            end
            pos = sort(pos.peakpos.content{1});
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
        si1 = 0;
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
            if si1
                s{end+1} = x.Ydata.view('sample',[si1,si2-1]);
            elseif si2 > 1
                s{end+1} = x.Ydata.view('sample',[1,si2-1]);
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
    out = {x};
end


function x = after(x,option)
end