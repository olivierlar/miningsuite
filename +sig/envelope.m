% SIG.ENVELOPE
% extracts the envelope, showing the global shape of the waveform
%
% Copyright (C) 2014, Olivier Lartillot
%
% Code for envelope generation from MIDI file is taken from onsetacorr.m
%   and duraccent.m, part of MIDI Toolbox. Copyright ? 2004, University of 
%   Jyvaskyla, Finland
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = envelope(varargin)
    varargout = sig.operate('sig','envelope',sig.envelope.options,...
                            @sig.envelope.init,{@audio,@symbolic},varargin,'concat','extensive');
end


function out = audio(x,option,postoption)
    if isempty(option)
        out = x;
    else
        [out,postoption] = sig.envelope.main(x,option,postoption);
    end
    if isempty(postoption)
        out = {out};
    else
        out = {after(out,postoption)};
    end
end


function x = after(x,postoption)
    if iscell(x)
        x = x{1};
    end
    x = sig.envelope.resample(x,postoption);
    x = sig.envelope.rescale(x,postoption);
    x = sig.envelope.upsample(x,postoption);
    x.Ydata = sig.envelope.diff(x,postoption);
    x = sig.envelope.after(x,postoption);
end


function out = symbolic(x,option,postoption)
    % Code adapted from onsetacorr.m and duraccent.m in MIDItoolbox
    % NDIVS = divisions in Hz (default = 4);
    ndivs = 4;
    ob = x(:,6); % onsets in sec.
    
    dur = x(:,7); % durations in sec.
    tau=0.5;
    accent_index=2;
    d = (1-exp(-dur/tau)).^accent_index; % duration accent by Parncutt (1994)
    
    vlen = ndivs*(ceil(ob(end))+1);
    g = zeros(vlen,1);
    ind = mod(round(ob*ndivs),vlen)+1;
    for k=1:length(ind)
        g(ind(k)) = g(ind(k))+d(k);
    end
    %%
    d = sig.data(g,{'sample'});
    out = {sig.Envelope(d,'Srate',ndivs,'Sstart',0,'Ssize',length(g))};
end