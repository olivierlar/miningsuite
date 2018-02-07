% MUS.KEYSTRENGTH
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = keystrength(varargin)
    varargout = sig.operate('mus','keystrength',initoptions,...
                            @init,@main,@after,varargin);
end


function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.1,.125);
    
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
    if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
    end
    if ~istype(x,'mus.Keystrength')
        x = mus.chromagram(x,'Weight',option.wth,'Triangle',option.tri,'Normal');
    end
    type = {'mus.Keystrength','sig.Spectrum'};
end


function out = main(orig,option)
    orig = orig{1};
    if isa(orig,'mus.Keystrength')
        out = {orig};
        return
    end
    load gomezprofs;
    s = sig.compute(@routine,orig.Ydata,gomezprofs');
    ks = mus.Keystrength(s,'Srate',orig.Srate,'Ssize',orig.Ssize,...
                           'Sstart',orig.Sstart,'Send',orig.Send,...
                           'FbChannels',orig.fbchannels);
    ks.Xaxis.unit.rate = 1;
    ks.Xaxis.unit.origin = 1;
    ks = after(ks,option);
    out = {ks orig};
end


function out = routine(m,gomezprofs)
    m = m.apply(@algo,{gomezprofs},{'element'},1);
    out = {m};
end


function s = algo(m,gomezprofs)
    tmp = corrcoef([m gomezprofs]);
    s = tmp(1,2:25)';
end


function x = after(x,option)
end