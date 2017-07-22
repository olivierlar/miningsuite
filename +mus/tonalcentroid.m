% MUS.TONALCENTROID
%
% Copyright (C) 2017, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = tonalcentroid(varargin)
    varargout = sig.operate('mus','tonalcentroid',initoptions,@init,@main,@after,...
                            varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameManual',.743,.1);
end


%%
function [x,type] = init(x,option,frame)
    x = mus.chromagram(x,'FrameConfig',frame);
    type = {'sig.signal'};
end


function x = main(x,option)
    x1 = sin(pi*7*(0:11)/6)';
    y1 = cos(pi*7*(0:11)/6)';
    % minor thirds circle
    x2 = sin(pi*3*(0:11)/2)';
    y2 = cos(pi*3*(0:11)/2)';
    % major thirds circle
    x3 = 0.5 * sin(pi*2*(0:11)/3)';
    y3 = 0.5 * cos(pi*2*(0:11)/3)';
    c = [x1 y1 x2 y2 x3 y3];
    c = c';
    x{2} = x{1};
    x{1}.Ydata = sig.compute(@routine,x{1}.Ydata,c);
    x{1}.yname = 'Tonal Centroid';
end


function p = routine(d,c)
    p = d.apply(@algo,{c},{'element','sample'},2);
end


function n = algo(m,c)
    n = c * m;
end


function x = after(x,option)
end