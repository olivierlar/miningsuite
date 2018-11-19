% PHY.POTENERGY
%
% Copyright (C) 2018 Olivier Lartillot
% Some code from the Motion Capture Toolbox, Copyright 2008, 
% University of Jyvaskyla, Finland
% Some code taken from the Motion Capture Toolbox, Copyright 2008, 
% University of Jyvaskyla, Finland
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function pe = potenergy(s)
if ~isa(s,'phy.Segment')
    error('Error in phy.potenergy: the input needs to be a phy.Segment object.');
end
if isempty(s.spar)
    error('Error in phy.potenergy: the input phy.Segment object''s segmindex parameter needs to be specified.');
end
d = s.Ydata.content;
N = size(d,1);
M = size(d,2);
pe = zeros(N,M);

if s.diffed
    disp('Use location data');
    return;
end

for k=1:M
    if s.parent(k)>0
        dist = d(:,k,:);
        prox = d(:,s.parent(k),:);
        cog = prox + (dist-prox) * s.spar.comprox(k) / 1000;
        pe(:,k) = 60 * 9.81 * s.spar.m(k) * cog(:,3)/1000;
    end
end

d = sig.data(pe,{'sample','segment'});
pe = sig.Signal(d,'Srate',s.Srate,'Name','Potential Energy');
pe.design.files = s.files;