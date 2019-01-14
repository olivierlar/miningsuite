% MUS.TEMPO 
% estimates tempo
%
% Copyright (C) 2014, 2017-2019, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = tempo(varargin)
    varargout = sig.operate('mus','tempo',initoptions,...
                            @init,@main,@after,varargin);
end


%%
function options = initoptions
    options = aud.tempo.options;
    
        method.type = 'String';
        method.choice = {'Signal','Pattern'};
        method.default = 'Signal';
    options.method = method;
end


%%
function [x, type] = init(x,option)
    if strcmpi(option.method,'Signal')
        [x, type] = aud.tempo.init(x,option,@mus_autocor,@mus_spectrum);
    elseif strcmpi(option.method,'Pattern')
        x = mus.score(x,'Metre');
        type = {'sig.Signal','mus.Sequence'};
    end
end


function y = mus_autocor(x,option)
    y = mus.autocor(x,'Min',60/option.ma,'Max',60/option.mi,...
              'Enhanced',option.enh,...'NormalInput','coeff',...
              'Resonance',option.r,'NormalWindow',option.nw); %,...
             % 'Phase',option.phase);
end


function y = mus_spectrum(x,option)
    y = mus.spectrum(x,'Min',option.mi/60,'Max',option.ma/60,...
                           'Prod',option.prod,...'NormalInput',...
                           'Resonance',option.r,'ZeroPad',option.zp);
end


function out = main(in,option)
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
        t = sig.Signal(d,'Name','Tempo','Srate',1); %'FbChannels',x.fbchannels??
        out = {t};
    else
        out = aud.tempo.main(in,option);
    end
end


function x = after(x,option)
end