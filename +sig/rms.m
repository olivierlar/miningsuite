% SIG.RMS
%
% Copyright (C) 2014, 2017, Olivier Lartillot
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
    options = sig.signal.signaloptions('FrameAuto',.05,.5);    
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'RMS')
        d = sig.compute(@routine,x.Ydata);
        x = sig.signal(d,'Name','RMS',...
                       'Srate',x.Frate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d)
    if find(strcmp('element',d.dims))
        dim = 'element';
    else
        dim = 'sample';
    end
    e = d.apply(@algo,{},{dim},1);
    e = e.deframe;
    out = {e};
end


function y = algo(x)
    y = x'*x;
end


function out = after(in,option)
    x = in{1};
    if find(strcmp('element',x.Ydata.dims))
        dim = 'element';
    else
        dim = 'sample';
    end
    x.Ydata = sig.compute(@routine_norm,x.Ydata,x.Ssize,dim);
    out = {x};
end


function d = routine_norm(d,Ssize,dim)
    d = d.apply(@afternorm,{Ssize},{dim},Inf);
end


function d = afternorm(d,l)
    d = sqrt(d/l);
end