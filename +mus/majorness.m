% MUS.MAJORNESS
%
% Copyright (C) 2017-2018, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = mode(varargin)
    varargout = sig.operate('mus','majorness',initoptions,@init,@main,@after,...
                            varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameManual',1,.5);
    
        stra.type = 'String';
        stra.default = 'Best';
        stra.choice = {'Best','Sum','Major','SumBest'};
    options.stra = stra;
end


%%
function [x,type] = init(x,option)
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
    end
    x = mus.keystrength(x);
    type = {'sig.Signal','mus.Keystrength'};
end


function out = main(x,option)
    x = x{1};
    f = str2func(['algo' lower(option.stra)]);
    d = sig.compute(@routine,x.Ydata,f);
    m = sig.Signal(d,'Name','Majorness',...
                    'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
                    'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    out = {m,x};
end


function p = routine(d,f)
    p = d.apply(f,{},{'element'},1,'()');
end


function v = algosum(m)
    v = sum(abs(m(1:12) - m(13:24)));
end


function v = algobest(m)
    v = max(m(1:12)) - max(m(13:24));
end


function v = algosumbest(m)
    m = max(.5,m)-.5;
    v = sum(m(1:12)) - sum(m(13:24));
end


function v = algomajor(m)
    m = max(.5,m)-.5;
    v = sum(m(1:12));
end


function x = after(x,option)
end