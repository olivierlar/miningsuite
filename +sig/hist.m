% SIG.HIST
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = hist(varargin)
    varargout = sig.operate('sig','hist',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
        n.key = 'Number';
        n.type = 'Numeric';
        n.default = 10;
    options.n = n;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Histogram')
        [res xout] = sig.compute(@routine,x.Ydata,option.n);
        x = sig.Signal(res,'Name','Histogram',...
                       'Xsampling',0,'Xstart',xout,...
                       'Srate',x.Frate,'Ssize',x.Ssize);
    end
    out = {x};
end


function out = routine(d,nbins)
    if ~isempty(find(strcmp('element',d.dims),1)) && d.size('element') > 1
        dim = 'element';
    else
        dim = 'sample';
    end
    [out,xout] = d.apply(@algo,{nbins},{dim},1);
    if strcmp(dim,'sample')
        out = out.deframe;
    end
    out = {out,xout};
end


function [n, xout] = algo(x,nbins)
    [n,xout] = hist(x,nbins);
    n = n';
end


function x = after(x,option)
end