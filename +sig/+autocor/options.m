% SIG.AUTOCOR.OPTIONS
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function options = options    
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);

        min.key = 'Min';
        min.type = 'Unit';
        min.unit = {'s','Hz'};
        min.default = [];
        min.opposite = 'max';
        min.when = 'Both';
    options.min = min;
        
        max.key = 'Max';
        max.type = 'Unit';
        max.unit = {'s','Hz'};
        max.default = [];
        max.opposite = 'min';
        max.when = 'Both';
    options.max = max;
        
        scaleopt.type = 'String';
        scaleopt.choice = {'biased','unbiased','coeff','none','coeffXchannels'};
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
        normwin.default = '';
        normwin.keydefault = 'On';
    options.normwin = normwin;
end