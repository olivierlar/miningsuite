function options = options
    options = sig.signal.signaloptions(); %(.1,.1);
    
        method.type = 'String';
        method.choice = {'Filter','Spectro'};
        method.default = 'Filter';
    options.method = method;

%% options related to 'Filter':

        hilb.key = 'Hilbert';
        hilb.type = 'Boolean';
        hilb.default = 0;
    options.hilb = hilb;
 
        decim.key = {'Decim','PreDecim'};
        decim.type = 'Integer';
        decim.default = 0;
    options.decim = decim;
    
        filter.key = 'FilterType';
        filter.type = 'String';
        filter.choice = {'IIR','HalfHann','Butter',0};
        filter.default = 'IIR';
    options.filter = filter;

            %% options related to 'IIR': 
            tau.key = 'Tau';
            tau.type = 'Integer';
            tau.default = .02;
    options.tau = tau;
    
        zp.key = 'ZeroPhase'; % internal use: for manual filtfilt
        zp.type = 'Number';
        if 1 %isamir(orig,'mirenvelope')
            zp.default = NaN;
        else
            zp.default = NaN;
        end
    options.zp = zp;

        ds.key = {'Down','PostDecim'};
        ds.type = 'Integer';
        %if isamir(orig,'mirenvelope')
        %    ds.default = 1;
        %else
            ds.default = NaN; % 0 if 'PreDecim' is used, else 16
        %end
        ds.when = 'After';
        ds.chunkcombine = 'During';
    options.ds = ds;

        trim.key = 'Trim';
        trim.type = 'Boolean';
        trim.default = 0;
        trim.when = 'After';
    options.trim = trim;

%% Options related to 'Spectro':

        band.type = 'String';
        band.choice = {'Freq','Mel','Bark','Cents'};
        band.default = 'Freq';
    options.band = band;

        up.key = {'UpSample'};
        up.type = 'Integer';
        up.default = 0;
        up.keydefault = 2;
        up.when = 'After';
    options.up = up;

        complex.key = 'Complex';
        complex.type = 'Boolean';
        complex.default = 0;
        complex.when = 'After';
    options.complex = complex;    

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
    
%% Options related to all methods:
    
        sampling.key = 'Sampling';
        sampling.type = 'Integer';
        sampling.default = 0;
        sampling.when = 'After';
    options.sampling = sampling;

        hwr.key = 'Halfwave';
        hwr.type = 'Boolean';
        hwr.default = 0;
        hwr.when = 'After';
    options.hwr = hwr;

        center.key = 'Center';
        center.type = 'Boolean';
        center.default = 0;
        center.when = 'After';
    options.center = center;
    
        chwr.key = 'HalfwaveCenter';
        chwr.type = 'Boolean';
        chwr.default = 0;
        chwr.when = 'After';
    options.chwr = chwr;
    
        mu.key = 'Mu';
        mu.type = 'Integer';
        mu.default = 0;
        mu.keydefault = 100;
        mu.when = 'After';
    options.mu = mu;
    
        oplog.key = 'Log';
        oplog.type = 'Boolean';
        oplog.default = 0;
        oplog.when = 'After';
    options.log = oplog;

        minlog.key = 'MinLog';
        minlog.type = 'Integer';
        minlog.default = 0;
        minlog.when = 'After';
    options.minlog = minlog;

        oppow.key = 'Power';
        oppow.type = 'Boolean';
        oppow.default = 0;
        oppow.when = 'After';
    options.power = oppow;

        diff.key = 'Diff';
        diff.type = 'Integer';
        diff.default = 0;
        diff.keydefault = 1;
        diff.when = 'After';
    options.diff = diff;
    
        diffhwr.key = 'HalfwaveDiff';
        diffhwr.type = 'Integer';
        diffhwr.default = 0;
        diffhwr.keydefault = 1;
        diffhwr.when = 'After';
    options.diffhwr = diffhwr;

        lambda.key = 'Lambda';
        lambda.type = 'Integer';
        lambda.default = 1;
        lambda.when = 'After';
    options.lambda = lambda;

        aver.key = 'Smooth';
        aver.type = 'Integer';
        aver.default = 0;
        aver.keydefault = 30;
        aver.when = 'After';
    options.aver = aver;
        
        gauss.key = 'Gauss';
        gauss.type = 'Integer';
        gauss.default = 0;
        gauss.keydefault = 30;
        gauss.when = 'After';
    options.gauss = gauss;

   %     iir.key = 'IIR';
   %     iir.type = 'Boolean';
   %     iir.default = 0;
   %     iir.when = 'After';
   % option.iir = iir;

        norm.key = 'Normal';
        norm.type = 'String';
        norm.choice = {0,1,'AcrossSegments'};
        norm.default = 0;
        norm.keydefault = 1;
        norm.when = 'After';
    options.norm = norm;

        presel.type = 'String';
        presel.choice = {'Klapuri06'};
        presel.default = 0;
    options.presel = presel;  
end