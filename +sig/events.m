% SIG.EVENTS
% estimates a temporal curve where peaks relate to the temporal position of 
% events, and estimates those event time positions.
%
% Copyright (C) 2017-2018 Olivier Lartillot
% Code for envelope generation from MIDI file is taken from onsetacorr.m
%   and duraccent.m, part of MIDI Toolbox. Copyright (C) 2004, University of 
%   Jyvaskyla, Finland
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = events(varargin)
    varargout = sig.operate('sig','events',initoptions,...
                            @init,@main,@after,varargin,'concat','extensive');
end


function options = initoptions
    options = sig.Signal.signaloptions('FrameManual',3,.1,'After');

%% options related to 'Envelope':

        env.key = 'Envelope';
        env.type = 'Boolean';
        env.default = NaN;
    options.env = env;

        envmethod.key = 'Method'; % optional
        envmethod.type = 'Boolean';
    options.envmethod = envmethod;
    
        envmeth.type = 'String';
        envmeth.choice = {'Filter','Spectro'};
        envmeth.default = 'Spectro';
    options.envmeth = envmeth;
 
%%      options related to 'Filter':

            filter.key = 'FilterType';
            filter.type = 'String';
            filter.choice = {'IIR','HalfHann','Butter'};
            filter.default = 'IIR';
        options.filter = filter;

            tau.key = 'Tau';
            tau.type = 'Numeric';
            tau.default = .02;
        options.tau = tau;

            cutoff.key = 'CutOff';
            cutoff.type = 'Numeric';
            cutoff.default = 37;
    options.cutoff = cutoff;

            decim.key = {'Decim','PreDecim'};
            decim.type = 'Numeric';
            decim.default = 0;
        options.decim = decim;

            hilb.key = {'Hilbert'};
            hilb.type = 'Boolean';
            hilb.default = 0;
        options.hilb = hilb;        
        
%%      options related to 'Spectro':
        
            specframe.key = 'SpectroFrame';
            specframe.type = 'Numeric';
            specframe.number = 2;
            specframe.default = [.1 .1];
        options.specframe = specframe;
        
            presilence.key = 'PreSilence';
            presilence.type = 'Boolean';
            presilence.default = 0;
        options.presilence = presilence;

            postsilence.key = 'PostSilence';
            postsilence.type = 'Boolean';
            postsilence.default = 0;
        options.postsilence = postsilence;
        
            powerspectrum.key = 'PowerSpectrum';
            powerspectrum.type = 'Boolean';
            powerspectrum.default = 1;
        options.powerspectrum = powerspectrum;        

            timesmooth.key = 'TimeSmooth';
            timesmooth.type = 'Boolean';
            timesmooth.default = 0;
            timesmooth.keydefault = 10;
        options.timesmooth = timesmooth;        


        sum.key = 'Sum';
        sum.type = 'Boolean';
        sum.default = 1;
    options.sum = sum;

        chwr.key = 'HalfwaveCenter';
        chwr.type = 'Boolean';
        chwr.default = 0;
    options.chwr = chwr;
    
        oplog.key = 'Log';
        oplog.type = 'Boolean';
        oplog.default = 0;
    options.log = oplog;

        minlog.key = 'MinLog';
        minlog.type = 'Numeric';
        minlog.default = 0;
    options.minlog = minlog;

        oppow.key = 'Power';
        oppow.type = 'Boolean';
        oppow.default = 0;
    options.power = oppow;
    
        diff.key = 'Diff';
        diff.type = 'Numeric';
        diff.default = 0;
        diff.keydefault = 1;
    options.diff = diff;
    
        diffhwr.key = 'HalfwaveDiff';
        diffhwr.type = 'Numeric';
        diffhwr.default = 0;
        diffhwr.keydefault = 1;
    options.diffhwr = diffhwr;

        c.key = 'Center';
        c.type = 'Boolean';
        c.default = 0;
    options.c = c;
    
        aver.key = 'Smooth';
        aver.type = 'Numeric';
        aver.default = 0;
        aver.keydefault = 30;
    options.aver = aver;
    
        ds.key = {'Down','PostDecim'};
        ds.type = 'Numeric';
        ds.default = NaN;
        ds.when = 'Both';
        ds.chunkcombine = 'During';
    options.ds = ds;

        sampling.key = 'Sampling';
        sampling.type = 'Numeric';
        sampling.default = 0;
    options.sampling = sampling;
    
        up.key = {'UpSample'};
        up.type = 'Numeric';
        up.default = 0;
        up.keydefault = 2;
    options.up = up;
    
        normal.key = 'Normal';
        normal.type = 'String';
        normal.choice = {0,1,'AcrossSegments'};
        normal.default = 1;
    options.normal = normal;

%% options related to 'SpectralFlux'
        flux.key = 'SpectralFlux';
        flux.type = 'Boolean';
        flux.default = 0;
    options.flux = flux;
    
        complex.key = 'Complex';
        complex.type = 'Boolean';
        complex.default = 0;
    options.complex = complex;
    
        inc.key = 'Inc';
        inc.type = 'Boolean';
        inc.default = 1;
    options.inc = inc;
    
        median.key = 'Median';
        median.type = 'Numeric';
        median.number = 2;
        median.default = [.2 1.3];
    options.median = median;

        hw.key = 'Halfwave';
        hw.type = 'Boolean';
        hw.default = 1;
    options.hw = hw;
    
%% options related to 'Novelty':
        novelty.key = 'Novelty';
        novelty.type = 'Boolean';
        novelty.default = 0;
    options.novelty = novelty;

        kernelsize.key = 'KernelSize';
        kernelsize.type = 'Numeric';
        kernelsize.default = 0;
    options.kernelsize = kernelsize;

