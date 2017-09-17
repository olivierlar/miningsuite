% MUS.MAJORNESS
%
% Copyright (C) 2017, Olivier Lartillot
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
function [x,type] = init(x,option,frame)
    x = mus.keystrength(x,'FrameConfig',frame);
    type = {'sig.Signal'};
end


function x = main(x,option)
    x{2} = x{1};
    f = str2func(['algo' lower(option.stra)]);
    x{1}.Ydata = sig.compute(@routine,x{1}.Ydata,f);
    x{1}.yname = 'Majorness';
end


function p = routine(d,f)
    p = d.apply(f,{},{'element'},1,'{}');
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