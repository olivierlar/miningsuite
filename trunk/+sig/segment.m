% SIG.SEGMENT
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = segment(varargin)
    varargout = sig.operate('sig','segment',initoptions,...
                            @init,@main,varargin,'concat_sample');
end
                    
                    
%%
function options = initoptions
    options = sig.signal.signaloptions();
    
        pos.type = 'Numeric';
    options.pos = pos;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option,postoption)
    x = in{1};
    s = {};
    Sstart = x.Sstart;
    si1 = 0;
    for i = 1:length(option.pos)
        si2 = find(x.sdata > option.pos(i),1);
        if isempty(si2)
            if si1
                if si1 < x.Ssize
                    s{end+1} = x.Ydata.content(si1:end);
                end
            else
                s{end+1} = x.Ydata.content;
            end
            break
        end
        if si1
            s{end+1} = x.Ydata.content(si1:si2-1);
        elseif si2 > 1
            s{end+1} = x.Ydata.content(1:si2-1);
        end
        si1 = si2;
        Sstart(end+1) = option.pos(i);
    end
    x.Ydata.content = s;
    x.Sstart = Sstart;
    out = {x};
end


function out = routine(d,f,f0)
    e = d.apply(@algo,{f,f0},{'element'},3);
    out = {e};
end


function y = algo(m,f,f0)
    y = sum(m(f > f0,:,:)) ./ sum(m);
end


function x = after(x)
end