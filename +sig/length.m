% SIG.LENGTH
% indicates the temporal length of x.
%
% Copyright (C) 2017, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = length(varargin)
    varargout = sig.operate('sig','length',options,...
                            @init,@main,@after,varargin,@sum);
end


function options = options
    options = sig.Signal.signaloptions();
    
        unit.key = 'Unit';
        unit.type = 'String';
        unit.choice = {'Second','Sample'};
        unit.default = 'Second';
    options.unit = unit;   
end


function [x type] = init(x,option,frame)
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    [d Sstart Send] = sig.compute(@routine,x.Ydata,x.Srate,x.Sstart,option,x.Send);
    out = {sig.Signal(d,'Name','Length','Srate',0,'Send',Send,...
                      'Sstart',Sstart,'FbChannels',x.fbchannels)};
end


function out = routine(d,sr,ss,option,sl)
    d = d.apply(@algo,{sr,option},{'sample'},1);
    out = {d ss sl};
end


function l = algo(d,sr,option)
    if iscell(d)
        nsg = length(s);
        l = zeros(nsg,1);
        for i = 1:nsg
            l(i) = length(s{i});
        end
    else
        l = length(d);
    end
    if strcmp(option.unit,'Second')
        l = l./sr;
    end
end


function x = after(x,option)
end


function x = sum(x,y)
    x.Ydata.content = x.Ydata.content + y.Ydata.content;
end