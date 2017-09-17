% SIG.MEAN
%
% Copyright (C) 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = mean(varargin)
    varargout = sig.operate('sig','mean',...
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
    x = sig.Signal(res,'Name','Mean',...
        'Xsampling',1,'Xstart',1,...
        'Srate',x.Frate,'Ssize',x.Ssize);
    out = {x};
end


function out = routine(d)
    if find(strcmp('element',d.dims)) && d.size('element') > 1
        dim = 'element';
    else
        dim = 'sample';
    end
    out = d.apply(@algo,{},{dim},1);
    if strcmp(dim,'sample')
        out = out.deframe;
    end
end


function n = algo(x)
    n = mean(x);
    n = n';
end


function x = after(x,option)
end