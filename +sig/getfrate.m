% SIG.GETFRATE
%
% Copyright (C) 2014, 2018, Olivier Lartillot
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
if strcmpi(param.fhop.unit,'/1') || strcmpi(param.fhop.unit,'%')
    if strcmpi(param.fsize.unit,'s')
        l = param.fsize.value*sr;
    elseif strcmpi(param.fsize.unit,'sp')
        l = param.fsize.value;
    end
    if strcmpi(param.fhop.unit,'/1')
        frate = sr/param.fhop.value/l;
    else
        frate = sr/param.fhop.value/l/.01;
    end
elseif strcmpi(param.fhop.unit,'s')
    frate = 1/param.fhop.value;
elseif strcmpi(param.fhop.unit,'sp')
    frate = sr/param.fhop.value;
elseif strcmpi(param.fhop.unit,'Hz')
    frate = param.fhop.value;
end