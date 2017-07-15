function options = options
    [options,spectroframe] = sig.signal.signaloptions('FrameManual');
    
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
        decim.type = 'Numeric';
        decim.default = 0;
    options.decim = decim;
    
        filter.key = 'FilterType';
        filter.type = 'String';
        filter.choice = {'IIR','HalfHann','Butter',0};
        filter.default = 'IIR';
    options.filter = filter;

            %% options related to 'IIR': 
            tau.key = 'Tau';
            tau.type = 'Numeric';
            tau.default = .02;
    options.tau = tau;

        ds.key = {'Down','PostDecim'};
        ds.type = 'Numeric';
        ds.default = NaN; % 0 if 'PreDecim' is used, else 16
        ds.chunkcombine = 'During';
    options.ds = ds;

%         trim.key = 'Trim';
%         trim.type = 'Boolean';
%         trim.default = 0;
%         trim.when = 'After';
%     options.trim = trim;

%% Options related to 'Spectro':

        band.type = 'String';
        band.choice = {'Freq','Mel','Bark','Cents'};
        band.default = 'Freq';
    options.band = band;

        up.key = {'UpSample'};
        up.type = 'Numeric';
        up.default = 0;
        up.keydefault = 2;
    options.up = up;

        complex.key = 'Complex';
        complex.type = 'Boolean';
        complex.default = 0;
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

        spectroframe.key = 'Frame';
        spectroframe.type = 'Numeric';
        spectroframe.number = 2;
        spectroframe.default = [.1 .1];
    options.spectroframe = spectroframe;
    
%% Options related to all methods:
    
        sampling.key = 'Sampling';
        sampling.type = 'Numeric';
        sampling.default = 0;
    options.sampling = sampling;

        hwr.key = 'Halfwave';
        hwr.type = 'Boolean';
        hwr.default = 0;
    options.hwr = hwr;

        center.key = 'Center';
        center.type = 'Boolean';
        center.default = 0;
    options.center = center;
    
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

        aver.key = 'Smooth';
        aver.type = 'Numeric';
        aver.default = 0;
        aver.keydefault = 30;
    options.aver = aver;
        
        gauss.key = 'Gauss';
        gauss.type = 'Numeric';
        gauss.default = 0;
        gauss.keydefault = 30;
    options.gauss = gauss;

   %     iir.key = 'IIR';
   %     iir.type = 'Boolean';
   %     iir.default = 0;
   % option.iir = iir;

        norm.key = 'Normal';
        %norm.type = 'String';
        norm.choice = {0,1,'AcrossSegments'};
        norm.default = 0;
        norm.keydefault = 1;
    options.norm = norm;

        presel.type = 'String';
        presel.choice = {'Klapuri06'};
        presel.default = 0;
    options.presel = presel;  
end