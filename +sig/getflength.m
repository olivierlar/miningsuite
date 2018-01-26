% SIG.GETFLENGTH
%
% Copyright (C) 2018, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function l = getflength(sr,param)
    if strcmpi(param.fsize.unit,'s')
        l = param.fsize.value;
    elseif strcmpi(param.fsize.unit,'sp')
        l = param.fsize.value/sr;
    end
end