function varargout = hist(varargin)

    if isnumeric(varargin{1})
        [options post] = sig.options(initoptions,varargin,'sig.hist');
        varargout = {sig.signal(varargin{1},'Name','Histogram')};
    else
        
        varargout = sig.operate('sig','hist',...
                                initoptions,@init,@main,varargin,'plus');
    end
end


%%
function options = initoptions
        n.key = 'Number';
        n.type = 'Numeric';
        n.default = 10;
    options.n = n;
end


%%
function [x type] = init(x,option)
    type = 'sig.signal';
end


function out = main(in,option,postoption)
    x = in{1};
    if ~strcmpi(x.yname,'Histogram')
        res = sig.compute(@routine,x.Ydata);
        x = sig.signal(res{1},'Name','Histogram',...
                       'Xsampling',0,'Xstart',res{2},...
                       'Srate',x.Frate,'Ssize',x.Ssize);
    end
    out = {x};
end


function out = routine(d)
    if find(strcmp('element',d.dims))
        dim = 'element';
    else
        dim = 'sample';
    end
    out = d.apply(@algo,{},{dim},1);
    n = out;
    n.content = n.content{1}.deframe;
    xout = out;
    xout.content = xout.content{2};
    out = {n xout};
end


function out = algo(x)
    [n xout] = hist(x);
    n = n';
    out = {n xout};
end