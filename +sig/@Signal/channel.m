% SIG.SIGNAL.CHANNEL
%
% Copyright (C) 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [obj,channels] = channel(obj,param,keyword,channels)
    if nargin < 3
        keyword = 'channel';
    end
    if nargin < 4
        channels = [];
    end
    [obj.Ydata,channels] = sig.compute(@main,obj.Ydata,param,keyword,channels);
end
    
   
function out = main(d,param,keyword,channels)
    d = d.extract(keyword,param);
    if ~isempty(channels)
        channels = channels(param);
    end
    out = {d,channels};
end