% SIG.SPREAD.ALGO
%
% Copyright (C) 2017 Olivier Lartillot
% © 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [s,c] = algo(d,f)
    c = sig.centroid.algo(d,f);
    s = sqrt( sum((f'-c).^2 .* (d/sum(d)) ) );
end