% SIG.AUTOCOR
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = autocor(varargin)
    varargout = sig.operate('sig','autocor',sig.autocor.options,...
                            @init,@main,varargin,@combinechunks);
end


function [x type] = init(x,option,frame)
    type = 'sig.Autocor';
end


function out = main(x,option,postoption)
    if ~isempty(option)
        x = sig.autocor.main(x,option,postoption);
    end
    if isempty(postoption)
        out = {x};
    else
        out = sig.autocor.after(x,postoption);
    end
end


function obj = combinechunks(obj,new)
    do = obj.Ydata;
    dn = new.Ydata;
    lo = do.size('element');
    ln = dn.size('element');
    if lo == ln
    elseif abs(lo-ln) <= 2  % Probleme of border fluctuation
        mi = min(lo,ln);
        do = do.extract('element',[1,mi]);
        dn = dn.extract('element',[1,mi]);
    elseif ln < lo
        dn = dn.edit('element',lo,0);   % Zero-padding
    elseif lo < ln
        do = do.edit('element',ln,0);   % Zero-padding
    end
    obj.Ydata = do.plus(dn);
end