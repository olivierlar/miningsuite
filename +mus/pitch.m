% MUS.PITCH
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = pitch(varargin)
    varargout = sig.operate('mus','pitch',initoptions,@init,@main,@after,...
                            varargin);
end


%%
function options = initoptions
    options = aud.pitch.options;
    
        inter.key = 'Inter';
        inter.type = 'Boolean';
        inter.default = 0;
    options.inter = inter;    
    
        sampling.key = 'Sampling';
        sampling.type = 'Numeric';
        sampling.default = 0;
    options.sampling = sampling;    
end


%%
function [x,type] = init(x,option,frame)
    if iscell(x)
        x = [aud.pitch.init(x,option,frame),x];
    end
    type = {'sig.Signal'};
end


function out = main(in,option)
    if iscell(in)
        if length(in{1}.yname) >= 5 && strcmpi(in{1}.yname(end-4:end),'Pitch')
            out = in;
        else
            out = aud.pitch.main(in,option);
            out{1}.Ydata = sig.compute(@routine,out{1}.Ydata);
        end
    else
        p = zeros(length(in.content),1);
        t = zeros(length(in.content),1);
        for i = 1:length(p)
            p(i) = in.content{i}.parameter.getfield('chro').value;
            t(i) = in.content{i}.parameter.getfield('onset').value;
        end
        if option.inter
            p = diff(p);
            t(end) = [];
            nam = 'Inter-Pitch';
        else
            nam = 'Pitch';
        end
        if option.sampling
            t2 = t(1):option.sampling:t(end);
            p = interp1(t,p,t2,'previous');
            t = t2;
        end
        d = sig.data(p,{'sample'});
        if option.sampling
            d.content = d.content';
            out = {sig.Signal(d,'Name',nam,'Srate',1/option.sampling)}; %'FbChannels',x.fbchannels??
        else
            out = {sig.Signal(d,'Name',nam,'Sstart',t,'Srate',0)}; %'FbChannels',x.fbchannels??
        end
    end
end


function p = routine(f)
    p = f.apply(@freq2chro,{},{'element'},1,'{}');
end


function y = freq2chro(x)
    y = 12*log2(x{1});
end


function x = after(x,option)
end