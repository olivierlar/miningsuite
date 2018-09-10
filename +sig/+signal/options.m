% SIG.SIGNAL.OPTIONS
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function options = options
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    
        center.key = 'Center';
        center.type = 'Boolean';
        center.default = sig.Signal.default.Center;
    options.center = center;

%        normal.key = 'Normal';
%        normal.type = 'Boolean';
%        normal.default = 0;
%    options.normal = normal;
    
       channel.key = {'Channel','Channels'};
       channel.type = 'Numeric';
       channel.default = [];
    options.channel = channel;
    
       freqband.key = {'FreqBand','FreqBands'};
       freqband.type = 'Numeric';
       freqband.default = [];
    options.freqband = freqband;
    
        sampling.key = 'Sampling';
        sampling.type = 'Numeric';
    options.sampling = sampling;

        extract.key = {'Extract','Excerpt'};
        extract.type = 'Unit';
        extract.number = 2;
        extract.default = [];
        extract.unit = {'s','sp'};
    options.extract = extract;
    
        trim.key = {'Trim'};
        trim.type = 'Boolean';
        trim.default = 0;
    options.trim = trim;
    
        trimwhere.type = 'String';
        trimwhere.choice = {'JustStart','JustEnd','BothEnds'};
        trimwhere.default = 'BothEnds';
    options.trimwhere = trimwhere;
    
        trimthreshold.key = 'TrimThreshold';
        trimthreshold.type = 'Numeric';
        trimthreshold.default = .06;
    options.trimthreshold = trimthreshold;
    
        fwr.key = 'FWR';
        fwr.type = 'Boolean';
        fwr.default = 0;
    options.fwr = fwr;
end