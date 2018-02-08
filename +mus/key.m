% MUS.KEY
%
% Copyright (C) 2017-2018, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = key(varargin)
    varargout = sig.operate('mus','key',initoptions,@init,@main,@after,...
                            varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameManual',1,.5);
    
        tot.key = 'Total';
        tot.type = 'Integer';
        tot.default = 1;
    options.tot = tot;
    
        thr.key = 'Contrast';
        thr.type = 'Integer';
        thr.default = .1;
    options.thr = thr;
    
        wth.key = 'Weight';
        wth.type = 'Integer';
        wth.default = .5;
    options.wth = wth;
    
        tri.key = 'Triangle';
        tri.type = 'Boolean';
        tri.default = 0;
    options.tri = tri;
end


%%
function [p,type] = init(x,option,frame)
     if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
    end
    s = mus.keystrength(x,'Weight',option.wth,'Triangle',option.tri);
    p = sig.peaks(s,'Total',option.tot,'Contrast',option.thr);
    type = {'sig.Signal','sig.Signal','mus.Keystrength'};
end


function out = main(x,option)
    x = x{1};
    k = sig.compute(@routine,x.peakindex);
    k = sig.Signal(k,'Name','Key',...
                        'Label',{'C';'C#';'D';'D#';'E';'F';'F#';'G';'G#';'A';'A#';'B';'c';'c#';'d';'d#';'e';'f';'f#';'g';'g#';'a';'a#';'b'},...
                        'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
                        'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    kc = sig.compute(@routine,x.peakval);
    kc = sig.Signal(kc,'Name','Key Clarity',...
                        'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
                        'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    out = {k,kc,x};
end


function p = routine(f)
    p = f.apply(@freq2chro,{},{'element'},1,'{}');
end


function y = freq2chro(x)
    y = x{1};
end


function x = after(x,option)
end