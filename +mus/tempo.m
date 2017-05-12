% MUS.TEMPO 
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = tempo(varargin)
    varargout = sig.operate('mus','tempo',initoptions,@init,@main,...
                            varargin,'plus');
end


%%
function options = initoptions
    options = sig.signal.signaloptions(3,.1);
    
        method.type = 'String';
        method.choice = {'Autocor','Pattern'};
        method.default = 'Autocor';
    options.method = method;
end


%%
function [x type] = init(x,option,frame)
    if strcmpi(option.method,'Autocor')
        if ~x.istype('sig.autocor')
            if frame.toggle
                x = sig.envelope(x,'Halfwave','Diff',1,'Lambda',1,...
                                    'FrameSize',frame.size.value,frame.size.unit,...
                                   'FrameHop',frame.hop.value,frame.hop.unit);
            else
                x = sig.envelope(x,'Halfwave','Diff',1,'Lambda',1);
            end
            x = sig.autocor(x,'Max',5);
        end
        x = sig.peaks(x,'Total',1,'NoBegin');
    elseif strcmpi(option.method,'Pattern')
        x = mus.score(x,'Metre');
    end
    type = {'sig.signal','sig.Autocor'};
end


function out = main(in,option,postoption)
    if isa(in,'mus.Sequence')
        o = [];
        for i = 1:length(in.content)
            v = in.content{i}.parameter.getfield('metre');
            if ~isempty(v) && ~isempty(v.value)
                o(end+1) = in.content{i}.parameter.getfield('onset').value;
            end
        end
        tp = zeros(length(o)-1,1);
        for i = 2:length(o)
            tp(i-1) = 60/(o(i) - o(i-1));
        end
        d = sig.data(tp,{'sample'});
        t = sig.signal(d,'Name','Tempo','Srate',1); %'FbChannels',x.fbchannels??
        out = {t};
    else
        x = in{1};
        if strcmpi(x.yname,'Tempo')
            out = in;
        else
            p = sig.compute(@routine,x.peakpos);
            pc = zeros(1,length(p.content));
            for i = 1:length(p.content)
                if isempty(p.content(i))
                    pc(i) = NaN;
                else
                    pc(i) = p.content(i);
                end
            end
            t = sig.signal(pc','Name','Tempo','Srate',in{1}.Srate,'FbChannels',in{1}.fbchannels);
            out = {t in{1}};
        end
    end
end


function out = routine(d)
    e = d.apply(@convert,{},{'element'});
    out = {e};
end


function y = convert(x)
    y = 60./x;
end