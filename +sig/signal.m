% SIG.SIGNAL simply loads the waveform stored in a soundfile and performs
% basic post-processing.
%   SIG.SIGNAL('filename') loads the waveform stored in the file named 
%       'filename'. The data is stored into a sig.Signal object.
%   SIG.SIGNAL('Folder') loads all the sound files in the CURRENT folder
%       into a single sig.Signal object.
%   Transformation options:
%       SIG.SIGNAL(...,'Mix','No') does not perform the default summing of
%           channels into one single mono track, but instead stores each 
%           channel of the initial soundfile separately. 
%       SIG.SIGNAL(...,'Center') centers the waveform(s).
%       SIG.SIGNAL(...,'Sampling',r) resamples at rate r (in Hz).
%       SIG.SIGNAL(...,'Extract',t1,t2,u) extracts the signal between dates
%           t1 and t2, expressed in the unit u.
%           Possible values for u:
%               's' (seconds, by default),
%               'sp' (sample index, starting from 1).
%       SIG.SIGNAL(...,...,'Trim') trims the pseudo-silence beginning and
%           end off the audio file. Silent frames are frames with RMS below 
%           t times the medium RMS of the whole audio file.
%           Default value: t = 0.06
%       SIG.SIGNAL(...,'TrimThreshold',t) specifies the trimming threshold t.
%   SIG.SIGNAL(...,'Frame',...) decomposes the waveform into successive
%       frames. However we advise to use 'Frame' directly with the
%       operators for which frame decomposition is actually used.
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% See also SIG.SIGNAL

function varargout = signal(varargin)
varargout = sig.operate('sig','signal',...
                        sig.Signal.signaloptions('FrameAuto',.05,.5),...
                        sig.Signal.initmethod,sig.Signal.mainmethod,...
                        sig.Signal.aftermethod,varargin,'concat_sample');