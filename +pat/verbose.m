% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function v = verbose(b)

persistent verbose

if nargin
    if not(isnumeric(b))
        error('ERROR IN PAT.VERBOSE: The argument should be a number.')
    end
    verbose = b;
else
    if isempty(verbose)
        verbose = 0;
    end
end

v = verbose;