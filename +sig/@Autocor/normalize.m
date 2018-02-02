% SIG.AUTOCOR.NORMALIZE
%
% Copyright (C) 2014-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = normalize(obj)
    if isempty(obj.window)
        return
    end
    obj.Ydata = sig.compute(@main,obj.Ydata,obj.window);
end


function out = main(d,win)
    if ~isempty(win)
        d = d.divide(win);
    end
    out = {d};
end