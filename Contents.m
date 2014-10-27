% MiningSuite
% Version 0.8 (Alpha version) 27-October-2014
%
% It is still in development stage, so the results cannot be trusted for the moment..
%
% SigMinr.
%  Signal processing
%   sig.input           - Loads waveforms from files or Matlab arrays.
%   sig.frame           - Decomposed into frames
%   sig.rms             - Root Mean Square energy
%   sig.envelope        - Amplitude envelope
%   sig.spectrum        - FFT spectrum distribution
%   sig.cepstrum        - Cepstrum
%   sig.autocor         - Autocorrelation function
%   sig.flux            - Distance between successive frames
%   sig.filterbank      - Filterbank decomposition
%   sig.peaks           - Peak picking
%   sig.segment         - Segmentation
%   sig.zerocross       - Zero-crossing rate
%   sig.rolloff         - High-frequency energy
%
%  Statistics
%   sig.hist            - Histogram
%   sig.centroid        - Centroid
%
%   sig.ans             - Recalls the last design evaluation result.
%   sig.chunklim        - Maximal chunk size allowed
%
%
% AudMinr
%  Auditory modelling
%   aud.envelope
%   aud.spectrum
%   aud.filterbank
%   aud.brightness      - Brightness, as high-frequency energy
%   aud.mfcc            - Mel-frequency cepstral coefficients
%   aud.score           - Onset detection
%   aud.eventdensity    - Temporal density of events
%   aud.roughness       - Sensory dissonance
%   aud.pitch           - F0 estimation
%   aud.fluctuation     - Rhythmic periodicity
%
%
% MusMinr
%  Music analysis
%   mus.autocor
%   mus.spectrum
%   mus.tempo           - Tempo estimation
%   mus.chromagram      - Energy distribution along pitches
%   mus.keystrength     - Probability of key candidates
%   mus.key             - Key estimation
%   mus.score           - Analysis in the symbolic domain
%   mus.pitch           - Pitch contour
%
%
% SeqMinr
%  Sequence processing
%   Internal routines not available to end users
%
%
% PatMinr
%  Pattern mining
%   Internal routines not yet available to end users
%
%
% More operators are currently under preparation.
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.