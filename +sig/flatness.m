% SIG.FLATNESS
%
% Copyright (C) 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = flatness(varargin)
    varargout = sig.operate('sig','flatness',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
end


%%
function [x type] = init(x,option)
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                          'FrameHop',option.fhop.value,option.fhop.unit);
        end
        x = sig.spectrum(x);   
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Flatness')
        res = sig.compute(@routine,x.Ydata);
        x = sig.Signal(res,'Name','Flatness',...
                       'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
                       'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d)
    e = d.apply(@algo,{},{'element'},1);
    out = {e};
end


function y = algo(d)
    n = size(d,1);
    ari = mean(d);
    geo = (prod(d.^(1/n)));
    logZero = warning('query','MATLAB:log:logOfZero');
    warning('off','MATLAB:log:logOfZero');
    y = geo./ari;
    warning(logZero.state,'MATLAB:log:logOfZero');
    y(isinf(y)) = 0;
end


function x = after(x,option)
end