% AUD.PITCH
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = pitch(varargin)
    varargout = sig.operate('aud','pitch',aud.pitch.options,...
                            @aud.pitch.init,@main,varargin);
end


function out = main(x,option,postoption)
    if isempty(option)
        out = x;
    else
        out = aud.pitch.main(x,option,postoption);
    end
    if isempty(postoption)
        out = {out};
    else
        out = {after(out,postoption)};
    end
end


function x = after(x,postoption)
    if iscell(x)
        x = x{1};
    end
end