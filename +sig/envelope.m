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
    varargout = sig.operate('sig','envelope',initoptions,@init,@main,...
                                             varargin,'concat','extensive');
end


function options = initoptions
    options = sig.signal.signaloptions(); %(.1,.1);
    
        filter.key = 'FilterType';
        filter.type = 'String';
        filter.choice = {'IIR','HalfHann','Butter',0};
        filter.default = 'IIR';
    options.filter = filter;

            %% options related to 'IIR': 
            tau.key = 'Tau';
            tau.type = 'Numeric';
            tau.default = .02;
    options.tau = tau;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.Envelope';
end


function out = main(x,option,postoption)
    if isnumeric(x) % MIDI Note matrix
        %%
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
        obj = sig.Envelope(d,'Srate',ndivs,'Sstart',0,'Ssize',length(g));
    elseif isa(x{1},'sig.Envelope')
        obj = x{1};
    else
        d = sig.compute(@routine,x{1}.Ydata,x{1}.Srate,option);
        
        obj = sig.Envelope(d,'Srate',x{1}.Srate,...
                           'Sstart',x{1}.Sstart,'Ssize',x{1}.Ssize);
    end
    if isempty(postoption)
        out = {obj};
    else
        out = {obj.after(postoption)};
    end
end


function out = routine(in,sampling,option)
    if strcmpi(option.filter,'IIR')
        a2 = exp(-1/(option.tau*sampling)); % filter coefficient 
        a = [1 -a2];
        b = 1-a2;
    elseif strcmpi(option.filter,'HalfHann')
        a = 1;
        b = hann(sampling*.4);
        b = b(ceil(length(b)/2):end);
    elseif strcmpi(option.filter,'Butter')
        % From Timbre Toolbox
        w = 5 / ( sampling/2 );
        [b,a] = butter(3, w);
    end
    
    in = in.apply(@abs,{},{'sample'});
    
    if 1 %isempty(state)
        [out state] = in.apply(@filter,{b,a,'self'},{'sample'});
    else
        [out state] = in.apply(@filter,{b,a,'self',state},{'sample'});
    end
    
    out = out.apply(@max,{0},{'sample'}); % For security reason...
end