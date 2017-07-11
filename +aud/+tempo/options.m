function options = options
    options = sig.signal.signaloptions('FrameManual',3,.1);
    
        sum.key = 'Sum';
        sum.type = 'String';
        sum.choice = {'Before','After','Adjacent',0};
        sum.default = 'Before';
    options.sum = sum;
        
%% options related to mironsets:    
    
        fea.type = 'String';
        fea.choice = {'Envelope','DiffEnvelope','SpectralFlux',...
                      'Pitch','Novelty'};
        fea.default = 'Envelope';
    options.fea = fea;
    
    %% options related to 'Envelope':
    
            envmeth.key = 'Method';
            envmeth.type = 'String';
            envmeth.choice = {'Filter','Spectro'};
            envmeth.default = 'Filter';
        options.envmeth = envmeth;
    
        %% options related to 'Filter':

                fb.key = 'Filterbank';
                fb.type = 'Numeric';
                fb.default = 10;
            options.fb = fb;

                fbtype.key = 'FilterbankType';
                fbtype.type = 'String';
                fbtype.choice = {'Gammatone','Scheirer','Klapuri'};
                fbtype.default = 'Gammatone';
            options.fbtype = fbtype;

                ftype.key = 'FilterType';
                ftype.type = 'String';
                ftype.choice = {'IIR','HalfHann'};
                ftype.default = 'IIR';
            options.ftype = ftype;

        %% options related to 'Spectro':
        
                band.type = 'String';
                band.choice = {'Freq','Mel','Bark','Cents'};
                band.default = 'Freq';
            options.band = band;

        
            chwr.key = 'HalfwaveCenter';
            chwr.type = 'Boolean';
            chwr.default = 0;
        options.chwr = chwr;

            diff.key = 'Diff';
            diff.type = 'Boolean';
            diff.default = 1; % Different default for mirtempo
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

            mu.key = 'Mu'; 
            mu.type = 'Numeric'; 
            mu.default = 0; 
	        options.mu = mu; 
        
            log.key = 'Log';
            log.type = 'Boolean';
            log.default = 0;
        options.log = log;

            c.key = 'Center';
            c.type = 'Boolean';
            c.default = 0;
        options.c = c;

            aver.key = 'Smooth';
            aver.type = 'Numeric';
            aver.default = 0;
            aver.keydefault = 30;
        options.aver = aver;

            sampling.key = 'Sampling';
            sampling.type = 'Numeric';
            sampling.default = 0;
        options.sampling = sampling;

    %% options related to 'SpectralFlux'
    
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
        
        
%% options related to mirautocor:    

        aut.key = 'Autocor';
        aut.type = 'Numeric';
        aut.default = 0;
        aut.keydefault = 1;
    options.aut = aut;            
    
        nw.key = 'NormalWindow';
        nw.default = 0;
    options.nw = nw;

        enh.key = 'Enhanced';
        enh.type = 'Integers';
        enh.default = 2:10;
        enh.keydefault = 2:10;
    options.enh = enh;

        r.key = 'Resonance';
        r.type = 'String';
        r.choice = {'ToiviainenSnyder','vanNoorden',0,'off','no','New'};
        r.default = 'ToiviainenSnyder';
    options.r = r;
    
        phase.key = 'Phase';
        phase.type = 'Boolean';
        phase.default = 0;
    options.phase = phase;

%% options related to mirspectrum:
    
        spe.key = 'Spectrum';
        spe.type = 'Numeric';
        spe.default = 0;
        spe.keydefault = 1;
    options.spe = spe;

        zp.key = 'ZeroPad';
        zp.type = 'Numeric';
        zp.default = 10000;
        zp.keydefault = Inf;
    options.zp = zp;
    
        prod.key = 'Prod';
        prod.type = 'Numeric';
        prod.default = 0;
        prod.keydefault = 2:6;
    options.prod = prod;

    
%% options related to the peak detection

        m.key = 'Total';
        m.type = 'Numeric';
        m.default = 1;
    options.m = m;
        
        thr.key = 'Threshold';
        thr.type = 'Numeric';
        thr.default = 0;
    options.thr = thr;
    
        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = 0.1;
    options.cthr = cthr;

        mi.key = 'Min';
        mi.type = 'Numeric';
        mi.default = 40;
    options.mi = mi;
        
        ma.key = 'Max';
        ma.type = 'Numeric';
        ma.default = 200;
    options.ma = ma;

        track.key = 'Track';
        track.type = 'Numeric';
        track.keydefault = .1;
        track.default = 0;
    options.track = track;

        mem.key = 'TrackMem';
        mem.type = 'Numeric';
        mem.default = 0;
        mem.keydefault = Inf;
    options.mem = mem;

        fuse.key = 'Fuse';
        fuse.type = 'Boolean';
        fuse.default = 0;
    options.fuse = fuse;

        pref.key = 'Pref';
        pref.type = 'Numeric';
        pref.number = 2;
        pref.default = [0 .2];
    options.pref = pref;
    
        minres.key = 'MinRes';
        minres.type = 'Numeric';
        minres.default = 1; %.1;
    options.minres = minres;
    
        fill.key = 'Fill';
        fill.type = 'Boolean';
        fill.default = 1;
    options.fill = fill;
    
        mean.key = 'Mean';
        mean.type = 'Boolean';
        mean.default = 0;
    options.mean = mean;
end