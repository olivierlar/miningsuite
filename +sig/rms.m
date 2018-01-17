% SIG.RMS
%
% Copyright (C) 2014, 2017-2018, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = rms(varargin)
    varargout = sig.operate('sig','rms',...
                            initoptions,@init,@main,@after,varargin,'plus');
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    
        median.key = 'Median';
        median.type = 'Boolean';
        median.default = 0;
    options.median = median;
end


%%
function [x,type] = init(x,option)
    if option.frame
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
    end
    if isa(x,'sig.design') && option.median && ~option.frame
        x.nochunk = 1;
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'RMS')
        [d,Sstart,Send] = sig.compute(@routine,x.Ydata,x.Sstart,x.Send,option.median);
        x = sig.Signal(d,'Name','RMS',...
                       'Sstart',Sstart,'Send',Send,...
                       'Srate',x.Frate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d,ss,se,optionmedian)
    if find(strcmp('element',d.dims))
        dim = 'element';
    else
        dim = 'sample';
    end
    if optionmedian
        meth = @rmedians;
    else
        meth = @rmeans;
    end
    d = d.apply(meth,{},{dim},1);
    d = d.deframe;
    out = {d,ss,se};
end


function y = rmeans(x)
    y = x'*x;
end


function y = rmedians(x)
    y = sqrt(median(x.^2));
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    if ~option.median
        if find(strcmp('element',x.Ydata.dims))
            dim = 'element';
        else
            dim = 'sample';
        end
        x.Ydata = sig.compute(@routine_norm,x.Ydata,x.Ssize,dim);
    end
    out = {x};
end


function d = routine_norm(d,Ssize,dim)
    d = d.apply(@afternorm,{Ssize},{dim},Inf);
end


function d = afternorm(d,l)
    d = sqrt(d/l);
end