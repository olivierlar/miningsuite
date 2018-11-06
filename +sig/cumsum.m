% SIG.CUMSUM
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = mean(varargin)
    varargout = sig.operate('sig','cumsum',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = struct;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    res = sig.compute(@routine,x.Ydata);
    x = sig.Signal(res,'Name','Cumulative Sum',...
        'Xsampling',1,'Xstart',1,...
        'Srate',x.Srate,'Ssize',x.Ssize);
    out = {x};
end


function out = routine(d)
    if max(strcmp('element',d.dims))% && d.size('element') > 1
        dim = 'element';
    else
        dim = 'sample';
    end
    out = d.apply(@algo,{},{dim},1);
end


function n = algo(x)
    n = cumsum(x);
end


function x = after(x,option)
end