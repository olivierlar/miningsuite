% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function obj = creatememory(param,pattern)
    if isa(param,'seq.paramstruct') || isa(param,'pat.memostruct')
        obj = pat.memostruct(param,pattern);
    else
        obj = pat.memoparam(param,pattern);
    end
end