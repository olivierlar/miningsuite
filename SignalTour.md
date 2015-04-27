# Guided Tour: General signal processing #

This is a part of the MiningSuite GuidedTour.

Some examples of what you can try for the moment:

```
help miningsuite
```

```
a = sig.input('ragtime.wav','Extract',0,60,'s')
```
Loads file 'ragtime.wav' and extracts the first minute, and stores the result in variable a.
Note that if you add a semi-colon (';') at the end, the operation is not performed but the data flow is simply designed.

```
b = sig.spectrum(a,'Power');
```
Computes the Power spectrum based on the FFT stored in the variable a defined in previous line.

```
c = sig.rolloff(b)
c.getdata
```
Computes the spectral roll-off related to the Power spectrum stored in variable b.

```
b = sig.spectrum(a,'Frame','Power');
```
Computes power spectrogram

```
c = sig.rolloff(b,'FrameSize',.5,'s','FrameHop',.1,'s')
```
Computes the spectral roll-off frame by frame with frame specification.

```
ac = sig.autocor('ragtime.wav')
```
Computes autocorrelation function directly on the audio waveform.

```
e = sig.envelope('ragtime.wav')
```
Extract the energy envelope from the audio waveform.

```
ac = sig.autocor(e,'Max',5)
```
Computes autocorrelation function on the envelope curve.

```
sig.peaks(ac)
```
Detects peaks on the autocorrelation function.

```
ac = sig.autocor(e,'Max',5,'FrameSize',3,'FrameHop',.5)
sig.peaks(ac)
```

```
r = sig.rms('ragtime.wav')
r.getdata
```
Computes RMS energy.

```
sig.rms('ragtime.wav','Frame')
```

## To be continued... ##

You can go back to the MiningSuite GuidedTour.