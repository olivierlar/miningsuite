% AUD.EVENTS
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
    varargout = sig.operate('aud','events',initoptions,...
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
            filter.default = NaN;
        options.filter = filter;

            tau.key = 'Tau';
            tau.type = 'Numeric';
            tau.default = .02;
        options.tau = tau;

            cutoff.key = 'CutOff';
            cutoff.type = 'Numeric';
            cutoff.default = 37;
    options.cutoff = cutoff;
    
            fb.key = {'Filterbank','NbChannels'};
            fb.type = 'Numeric';
            fb.default = NaN;
        options.fb = fb;

            filtertype.key = 'FilterbankType';
            filtertype.type = 'String';
            %filtertype.choice = {'Gammatone','2Channels','Scheirer','Klapuri'};
            filtertype.default = 'Gammatone';
        options.filtertype = filtertype;

            decim.key = {'Decim','PreDecim'};
            decim.type = 'Numeric';
            decim.default = 0;
        options.decim = decim;

            hilb.key = {'Hilbert'};
            hilb.type = 'Boolean';
            hilb.default = NaN;
        options.hilb = hilb;        
        
%%      options related to 'Spectro':

            band.type = 'String';
            band.choice = {'Freq','Mel','Bark','Cents'};
            band.default = 'Freq';
        options.band = band;
        
            specframe.key = 'SpectroFrame';
            specframe.type = 'Numeric';
            specframe.number = 2;
            specframe.default = NaN;
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

            terhardt.key = 'Terhardt';
            terhardt.type = 'Boolean';
            terhardt.default = 0;
        options.terhardt = terhardt;

        sum.key = 'Sum';
        sum.type = 'Boolean';
        sum.default = 1;
    options.sum = sum;

        chwr.key = 'HalfwaveCenter';
        chwr.type = 'Boolean';
        chwr.default = 0;
    options.chwr = chwr;
    
        mu.key = 'Mu';
        mu.type = 'Numeric';
        mu.default = 0;
        mu.keydefault = 100;
    options.mu = mu;
    
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
    
        diffenv.key = 'DiffEnvelope'; % obsolete, replaced by 'Diff'
        diffenv.type = 'Boolean';
        diffenv.default = 0;
    options.diffenv = diffenv;

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

        lambda.key = 'Lambda';
        lambda.type = 'Numeric';
        lambda.default = 1;
    options.lambda = lambda;

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
    
%% options related to 'Pitch':
        pitch.key = 'Pitch';
        pitch.type = 'Boolean';
        pitch.default = 0;
    options.pitch = pitch;

        min.key = 'Min';
        min.type = 'Numeric';
        min.default = 30;
    options.min = min;

        max.key = 'Max';
        max.type = 'Numeric';
        max.default = 1000;
    options.max = max;
    
        novelty.key = 'Novelty';
        novelty.type = 'Boolean';
        novelty.default = 0;
    options.novelty = novelty;

        kernelsize.key = 'KernelSize';
        kernelsize.type = 'Numeric';
        kernelsize.default = 0;
    options.kernelsize = kernelsize;
    
%% options related to 'Emerge':
        sgate.key = {'SmoothGate','Emerge'};
        sgate.type = 'String';
        sgate.choice = {'Goto','Lartillot'};
        sgate.default = '';
        sgate.keydefault = 'Lartillot';
    options.sgate = sgate;
    
        minres.key = 'MinRes';
        minres.type = 'Numeric';
        minres.default = 10;
    options.minres = minres;

%%
        nomodif.key = 'NoModif';
        nomodif.type = 'Boolean';
        nomodif.default = 0;
    options.nomodif = nomodif;

%% options related to event detection
        detect.key = 'Detect';
        detect.type = 'String';
        detect.choice = {'Peaks','Valleys',0,'no','off'};
        detect.default = 'Peaks';
        detect.keydefault = 'Peaks';
    options.detect = detect;
    
        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = NaN;
    options.cthr = cthr;

        thr.key = 'Threshold';
        thr.type = 'Numeric';
        thr.default = 0;
    options.thr = thr;
    
        single.key = 'Single';
        single.type = 'Boolean';
        single.default = 0;
    options.single = single;

        attack.key = {'Attack','Attacks'};
        attack.type = 'String';
        attack.choice = {'Derivate','Effort'};
        attack.default = 0;
        attack.keydefault = 'Derivate';
    options.attack = attack;
    
        alpha.key = 'Alpha';
        alpha.type = 'Numeric';
        alpha.default = 3.75;
    options.alpha = alpha;  
    
        new.key = 'New';
        new.default = 0;
    options.new = new;
        
        decay.key = {'Decay','Decays','Release','Releases'};
        decay.type = 'Boolean';
        decay.default = 0;
    options.decay = decay;
    
%% preselection
        presel.choice = {'Scheirer','Klapuri99'};
        presel.type = 'String';
        presel.default = 0;
    options.presel = presel;

end


%%
function [y, type] = init(x,option,frame)
    type = 'sig.Envelope';
    if isa(x,'mus.Sequence')
        y = x;
        return
    end
    if ischar(option.presel)
        if strcmpi(option.presel,'Scheirer')
            option.filtertype = 'Scheirer';
            option.filter = 'HalfHann';
            option.envmeth = 'Filter';
        elseif strcmpi(option.presel,'Klapuri99')
            option.filtertype = 'Klapuri';
            option.filter = 'HalfHann';
            option.envmeth = 'Filter';
            option.decim = 180;
            option.mu = 100;
        end
    end
    if option.diffenv
        option.env = 1;
    end
    if isnan(option.env)
        if option.flux || option.pitch || option.novelty || ...
                (ischar(option.sgate) && ~isempty(option.sgate))
            option.env = 0;
        else
            option.env = 1;
        end
    end
    if ~option.kernelsize
        if option.pitch
            option.kernelsize = 32;
        elseif option.novelty
            option.kernelsize = 64;
        end
    end
    if x.istype('sig.Signal') || x.istype('sig.Envelope')
        y = [];
        if option.env
            if strcmpi(option.envmeth,'Filter')
                if isnan(option.filter)
                    if ischar(option.attack) || option.decay
                        option.filter = 'Butter';
                    else
                        option.filter = 'IIR';
                    end
                end
                if isnan(option.hilb)
                    if ischar(option.attack) || option.decay
                        option.hilb = 1;
                    else
                        option.hilb = 0;
                    end
                end
                if isnan(option.fb)
                    if ischar(option.attack) || option.decay
                        option.fb = 0;
                    else
                        option.fb = 40;
                    end
                end
                
                if option.fb>1
                    fb = aud.filterbank(x,option.filtertype,'NbChannels',option.fb);
                else
                    fb = x;
                end
                y = aud.envelope(fb,'Filter','FilterType',option.filter,...
                    'Hilbert',option.hilb,...
                    'Tau',option.tau,...'CutOff',option.cutoff,...
                    'UpSample',option.up,...
                    'PreDecim',option.decim,'PostDecim',[0 option.ds],...
                    'Mu',option.mu);%,...
%                     'PreSilence',option.presilence,...
%                     'PostSilence',option.postsilence);
            else
                if isnan(option.specframe)
                    if ischar(option.attack) || option.decay
                        option.specframe = [.03 .02];
                    else
                        option.specframe = [.1 .1];
                    end
                end
                y = aud.envelope(x,'Spectro',...
                    'Frame',option.specframe(1),option.specframe(2),...
                    'PowerSpectrum',option.powerspectrum,...
                    'TimeSmooth',option.timesmooth,...
                    'Terhardt',option.terhardt);...,...
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
%         if option.pitch
%             [unused ac] = mirpitch(x,'Frame','Min',option.min,'Max',option.max);
%             z = mirnovelty(ac,'KernelSize',option.kernelsize);
%             if isempty(y)
%                 y = z;
%             else
%                 y = y+z;
%             end
%         elseif option.novelty
%             s = mirspectrum(x,'max',1000,'Frame',.05,.2,'MinRes',3,'dB');
%             %c = mircepstrum(x,'Frame',.05,.2);
%             %[p ac] = mirpitch(x,'Frame');
%             z = mirnovelty(s,'KernelSize',option.kernelsize,... 'Flux',...
%                 ...'Distance','Euclidean',...
%                 'Similarity','oneminus');
%             if isempty(y)
%                 y = z;
%             else
%                 y = y+z;
%             end
%         elseif ischar(option.sgate) && ~isempty(option.sgate)
%             if strcmpi(option.sgate,'Goto')
%                 x = miraudio(x,'Sampling',22050);
%                 y = mirspectrum(x,'Frame',.04644,.25);
%             else
%                 y = mirspectrum(x,'Frame',.05,.2,....
%                     'MinRes',option.minres,'dB','max',5000);
%                 if option.minres < 1 && isa(y,'mirdesign')
%                     y = set(y,'ChunkSizeFactor',get(x,'ChunkSizeFactor')*5); %20/option.minres);
%                 end
%             end
%             y = mirflux(y,'Inc','BackSmooth',option.sgate,'Dist','Gate');
%         end
%     elseif (option.pitch && not(isamir(x,'mirscalar'))) ...
%             || isamir(x,'mirsimatrix')
%         y = mirnovelty(x,'KernelSize',option.kernelsize);
%     elseif isamir(x,'mirscalar') || isamir(x,'mirenvelope') || ...
%             (isamir(x,'mirspectrum') && ischar(option.sgate) && ~isempty(option.sgate))
%         y = x;
    end
