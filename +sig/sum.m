% SIG.SUM
% sums the channels together
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = sum(varargin)
    if varargin{1}.istype('sig.Signal')
        chunk = 'concat';
    else
        chunk = 'no';
    end
    varargout = sig.operate('sig','sum',options,@init,@main,@after,...
                            varargin,chunk);
end


function options = options
    options = sig.Signal.signaloptions();

        mean.key = 'Mean';
        mean.type = 'Boolean';
        mean.default = 0;
    options.mean = mean;
    
        type.key = 'Type';
        type.type = 'String';
        %type.choice = {'channel','freqband'};
        type.default = 'freqband';
    options.type = type;
    
        adj.key = 'Adjacent';
        adj.type = 'Numeric';
        adj.default = 1;
    options.adj = adj;
end


%%
function [x,type] = init(x,option)
    type = 'sig.Signal';
end


function out = main(x,option)
    x = x{1};
    if option.mean
        norm = x.Ydata.size(option.type);
    else
        norm = 1;
    end
    x.Ydata = sig.compute(@routine,x.Ydata,norm,option.type,option.adj);
    x.fbchannels = 1;
    out = {x};
end


function out = routine(in,norm,type,adjacent)
    out = in.sum(type,adjacent);
    if norm ~= 1
        out.content = out.content / norm;
    end
end


function x = after(x,option)
end