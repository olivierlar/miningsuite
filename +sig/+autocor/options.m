function options = options    
    options = sig.signal.signaloptions(.05,.5);

        min.key = 'Min';
        min.type = 'Unit';
        min.unit = {'s','Hz'};
        %min.defaultunit = 's';
        min.default = [];
        min.opposite = 'max';
        min.when = 'Both';
    options.min = min;
        
        max.key = 'Max';
        max.type = 'Unit';
        max.unit = {'s','Hz'};
        %max.defaultunit = 's';
        max.default = [];
        max.opposite = 'min';
        max.when = 'Both';
    options.max = max;
        
        scaleopt.type = 'String';
        scaleopt.choice = {'biased','unbiased','coeff','none'};
        scaleopt.default = 'coeff';
    options.scaleopt = scaleopt;
            
        gener.key = {'Generalized','Compres'};
        gener.type = 'Numeric';
        gener.default = 2;
        gener.keydefault = .67;
    options.gener = gener;

        hwr.key = 'Halfwave';
        hwr.type = 'Boolean';
        hwr.when = 'After';
        hwr.default = 0;
    options.hwr = hwr;
        
        enhance.key = 'Enhanced';
        enhance.type = 'Numeric';
        enhance.default = [];
        enhance.keydefault = 1;
        enhance.when = 'After';
    options.enhance = enhance;
        
        freq.key = 'Freq';
        freq.type = 'Boolean';
        freq.default = 0;
        freq.when = 'Both';
    options.freq = freq;
        
        win.key = 'Window';
        win.type = 'String';
        win.default = NaN;
    options.win = win;

        normwin.key = 'NormalWindow';
        normwin.when = 'Both';
        normwin.default = 'hanning';
    options.normwin = normwin;
end