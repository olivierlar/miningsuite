% MiningSuite
% Version 0.10.github-master-19-September-2024
%
% Copyright (C) 2014-2015, 2017-2020, 2022, 2024 Olivier Lartillot and the 
% MiningSuite contributors
% All rights reserved
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% It is a Beta version, so the results cannot be trusted for the moment..
%
%
% Sig.Minr: Signal processing package
% 
% sig.signal: signal waveform
% sig.frame: frame decomposition
% sig.filterbank: filterbank decomposition
% sig.envelope: envelope extraction
% sig.spectrum: spectrum decomposition
% sig.cepstrum: spectral analysis of spectrum
% sig.autocor: autocorrelation function
% sig.flux: contrast between successive frames
% sig.events: event detection curve
% sig.sum: channel summation
% sig.peaks: peak picking
% sig.segment: waveform segmentation
% sig.play: signal or data sonification
% sig.length: temporal length
% sig.rms: root mean square
% sig.zerocross: waveform sign change rate
% sig.rolloff: high-frequency ratio
% sig.centroid: first statistical central moment
% sig.spread: second statistical central moment
% sig.skewness: third statistical central moment
% sig.kurtosis: fourth statistical central moment
% sig.flatness: distribution smoothness/pickiness
% sig.entropy: Shannon entropy of distribution
% sig.simatrix: self-similarity matrix
% sig.novelty: transition between states
% sig.mean: average along frames
% sig.std: standard deviation along frames
% sig.median: median along frames
% sig.histogram: histogram
%
%
% Aud.Minr: Auditory modelling package
% 
% aud.filterbank: filterbank decomposition
% aud.envelope: envelope extraction
% aud.spectrum: spectrum decomposition
% aud.flux: subband flux
% aud.fluctuation: rhythmic periodicities along auditory channels
% aud.events: event detection curve
% aud.eventdensity: average frequency of events
% aud.attacktime: duration of attack phase
% aud.attackslope: slope of attack phase
% aud.attackleap: amplitude of attack phase
% aud.decaytime: duration of decay phase
% aud.decayslope: slope of decay phase
% aud.decayleap: amplitude of decay phase
% aud.duration: events duration
% aud.tempo: temporal periodicity of events
% aud.pulseclarity: pulse clarity, beat strength
% aud.brightness: high-frequency ratio
% aud.mfcc: Mel-Frequency Cepstral Coefficients
% aud.roughness: sensory dissonance
% aud.pitch: stable fundamental frequencies
%
%
% Mus.Minr: Music analysis package
% 
% mus.spectrum: spectrum decomposition
% mus.autocor: autocorrelation function
% mus.tempo: tempo estimation
% mus.pulseclarity: pulse clarity, beat strength
% mus.pitch: notes pitch heights
% mus.chromagram: energy distribution along pitches
% mus.keystrength: key candidate scores
% mus.key: tonal center positions and clarity
% mus.majorness: major/minor mode clarity
% mus.keysom: key self-organizing map projection
% mus.tonalcentroid: projection along circles of fifths and thirds
% mus.hcdf: Harmonic Change Detection Function
% mus.score: symbolic representation and analysis
%
%
% Vid.Minr: Video analysis package
% 
% vid.video: video processing
%
%
% SeqMinr: Sequence processing
%   Internal routines not available to end users
%
%
% PatMinr: Pattern mining
%   Internal routines not yet available to end users
%
%
% More operators are currently under preparation.