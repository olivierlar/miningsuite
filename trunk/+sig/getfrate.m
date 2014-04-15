% SIG.GETFRATE
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function frate = getfrate(sr,param)
if strcmpi(param.hop.unit,'/1') || strcmpi(param.hop.unit,'%')
    if strcmpi(param.size.unit,'s')
        l = param.size.value*sr;
    elseif strcmpi(param.size.unit,'sp')
        l = param.size.value;
    end
    if strcmpi(param.hop.unit,'/1')
        frate = sr/param.hop.value/l;
    else
        frate = sr/param.hop.value/l/.01;
    end
elseif strcmpi(param.hop.unit,'s')
    frate = 1/param.hop.value;
elseif strcmpi(param.hop.unit,'sp')
    frate = sr/param.hop.value;
elseif strcmpi(param.hop.unit,'Hz')
    frate = param.hop.value;
end