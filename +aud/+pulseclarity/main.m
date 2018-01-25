% AUD.PULSECLARITY.MAIN
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(in,option)
    x = in{2};
    if option.model == 2
        option.stratg = 'InterfAutocor';
    end
    if option.m == 1 && ...
            (strcmpi(option.stratg,'InterfAutocor') || ...
             strcmpi(option.stratg,'MeanPeaksAutocor'))
        option.m = Inf;
    end
    if strcmpi(option.stratg,'MaxAutocor')
        d = sig.compute(@max,x.Ydata);
        pc = sig.Signal(d,'Name','Pulse Clarity','Srate',in{1}.Srate,'FbChannels',in{1}.fbchannels);
        out = {pc x};
    else
        error('ERROR IN AUD.PULSECLARITY: Sorry, heuristics not implemented yet.');
    end
end