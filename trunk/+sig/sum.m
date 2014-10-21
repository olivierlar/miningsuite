% SIG.SUM
% sums the channels together
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = sum(varargin)
    varargout = sig.operate('sig','sum',options,...
                            @init,@main,varargin,'concat');
end


function options = options
    options = sig.signal.signaloptions();

        mean.key = 'Mean';
        mean.type = 'Boolean';
        mean.default = 0;
    options.mean = mean;
    
        type.key = 'Type';
        type.type = 'String';
        type.choice = {'channel','freqband'};
        type.default = 'freqband';
    options.type = type;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function res = main(x,option,postoption)
    if isempty(option)
        res = x;
        return
    end
    x = x{1};
    if option.mean
        norm = length(x.fbchannels);
    else
        norm = 1;
    end
    x.Ydata = sig.compute(@routine,x.Ydata,norm,option.type);
    x.fbchannels = 1;
    res = {x};
end


function out = routine(in,norm,type)
    out = in.sum(type);
    if norm ~= 1
        out.content = out.content / norm;
    end
end