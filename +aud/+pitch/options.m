% AUD.PITCH.OPTIONS
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function options = options
    options = sig.Signal.signaloptions('FrameManual',.0464,.2);
   
        ac.key = 'Autocor';
        ac.type = 'Boolean';
        ac.default = 0;
    options.ac = ac;
    
            enh.key = 'Enhanced';
            enh.type = 'Numeric';
            enh.default = 2:10;
        options.enh = enh;

            filtertype.type = 'String';
            filtertype.choice = {'NoFilterBank','2Channels','Gammatone'};
            filtertype.default = '2Channels';
        options.filtertype = filtertype;

            sum.key = 'Sum';
            sum.type = 'Boolean';
            sum.default = 1;
        options.sum = sum;

            gener.key = {'Generalized','Compress'};
            gener.type = 'Numeric';
            gener.default = .5;
        options.gener = gener;
        
        as.key = 'AutocorSpectrum';
        as.type = 'Boolean';
        as.default = 0;
    options.as = as;
        
        s.key = 'Spectrum';
        s.type = 'Boolean';
        s.default = 0;
    options.s = s;

            res.key = 'Res';
            res.type = 'Numeric';
            res.default = NaN;
        options.res = res;
  
            db.key = 'dB';
            db.type = 'Numeric';
            db.default = 0;
            db.keydefault = Inf;
        options.db = db;
    
            norm.key = 'Normal';
            norm.type = 'Boolean';
            norm.default = 0;
        options.norm = norm;
    
        ce.key = 'Cepstrum';
        ce.type = 'Boolean';
        ce.default = 0;
    options.ce = ce;    
%%
        total.key = 'Total';
        total.type = 'Numeric';
        total.default = Inf;
    options.total = total;
    
        multi.key = 'Multi';
        multi.type = 'Boolean';
        multi.default = 0;
    options.multi = multi;

        mono.key = 'Mono';
        mono.type = 'Boolean';
        mono.default = 0;
    options.mono = mono;

        mi.key = 'Min';
        mi.type = 'Numeric';
        mi.default = 75;
    options.mi = mi;
        
        ma.key = 'Max';
        ma.type = 'Numeric';
        ma.default = 2400;
    options.ma = ma;
        
        cthr.key = 'Contrast';
        cthr.type = 'Numeric';
        cthr.default = .1;
    options.cthr = cthr;

        thr.key = 'Threshold';
        thr.type = 'Numeric';
        thr.default = .4;
    options.thr = thr;

        order.key = 'Order';
        order.type = 'String';
        order.choice = {'Amplitude','Abscissa'};
        order.default = 'Amplitude';
    options.order = order;    

        reso.key = 'Reso';
        reso.type = 'String';
        reso.choice = {0,'SemiTone'};
        reso.default = 0;
    options.reso = reso;
        
        track.key = 'Track';        % Not used yet
        track.type = 'Boolean';
        track.default = 0;
    options.track = track;
    
    %% preset model

        tolo.key = 'Tolonen';
        tolo.type = 'Boolean';
        tolo.default = 0;
    options.tolo = tolo;
end