%     if ischar(option.attack) || option.decay
%         z = mironsets(x,option.envmeth,...
%             'PreSilence',option.presilence,'PostSilence',option.postsilence);
%         y = {y,z};
%     end
    y = {y,x};
end


%%
function out = main(o,option)  
    if isa(o,'mus.Sequence')
        out = symbolic(o,option);
        return
    end
    if iscell(o)
        if length(o) > 1
            option.new = o{2};
        end
        o = o{1};
    end
    if not(isempty(option)) && ischar(option.presel)
        if strcmpi(option.presel,'Scheirer')
            option.sampling = 200;
            option.diffhwr = 1;
            option.sum = 0;
            option.detect = 0;
        elseif strcmpi(option.presel,'Klapuri99')
            option.diffhwr = 1;
            option.sum = 0;
            option.ds = 0;
            o2 = o;
        end
    end
    if option.diffenv
        option.diff = 1;
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
        %         elseif isa(o,'mirscalar') && strcmp(get(o,'Title'),'Spectral flux') && ... %%%%%%%%%%%%%%%
        %                 ischar(postoption.sgate) && ~isempty(postoption.sgate)
        %             if postoption.median
        %                 o = mirflux(o,'Median',postoption.median(1),postoption.median(2),...
        %                     'Halfwave',postoption.hw);
        %             else
        %                 o = mirflux(o,'Halfwave',postoption.hw);
        %             end
        %         elseif isa(o,'mirscalar') && strcmp(get(o,'Title'),'Novelty')  %%%%%%%%%%%%%%%
        %             if postoption.diff
        %                 o = mirenvelope(o,'Diff',postoption.diff,...
        %                     'Lambda',postoption.lambda,...
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
    if ischar(option.presel) && strcmpi(option.presel,'Klapuri99')
        % o, already computed, corresponds to mirenvelope(o,'Mu','HalfwaveDiff');
        % o is the relative distance function W in (Klapuri, 99);
        o2 = sig.envelope(o2,'HalfwaveDiff');
        % o2 is the absolute distance function D in (Klapuri, 99);
        p = sig.peaks(o,'Contrast',.2,'Chrono');
        p2 = sig.peaks(o2,'ScanForward',p,'Chrono');
        o = combinepeaks(p,p2,.05);
        clear o2 p p2
        filtfreq = 44*[2.^ ([ 0:2, ( 9+(0:17) )/3 ]) ];% Center frequencies of bands
        o = sig.sum(o,'Weights',(filtfreq(1:end-1)+filtfreq(2:end))/2);
        o = sig.envelope(o,'Smooth',12);
    end
    if option.c || (ischar(option.sgate) && ~isempty(option.sgate))
        o = sig.envelope(o,'Center');
    end
    if isa(o,'sig.Envelope') && option.minlog
        o = sig.envelope(o,'MinLog',option.minlog);
    end
    o = sig.frame(o,option.frame);
    if ischar(option.detect)
        if isnan(option.cthr) || not(option.cthr)
            if ischar(option.attack) || option.decay
                option.cthr = .05;
            elseif ischar(option.detect) || option.detect
                option.cthr = .01;
            end
        elseif option.cthr
            if not(ischar(option.detect) || option.detect)
                option.detect = 'Peaks';
            end
        end
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
%         o.attacks = nop;
%         o.decays = nop;
    end
    if ischar(option.attack) || option.decay
%         pp = get(o,'PeakPos');
%         d = get(o,'Data');
%         t = get(o,'Time');
%         if ischar(postoption.attack)
%             x = postoption.new;
%             ppu = get(o,'PeakPosUnit');
%             if isnumeric(x)
%                 st = {{{}}};
%                 ap = {{{}}};
%             else
%                 v = mirpeaks(x,'Total',Inf,'SelectFirst',0,...
%                     'Contrast',.1,...postoption.cthr,...
%                     'Threshold',.5,...
%                     'Valleys','Order','Abscissa','NoEnd');
%                 stu = get(v,'PeakPosUnit');
%                 [st,ap] = mircompute(@startattack,d,t,pp,ppu,stu,postoption);
%             end
%         else
%             st = {{{}}};
%             ap = {{{}}};
%         end
%         if postoption.decay
%             x = postoption.new;
%             ppu = get(o,'PeakPosUnit');
%             if isnumeric(x)
%                 rl = {{{}}};
%                 en = {{{}}};
%             else
%                 v = mirpeaks(x,'Total',Inf,'SelectFirst',0,...
%                     'Contrast',.1,...postoption.cthr,
%                     'Threshold',.5,...
%                     'Valleys','Order','Abscissa','NoBegin');
%                 rlu = get(v,'PeakPosUnit');
%                 [rl,en] = mircompute(@enddecay,d,t,pp,ppu,rlu);
%             end
%         else
%             rl = {{{}}};
%             en = {{{}}};
%         end
%         o = set(o,'OnsetPos',st,'AttackPos',ap,'DecayPos',rl,'OffsetPos',en,'PeakPos',pp);
    end
    title = o.yname;
    if not(length(title)>11 && strcmp(title(1:11),'Onset curve'))
        o.yname = ['Onset curve (',title,')'];
    end
    out = {o};
end


function x = after(x,option)
end



%%
function [st pp] = startattack(d,t,pp,ppu,stu,option)
    pp = sort(pp{1});
    ppu = sort(ppu{1});
    if isempty(pp)
        st = {{} {}};
        return
    end

    stu = stu{1};
    if ~isempty(stu) && stu(1)>ppu(1)
        stu = [t(1) stu];
    end
    st = zeros(1,length(stu));

    i = 0;
    while i < length(stu)
        if length(ppu) == i
            break
        end
        i = i+1;

        % Removing additional peaks before current onset time stu(i)
        j = find(ppu(i:end) > stu(i),1);
        if j > 1
            ppu(i:i+j-2) = [];
            pp(i:i+j-2) = [];
        end

        % Taking the latest possible onset time before current peak ppu(i)
        j = find(stu(i:end) > ppu(i),1);
        if j > 2
            st(i:i+j-3) = [];
            stu(i:i+j-3) = [];
        end

        st(i) = find(t >= stu(i),1);

        while true
            dd = diff(d(st(i):pp(i)));
            f0 = find(dd > 0,1);
            if isempty(f0)
                pp(i) = [];
                ppu(i) = [];
            else
                break
            end
        end
        st(i) = st(i) + f0 - 1;

        if strcmpi(option.attack,'Derivate')
            dd = diff(d(st(i):pp(i)));
            f0 = find(dd < 0 & d(st(i):pp(i)-1) < d(st(i)));
            if ~isempty(f0)
                st(i) = st(i) + f0(end) - 1;
            end

            ppi = find(t >= ppu(i),1);
            dd = diff(d(st(i):pp(i)));
            f0 = find(dd <= 0 & ...
                      d(st(i):pp(i)-1) - d(st(i)) > (d(ppi) - d(st(i))) / 5 ...
                      ,1);
            if ~isempty(f0)
                pp(i) = st(i) + f0 - 1;
            end

            dd = diff(d(st(i):pp(i)));
            [mad, mdd] = max(dd);

            f2 = find(dd(end:-1:mdd+1)>mad/5,1);
            if isempty(f2)
                f2 = 1;
            end
            pp(i) = st(i) + length(dd) - f2;

            f1 = find(dd(1:mdd-1)>mad/10,1);
            if isempty(f1)
                f1 = 1;
            end
            st(i) = st(i) + f1;
        elseif strcmpi(option.attack,'Effort')
            % from Timbre Toolbox
            f_Env_v = d(st(i):pp(i));
            f_EnvMax = max(f_Env_v);
            f_Env_v = f_Env_v /f_EnvMax; % normalize by maximum value

            % === calcul de la pos pour chaque seuil
            percent_step	= 0.1;
            percent_value_v = percent_step:percent_step:1;
            percent_posn_v	= zeros(size(percent_value_v));
            for p=1:length(percent_value_v)
                percent_posn_v(p) = find(f_Env_v >= percent_value_v(p),1);
            end

            % === NOTATION
            % satt: start attack
            % eatt: end attack

            % === PARAMETRES
            param.m1	= 3; % === BORNES pour calcul mean
            param.m2	= 6;

            param.s1att	= 1; % === BORNES pour correction satt (start attack)
            param.s2att	= 3;

            param.e1att	= round(0.5/percent_step); % === BORNES pour correction eatt (end attack)
            param.e2att	= round(0.9/percent_step);

            % === dpercent_posn_v = effort
            dpercent_posn_v	= diff(percent_posn_v);
            % === M = effort moyen
            M				= mean(dpercent_posn_v(param.m1:param.m2));

            % === 1) START ATTACK
            % === on DEMARRE juste APRES que l'effort ? fournir (?cart temporal entre percent) soit trop important
            pos2_v			= find(dpercent_posn_v(param.s1att:param.s2att) > option.alpha * M);
            if ~isempty(pos2_v)
                result		= pos2_v(end)+param.s1att-1+1;
            else
                result		= param.s1att;
            end
            satt_posn		= percent_posn_v(result);

            % === raffinement: on cherche le minimum local
            delta	= round(0.25*(percent_posn_v(result+1)-percent_posn_v(result)));
            n		= percent_posn_v(result);
            if n-delta >= 1
                [min_value, min_pos]= min(f_Env_v(n-delta:n+delta));
                satt_posn			= min_pos + n-delta-1;
            end

            % === 2) END ATTACK
            % === on ARRETE juste AVANT que l'effort ? fournir (?cart temporal entre percent) soit trop important
            pos2_v		= find(dpercent_posn_v(param.e1att:param.e2att) > option.alpha * M);
            if ~isempty(pos2_v)
                result		= pos2_v(1)+param.e1att-1;
            else
                result		= param.e2att+1;
            end
            eatt_posn	= percent_posn_v(result);

            % === raffinement: on cherche le maximum local
            delta	= round(0.25*(percent_posn_v(result)-percent_posn_v(result-1)));
            n		= percent_posn_v(result);
            if n+delta <= length(f_Env_v)
                [max_value, max_pos]	= max(f_Env_v(n-delta:n+delta));
                eatt_posn				= max_pos + n-delta-1;
            end
            pp(i) = st(i) + eatt_posn;
            st(i) = st(i) + satt_posn;
        end
    end
    pp(length(st)+1:end) = [];
    st = {{st} {pp}};
