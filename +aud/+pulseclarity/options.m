function options = options
    options = sig.signal.signaloptions('FrameManual',5,.1);
    
        model.key = 'Model';
        model.type = 'Integer';
        model.default = 0;
    options.model = model;

        stratg.type = 'String';
        stratg.choice = {'MaxAutocor','MinAutocor','MeanPeaksAutocor',...
                         'KurtosisAutocor','EntropyAutocor',...
                         'InterfAutocor','TempoAutocor','ExtremEnvelop',...
                         'Attack','Articulation'};    ...,'AttackDiff'
        stratg.default = 'MaxAutocor';
    options.stratg = stratg;
        
%% options related to aud.events:  

        fea.type = 'String';
        fea.choice = {'Envelope','DiffEnvelope','SpectralFlux','Pitch'};
        fea.default = 'Envelope';
    options.fea = fea;
    
    
    %% options related to 'Envelope':
    
            envmeth.key = 'Method';
            envmeth.type = 'String';
            envmeth.choice = {'Filter','Spectro'};
            envmeth.default = 'Spectro';
        options.envmeth = envmeth;

            %% options related to 'Filter':

                ftype.key = 'FilterType';
                ftype.type = 'String';
                ftype.choice = {'IIR','HalfHann'};
                ftype.default = 'IIR';
            options.ftype = ftype;

                fb.key = 'Filterbank';
                fb.type = 'Integer';
                fb.default = 20;
            options.fb = fb;

                fbtype.key = 'FilterbankType';
                fbtype.type = 'String';
                fbtype.choice = {'Gammatone','Scheirer','Klapuri'};
                fbtype.default = 'Scheirer';
            options.fbtype = fbtype;

            %% options related to 'Spectro':

                band.type = 'String';
                band.choice = {'Freq','Mel','Bark','Cents'};
                band.default = 'Freq';
            options.band = band;


            diffhwr.key = 'HalfwaveDiff';
            diffhwr.type = 'Integer';
            diffhwr.default = 0;
            diffhwr.keydefault = 1;
        options.diffhwr = diffhwr;

            lambda.key = 'Lambda';
            lambda.type = 'Integer';
            lambda.default = 1;
        options.lambda = lambda;

            aver.key = 'Smooth';
            aver.type = 'Integer';
            aver.default = 0;
            aver.keydefault = 30;
        options.aver = aver;

            oplog.key = 'Log';
            oplog.type = 'Boolean';
            oplog.default = 0;
        options.log = oplog;
        
            mu.key = 'Mu';
            mu.type = 'Integer';
            mu.default = 100;
        options.mu = mu;

    %% options related to 'SpectralFlux'
    
            inc.key = 'Inc';
            inc.type = 'Boolean';
            inc.default = 1;
        options.inc = inc;

            median.key = 'Median';
            median.type = 'Integer';
            median.number = 2;
            median.default = [0 0]; % Not same default as in mirtempo
        options.median = median;

            hw.key = 'Halfwave';
            hw.type = 'Boolean';
            hw.default = 0; %NaN; %0; % Not same default as in mirtempo
        options.hw = hw;    
        
    
%% options related to aud.attackslope
        slope.type = 'String';
        slope.choice = {'Diff','Gauss'};
        slope.default = 'Diff';
    options.slope = slope;
    
%% options related to sig.autocor:    
    
        enh.key = 'Enhanced';
        enh.type = 'Integers';
        enh.default = [];
        enh.keydefault = 2:10;
    options.enh = enh;
        
        mi.key = 'Min';
        mi.type = 'Integer';
        mi.default = 40;
    options.mi = mi;
        
        ma.key = 'Max';
        ma.type = 'Integer';
        ma.default = 200;
    options.ma = ma;    

%% options related to aud.tempo:

        sum.key = 'Sum';
        sum.type = 'String';
        sum.choice = {'Before','After','Adjacent'};
        sum.default = 'Before';
    options.sum = sum;
    
        m.key = 'Total';
        m.type = 'Integer';
        m.default = 1;
    options.m = m;
        
        thr.key = 'Contrast';
        thr.type = 'Integer';
        thr.default = 0.01; % Not same default as in aud.tempo
    options.thr = thr;
end