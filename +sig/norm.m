% SIG.NORM
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = norm(varargin)
    varargout = sig.operate('sig','norm',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = struct;
    
        dim.key = 'Along';
        dim.type = 'String';
        dim.default = '';
    options.dim = dim;
end

%%
function [x type] = init(x,option,frame)
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    res = sig.compute(@routine,x.Ydata,option.dim);
    x = sig.Signal(res,'Name','Norm',...
        'Xsampling',1,'Xstart',1,...
        'Srate',x.Srate,'Ssize',x.Ssize);
    out = {x};
end


function out = routine(d,dim)
    if isempty(dim)
        if max(strcmp('element',d.dims)) %&& d.size('element') > 1
            dim = 'element';
        else
            dim = 'sample';
        end
    end
    out = d.apply(@algo,{},{dim},1);
    if strcmp(dim,'sample')
        out = out.deframe;
    end
end


function n = algo(x)
    n = norm(x);
    n = n';
end


function x = after(x,option)
end