end


%%
function [pp en] = enddecay(d,t,pp,ppu,rlu)
    pp = sort(pp{1});
    ppu = sort(ppu{1});
    if isempty(pp)
        en = {{} {}};
        return
    end

    rlu = rlu{1};
    if ~isempty(rlu) && rlu(end)<ppu(end)
        rlu = [rlu t(end)];
    end
    en = zeros(1,length(rlu));

    i = 0;
    while i < length(rlu)
        if length(ppu) == i
            break
        end
        i = i+1;

         % Removing additional offset times before current peak ppu(i)
        j = find(rlu(i:end) > ppu(i),1);
        if j > 1
            rlu(i:i+j-2) = [];
            en(i:i+j-2) = [];
        end

        % Taking the latest possible peak before current offset time rlu(i)
        j = find(ppu(i:end) > rlu(i),1);
        if j > 2
            pp(i:i+j-3) = [];
            ppu(i:i+j-3) = [];
        end

        en(i) = find(t <= rlu(i),1,'last');

        stop = 0;
        while true
            if pp(i) >= en(i)
                stop = 1;
                break
            end
            dd = diff(d(en(i):-1:pp(i)));
            f0 = find(dd > 0,1);
            if isempty(f0)
                pp(i) = [];
                ppu(i) = [];
            else
                break
            end
        end
        if stop
            continue
        end
        en(i) = en(i) - f0 + 1;

        dd = diff(d(en(i):-1:pp(i)));
        f0 = find(dd < 0 & d(en(i):-1:pp(i)+1) < d(en(i)));
        if ~isempty(f0)
            en(i) = en(i) - f0(end) + 1;
        end

        ppi = find(t >= ppu(i),1);
        dd = diff(d(en(i):-1:pp(i)));
        f0 = find(dd <= 0 & ...
                  d(en(i):-1:pp(i)+1) - d(en(i)) > (d(ppi) - d(en(i))) / 5 ...
                  ,1);
        if ~isempty(f0)
            pp(i) = en(i) - f0 + 1;
        end

        dd = diff(d(en(i):-1:pp(i)));
        [mad, mdd] = max(dd);

        f2 = find(dd(end:-1:mdd+1)>mad/5,1);
        if isempty(f2)
            f2 = 1;
        end
        pp(i) = en(i) - length(dd) + f2;

        f1 = find(dd(1:mdd-1)>mad/10,1);
        if isempty(f1)
            f1 = 1;
        end
        en(i) = en(i) - f1;
    end
    pp(length(en)+1:end) = [];

    pp = {{pp} {en}};
end


function out = symbolic(x,option)
    % Code adapted from onsetacorr.m and duraccent.m in MIDItoolbox
    % NDIVS = divisions in Hz (default = 4);
    ndivs = 10;
    tau=0.5;
    accent_index=2;
    l = length(x.content);
    if l == 0
        g = [];
    else
        on = zeros(1,l);
        dur = zeros(1,l);
        for i = 1:l
            on(i) = x.content{i}.parameter.getfield('onset').value;
            dur(i) = x.content{i}.parameter.getfield('offset').value - on(i);
        end
        d = (1-exp(-dur/tau)).^accent_index; % duration accent by Parncutt (1994)
        vlen = ndivs*(ceil(on(end))+1);
        g = zeros(vlen,1);
        ind = mod(round(on*ndivs),vlen)+1;
        for k=1:length(ind)
            g(ind(k)) = g(ind(k))+d(k);
        end
    end
    %%
    d = sig.data(g,{'sample'});
    out = sig.Envelope(d,'Srate',ndivs,'Sstart',0,'Ssize',length(g));
    out = {sig.framenow(out,option.frame)};
end