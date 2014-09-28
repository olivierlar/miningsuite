% SIG.AUTOCOR
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = autocor(varargin)
    varargout = sig.operate('sig','autocor',sig.autocor.options,...
                            @init,@main,varargin,...
                            @sig.autocor.combinechunks,'extensive');
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