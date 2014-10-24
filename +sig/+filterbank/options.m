% SIG.FILTERBANK.MAIN
% Options related to sig.filterbank, also called by aud.filterbank
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function options = options
    options = sig.signal.signaloptions();

        nCh.key = 'NbChannels';
        nCh.type = 'Integer';
        nCh.default = Inf;
    options.nCh = nCh;
    
        Ch.key = {'Channel','Channels'};
        Ch.type = 'Integer';
        Ch.default = 0;
    options.Ch = Ch;
    
        freq.key = 'CutOff';
        freq.type = 'Integer';
        freq.default = [-Inf 1000 Inf];
    options.freq = freq;
    
        overlap.key = 'Hop';
        overlap.type = 'Boolean';
        overlap.default = 1;
    options.overlap = overlap;

        filterorder.key = 'Order';
        filterorder.type = 'Integer';
        filterorder.default = 4;
    options.filterorder = filterorder;
end