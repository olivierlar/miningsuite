% SIG.HISTOGRAM
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = histogram(varargin)
    varargout = sig.operate('sig','hist',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
        bins.key = 'Bins';
        bins.type = 'Numeric';
        bins.default = 10;
    options.bins = bins;
    
        int.key = 'Integer';
        int.type = 'Boolean';
        int.default = 0;
    options.int = int;
end


%%
function [x,type] = init(x,option)
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Histogram')
        [res,xout] = sig.compute(@routine,x.Ydata,option);
        x = sig.Signal(res,'Name','Histogram',...
                       'Xsampling',0,'Xstart',xout,...
                       'Srate',x.Frate,'Ssize',x.Ssize);
    end
    out = {x};
end


function out = routine(d,options)
    if ~isempty(find(strcmp('element',d.dims),1)) && d.size('element') > 1
        dim = 'element';
    else
        dim = 'sample';
    end
    if options.int
        [out,xout] = d.apply(@inthist,{},{dim},1);
    else
        [out,xout] = d.apply(@hist,{options.bins},{dim},1);
    end
    if strcmp(dim,'sample')
        out = out.deframe;
    end
    out = {out,xout};
end


function [n, xout] = hist(x,nbins)
    if iscell(x)
        x = cell2mat(x);
    end
    [n,edges] = histcounts(x,nbins);
    n = n';
    xout = edges(1:end-1) + (edges(2)-edges(1))/2;
end


function [n, xout] = inthist(x)
    if ~isinteger(x)
        error('ERROR IN SIG.HISTOGRAM: Input values should be of type integer. Don''t use ''Integer'' option.');
    end
    minx = min(x);
    xout = (min(x):max(x))';
    n = zeros(size(xout));
    for i = 1:length(x)
        idx = x(i) - minx + 1;
        n(idx) = n(idx) + 1;
    end
end


function x = after(x,option)
end