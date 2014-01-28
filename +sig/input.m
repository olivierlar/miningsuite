% SIG.INPUT
% simply loads the audio waveform and performs basic post-processing.
% Syntax: sig.input(filename)
% sig.input(...,'Mix') sums the channels together.
% sig.input(...,'Center') centers the waveform.
% sig.input(...,'Sampling',r) resamples at rate r (in Hz).
% sig.input(...,'Extract',t1,t2,u) extracts the signal between dates
%   t1 and t2, expressed in the unit u.
%   Possible values for u:
%       's' (seconds, by default),
%       'sp' (sample index, starting from 1).
% sig.input(...,...,'Trim') trims the pseudo-silence beginning and end off
%   the audio file. Silent frames are frames with RMS below t times the
%   medium RMS of the whole audio file.
%   Default value: t = 0.06
%   instead of 'Trim':
%       'TrimStart' only trims the beginning of the audio file,
%       'TrimEnd' only trims the end.
% sig.input(...,'TrimThreshold',t) specifies the trimming threshold t.
% sig.input(...,'Frame',...) decomposes the waveform into successive
%   frames. However we advise to use 'Frame' directly with the operators
%   for which frame decomposition is actually used.
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function varargout = input(varargin)


if isnumeric(varargin{1})
    varargout = {sig.signal(varargin{1},'Matlab array','')};
    return
end

    
varargout = sig.operate('sig','input',sig.Signal.signaloptions,...
                        sig.Signal.initmethod,sig.Signal.mainmethod,...
                        varargin,'concat_sample');