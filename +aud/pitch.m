% AUD.PITCH
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = pitch(varargin)
    varargout = sig.operate('aud','pitch',aud.pitch.options,...
                            @aud.pitch.init,@aud.pitch.main,@after,varargin);
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    x.Ydata = sig.compute(@main,x.Ydata,option);
    out = {x};
end


function d = main(d,option)
    if option.stable
        warning('WARNING IN AUD.PITCH: ''Stable'' not available yet.');
%         d = d.apply(@stable,{option.stable},{'sample'},1,'{}');
    end
    if option.median
        warning('WARNING IN AUD.PITCH: ''Median'' not available yet.');
    end
end


function x = stable(x,option)
    1
end