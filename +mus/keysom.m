% MUS.KEYSOM
%
% Copyright (C) 2017, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = keysom(varargin)
    varargout = sig.operate('mus','chromagram',initoptions,...
                            @init,@main,@after,varargin);
end


function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',2,.05);
end


%%
function [x type] = init(x,option,frame)
    x = mus.chromagram(x,'FrameConfig',frame,'Normal');
    type = {'mus.KeySOM'};
end


function out = main(orig,option)
    orig = orig{1};
    load keysomaudiodata;
    z = sig.compute(@routine,orig.Ydata,somw);
    som = mus.KeySOM(z,'Srate',orig.Srate,'Ssize',orig.Ssize,...
                     'FbChannels',orig.fbchannels);
    out = {som};
end


function z = routine(m,somw)
    z = m.apply(@algo,{somw},{'element','sample'},2,'{}');
end


function out = algo(m,somw)
    z = zeros(24,size(m,2),36);
    for k = 1:size(m,2)
        for kk=1:36
            for ll=1:24
                tmp = corrcoef([m(:,k) somw(:,kk,ll)]);
                z(ll,k,kk) = tmp(1,2);
            end
        end
    end
    out = {z};
end


function x = after(x,option)
end