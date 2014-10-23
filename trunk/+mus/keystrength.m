% MUS.KEYSTRENGTH
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = keystrength(varargin)
    varargout = sig.operate('mus','keystrength',initoptions,...
                            @init,@main,varargin);
end


function options = initoptions
    options = sig.signal.signaloptions(.1,.125);
    
        wth.key = 'Weight';
        wth.type = 'Numeric';
        wth.default = .5;
    options.wth = wth;
    
        tri.key = 'Triangle';
        tri.type = 'Boolean';
        tri.default = 0;
    options.tri = tri;
    
        transp.key = 'Transpose';
        transp.type = 'Numeric';
        transp.default = 0;
        transp.when = 'After';
    options.transp = transp;
end


%%
function [x type] = init(x,option,frame)
    if ~istype(x,'mus.Keystrength')
        if ~istype(x,'mus.Chromagram')
            x = mus.chromagram(x,'Weight',option.wth,...
                               'Triangle',option.tri,'Normal');
        else
            x = mus.chromagram(x,'Wrap','Normal');
        end
    end
    type = {'mus.Keystrength','sig.Spectrum'};
end


function out = main(orig,option,postoption)
    orig = orig{1};
    if isempty(option)
        out = {after(orig,option)};
    else
        load gomezprofs;
        s = sig.compute(@routine,orig.Ydata,gomezprofs');
        ks = mus.Keystrength(s,'Srate',orig.Srate,'Ssize',orig.Ssize);
        ks.Xaxis.unit.rate = 1;
        ks = after(ks,option);
        out = {ks orig};
    end
end


function out = routine(m,gomezprofs)
    m = m.apply(@algo,{gomezprofs},{'element'},1);
    out = {m};
end


function s = algo(m,gomezprofs)
    tmp = corrcoef([m gomezprofs]);
    s = tmp(1,2:25)';
end


function out = after(x,postoption)
    out = x;
end