%% options related to event detection
        detect.key = 'Detect';
        detect.type = 'String';
        detect.choice = {'Peaks','Valleys',0,'no','off'};
        detect.default = 'Peaks';
        detect.keydefault = 'Peaks';
    options.detect = detect;
    
        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = .01;
    options.cthr = cthr;

        thr.key = 'Threshold';
        thr.type = 'Numeric';
        thr.default = 0;
    options.thr = thr;
    
        single.key = 'Single';
        single.type = 'Boolean';
        single.default = 0;
    options.single = single;

end


%%
function [y,type] = init(x,option)
    type = 'sig.Envelope';
    if isnan(option.env)
        if option.flux || option.novelty 
            option.env = 0;
        else
            option.env = 1;
        end
    end
    if ~option.kernelsize
        option.kernelsize = 64;
    end
    if x.istype('sig.Signal') || x.istype('sig.Envelope')
        y = [];
        if option.env
            if strcmpi(option.envmeth,'Filter')
                y = sig.envelope(fb,'Filter','FilterType',option.filter,...
                    'Hilbert',option.hilb,...
                    'Tau',option.tau,...'CutOff',option.cutoff,...
                    'UpSample',option.up,...
                    'PreDecim',option.decim,'PostDecim',[0 option.ds]);%,...
%                     'PreSilence',option.presilence,...
%                     'PostSilence',option.postsilence);
            else
                y = aud.envelope(x,'Spectro',...
                    'Frame','FrameSize',option.specframe(1),...
                            'FrameHop',option.specframe(2),...
                    'PowerSpectrum',option.powerspectrum,...
                    'TimeSmooth',option.timesmooth);...,...
                    %'PreSilence',option.presilence,...
                    %'PostSilence',option.postsilence);
            end
            
        end
        if option.flux
            z = sig.flux(x,'Inc',option.inc,'Complex',option.complex); %,'Dist','City'); %%%%%%%%%%%%%%%%%???
            if isempty(y)
                y = z;
            else
                y = y+z;
            end
        end
%         if option.novelty
%             s = mirspectrum(x,'max',1000,'Frame',.05,.2,'MinRes',3,'dB');
%             %c = mircepstrum(x,'Frame',.05,.2);
%             z = mirnovelty(s,'KernelSize',option.kernelsize,... 'Flux',...
%                 ...'Distance','Euclidean',...
%                 'Similarity','oneminus');
%             if isempty(y)
%                 y = z;
%             else
%                 y = y+z;
%             end
%         end
%     elseif isamir(x,'mirscalar') || isamir(x,'mirenvelope')
%         y = x;
    end
    y = {y,x};
end


%%
function out = main(o,option)
    if iscell(o)
        o = o{1};
    end
    if isa(o,'sig.Envelope')
        if option.sampling
            o = sig.envelope(o,'Sampling',option.sampling);
        else
            if isnan(option.ds)
                %% If input already envelope, ds=1
                if option.decim || strcmpi(option.envmeth,'Spectro')
                    option.ds = 0;
                else
                    option.ds = 16;
                end
            end
            if option.ds
                o = sig.envelope(o,'Down',option.ds);
            end
        end
    end
    if isa(o,'sig.Envelope')
        if option.power
            o = sig.envelope(o,'Power');
        end
        if option.diff
            o = sig.envelope(o,'Diff',option.diff,...
                'Lambda',option.lambda,...
                'Complex',option.complex);
        end
        if option.diffhwr
            o = sig.envelope(o,'HalfwaveDiff',option.diffhwr,...
                'Lambda',option.lambda,...
                'Complex',option.complex);
        end
        if option.aver
            o = sig.envelope(o,'Smooth',option.aver);
        end
        if option.chwr
            o = sig.envelope(o,'HalfwaveCenter');
        end
        %         elseif isa(o,'mirscalar') && strcmp(get(o,'Title'),'Novelty')  %%%%%%%%%%%%%%%
        %             if postoption.diff
        %                 o = mirenvelope(o,'Diff',postoption.diff,...
        %                     'Complex',postoption.complex);
        %             end
    end
    
    if option.sum
        o = sig.sum(o,'Type','freqband'); %'channel'); %,'Adjacent',option.sum);
    end
    
    if isa(o,'sig.Envelope') && ~isequal(option.normal,0) && ~o.log
        o = sig.envelope(o,'Normal',option.normal);
    end
    if isa(o,'sig.Envelope') && option.log
        o = sig.envelope(o,'Log');
    end
    if option.c
        o = sig.envelope(o,'Center');
    end
    if isa(o,'sig.Envelope') && option.minlog
        o = sig.envelope(o,'MinLog',option.minlog);
    end
    if option.frame
        o = sig.frame(o,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop,unit);
    end
    if ischar(option.detect)
        if option.single
            total = 1;
            noend = 0;
        else
            total = Inf;
            noend = 1;
        end
        if strcmpi(option.detect,'Peaks')
            o = sig.peaks(o,'Total',total,'SelectFirst',0,...
                'Threshold',option.thr,'Contrast',option.cthr,...
                'Order','Abscissa','NoBegin','NoEnd',noend);
        elseif strcmpi(option.detect,'Valleys')
            o = sig.peaks(o,'Total',total,'SelectFirst',0,...
                'Threshold',option.thr,'Contrast',option.cthr,...
                'Valleys','Order','Abscissa','NoBegin','NoEnd',noend);
        end
        nop = {}; %cell(size(get(o,'Data')));
%         o.onsets = nop;
    end
    title = o.yname;
    if not(length(title)>11 && strcmp(title(1:11),'Onset curve'))
        o.yname = ['Onset curve (',title,')'];
    end
    out = {o};
end


function x = after(x,option)
end