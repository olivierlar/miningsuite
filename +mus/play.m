% MUS.PLAY
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function play(seq,ind,scal)

if nargin < 2
    ind = 1;
end

notes = seq.content;
synth = [];
for i = 1:length(notes{ind})
    t1 = notes{ind}{i}.parameter.fields{4}.value;
    t2 = notes{ind}{i}.parameter.fields{5}.value;
    %f = notes{ind}{i}.parameter.fields{1}.fields(1).value;
    p = notes{ind}{i}.parameter.fields{2}.value;
    f = midi2hz(p);
    if 1
        d = floor((t2-t1)*8192);
        soundsc(sin(2*pi*f*(0:d)/8192).*hann(d+1)');
        pause%(t2-t1);
    elseif isempty(p)
        %pause(diff(t));
    else
        f = f(1);
        p = p(1);
        if nargin>2
            k = find(p == [scal.deg]);
        	f = 2^(scal(k).freq(1)/1200);
        end
        d = floor((diff(t)*44100)+1/10);
        synth = [synth sin(2*pi*f*(0:d)/44100).*hann(d+1)'];
    end
end
%soundsc(synth,44100);


function f=midi2hz(m)
% Conversion of MIDI note number to frequency (Hz)
% f=midi2hz(m)
% Convert MIDI note numbers to frequencies in hertz (Hz). The A3 
% (Midi number 69) is 440Hz.
%
% Input arguments: M = pitches in MIDI numbers
%
% Output: F = pitches in hertz
%
% Example: midi2hz(pitch(createnmat));
%
%  Author		Date
%  T. Eerola	1.2.2003
%? Part of the MIDI Toolbox, Copyright ? 2004, University of Jyvaskyla, Finland
% See License.txt

if isempty(m), return; end
f= 440 * exp ((m-69) * log(2)/12);
