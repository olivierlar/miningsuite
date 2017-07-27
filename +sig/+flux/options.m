% SIG.FLUX.OPTIONS
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function options = options    
    options = sig.signal.signaloptions('FrameAuto',.05,.5);

        dist.key = 'Dist';
        dist.type = 'String';
        dist.default = 'Euclidean';
    options.dist = dist;
    
        inc.key = 'Inc';
        inc.type = 'Boolean';
        inc.default = 0;
    options.inc = inc;

        bs.key = 'BackSmooth';
        bs.type = 'String';
        bs.choice = {'Goto','Lartillot'};
        bs.default = '';
        bs.keydefault = 'Goto';
    options.bs = bs;
    
        complex.key = 'Complex';
        complex.type = 'Boolean';
        complex.default = 0;
    options.complex = complex;
    
        gap.key = 'Gaps';
        gap.type = 'Integer';
        gap.default = 0;
        gap.keydefault = .2;
    options.gap = gap;
        
        h.key = 'Halfwave';
        h.type = 'Boolean';
        h.default = 0;
        h.when = 'After';
    options.h = h;
    
        median.key = 'Median';
        median.type = 'Integer';
        median.number = 2;
        median.default = [0 0];
        median.keydefault = [.2 1.3];
        median.when = 'After';
    options.median = median;
end