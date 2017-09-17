% MUS.KEY
%
% Copyright (C) 2017, Olivier Lartillot
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
    s = mus.keystrength(x,'FrameConfig',frame,...
        'Weight',option.wth,'Triangle',option.tri);
    p = sig.peaks(s,'Total',option.tot,'Contrast',option.thr);
    type = {'sig.Signal','sig.Signal','mus.Keystrength'};
end


function x = main(x,option)
    x{2} = x{1};
    x{3} = x{1};
    x{1}.Ydata = sig.compute(@routine,x{1}.peakpos);
    x{1}.peak = [];
    x{1}.yname = 'Key';
    x{2}.Ydata = sig.compute(@routine,x{2}.peakval);
    x{2}.peak = [];
    x{2}.yname = 'Key clarity';
end


function p = routine(f)
    p = f.apply(@freq2chro,{},{'element'},1,'{}');
end


function y = freq2chro(x)
    y = x{1};
end


function x = after(x,option)
end