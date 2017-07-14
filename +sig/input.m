% SIG.INPUT simply loads the waveform stored in a soundfile and performs
% basic post-processing.
%   SIG.INPUT('filename') loads the waveform stored in the file named 
%       'filename'. The data is stored into a sig.signal object.
%   SIG.INPUT('Folder') loads all the sound files in the CURRENT folder
%       into a single sig.signal object.
%   Transformation options:
%       SIG.INPUT(...,'Mix','No') does not perform the default summing of
%           channels into one single mono track, but instead stores each 
%           channel of the initial soundfile separately. 
%       SIG.INPUT(...,'Center') centers the waveform(s).
%       SIG.INPUT(...,'Sampling',r) resamples at rate r (in Hz).
%       SIG.INPUT(...,'Extract',t1,t2,u) extracts the signal between dates
%           t1 and t2, expressed in the unit u.
%           Possible values for u:
%               's' (seconds, by default),
%               'sp' (sample index, starting from 1).
%       SIG.INPUT(...,...,'Trim') trims the pseudo-silence beginning and
%           end off the audio file. Silent frames are frames with RMS below 
%           t times the medium RMS of the whole audio file.
%           Default value: t = 0.06
%       SIG.INPUT(...,'TrimThreshold',t) specifies the trimming threshold t.
%   SIG.INPUT(...,'Frame',...) decomposes the waveform into successive
%       frames. However we advise to use 'Frame' directly with the
%       operators for which frame decomposition is actually used.
%
% Copyright (C) 2017, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% See also SIG.SIGNAL

function varargout = input(varargin)
varargout = sig.operate('sig','input',...
                        sig.signal.signaloptions('FrameAuto',.05,.5),...
                        sig.signal.initmethod,sig.signal.mainmethod,...
                        sig.signal.aftermethod,varargin,'concat_sample');