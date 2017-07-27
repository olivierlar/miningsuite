% SIG.SPECTRUM.OPTIONS
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function options = options
    options = sig.signal.signaloptions('FrameAuto',.05,.5);
    
        win.key = 'Window';
        win.type = 'String';
        win.default = 'hamming';
    options.win = win;
    
        min.key = 'Min';
        min.type = 'Numeric';
        min.default = 0;
        min.when = 'Both';
    options.min = min;
    
        max.key = 'Max';
        max.type = 'Numeric';
        max.default = Inf;
        max.when = 'Both';
    options.max = max;
    
        mr.key = 'MinRes';
        mr.type = 'Numeric';
        mr.default = 0;
    options.mr = mr;

        res.key = 'Res';
        res.type = 'Numeric';
        res.default = NaN;
    options.res = res;

        length.key = 'Length';
        length.type = 'Numeric';
        length.default = NaN;
    options.length = length;
    
        zp.key = 'ZeroPad';
        zp.type = 'Numeric';
        zp.default = 0;
        zp.keydefault = Inf;
    options.zp = zp;
    
        wr.key = 'WarningRes';
        wr.type = 'Numeric';
        wr.default = 0;
    options.wr = wr;
    
        octave.key = 'OctaveRatio';
        octave.type = 'Boolean';
        octave.default = 0;
    options.octave = octave;
    
        constq.key = 'ConstantQ';
        constq.type = 'Numeric';
        constq.default = 0;
        constq.keydefault = 12;
    options.constq = constq;
    
        alongbands.key = 'AlongBands';
        alongbands.type = 'Boolean';
        alongbands.default = 0;
    options.alongbands = alongbands;

        ni.key = 'NormalInput';
        ni.type = 'Boolean';
        ni.default = 0;
    options.ni = ni;
    
        nl.key = 'NormalLength';
        nl.type = 'Boolean';
        nl.default = 0;
        nl.when = 'After';
    options.nl = nl;
    
        norm.key = 'Normal';
        norm.type = 'Numeric';
        norm.default = 0;
        norm.keydefault = 1;
        norm.when = 'After';
    options.norm = norm;

        mprod.key = 'Prod';
        mprod.type = 'Integers';
        mprod.default = [];
        mprod.keydefault = 2:6;
        mprod.when = 'After';
    options.mprod = mprod;

        msum.key = 'Sum';
        msum.type = 'Integers';
        msum.default = [];
        msum.keydefault = 2:6;
        msum.when = 'After';
    options.msum = msum;
    
        log.key = 'log';
        log.type = 'Boolean';
        log.default = 0;
        log.when = 'After';
    options.log = log;

        db.key = 'dB';
        db.type = 'Numeric';
        db.default = 0;
        db.keydefault = Inf;
        db.when = 'After';
    options.db = db;
    
        pow.key = 'Power';
        pow.type = 'Boolean';
        pow.default = 0;
        pow.when = 'After';
    options.pow = pow;

    %    e.key = 'Enhanced';
    %    e.type = 'Numeric';
    %    e.default = [];
    %    e.keydefault = 2:10;
    %    e.when = 'After';
    %option.e = e;

        collapsed.key = 'Collapsed';
        collapsed.type = 'Boolean';
        collapsed.default = 0;
        collapsed.when = 'Both';
    options.collapsed = collapsed;
    
        aver.key = 'Smooth';
        aver.type = 'Numeric';
        aver.default = 0;
        aver.keydefault = 10;
        aver.when = 'After';
    options.aver = aver;
    
        gauss.key = 'Gauss';
        gauss.type = 'Numeric';
        gauss.default = 0;
        gauss.keydefault = 10;
        gauss.when = 'After';
    options.gauss = gauss;

        timesmooth.key = 'TimeSmooth';
        timesmooth.type = 'Numeric';
        timesmooth.default = 0;
        timesmooth.keydefault = 10;
        timesmooth.when = 'After';
    options.timesmooth = timesmooth;
    
        rapid.key = 'Rapid';
        rapid.type = 'Boolean';
        rapid.default = 0;
    options.rapid = rapid;

        phase.key = 'Phase';
        phase.type = 'Boolean';
        phase.default = 1;
    options.phase = phase;
end