% SIG.PLAYFILE
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

function playfile(synth,d,name,rate,varargin)

if iscell(name)
    name = name{1};
end
display(['Playing file: ' name]);

d = synth(d,varargin{:});

tic
sound(d,rate);
idealtime = length(d)/rate;
practime = toc;
if practime < idealtime
    pause(idealtime-practime)
end