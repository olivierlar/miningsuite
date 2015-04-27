# aud.flux: Auditory modeling of spectral flux #

This operations is a specialisation of the general signal processing operator [sig.flux](SigFlux.md) focused on auditory modelling

## Flowchart Interconnections ##

Same as in [sig.flux](SigFlux.md).

## Options ##

  * `aud.flux(…,'SubBand')` decomposes first the input waveform using a 10-channel filterbank of octave-scaled second-order elliptical filters, with frequency cut of the first (low-pass) filter at 50 Hz:
```
sig.filterbank(…,'CutOff',[-Inf 50*2.^(0:1:8) Inf], 'Order', 2)
```

![https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex5.png](https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex5.png)

Alluri and Toiviainen (2010, 2012) introduced this model, using a frame size of 25 ms and half-overlapping, corresponding to the command:

```
aud.flux(…,'SubBand','Frame',.025)
```

The authors found that fluctuations in the lower channels, around 50 Hz ~ 200 Hz (sub-bands 2 and 3) represent perceived “Fullness”, and those around 1600 ~ 6400 Hz (sub-Bands 7 and 8) represent perceived “Activity”.

Alternatively, other filterbanks proposed in SigFilterbank can be specified, using the syntax:
  * `aud.flux(…,'SubBand','Gammatone')`<p>
<ul><li><code>aud.flux(…,'SubBand','2Channels')</code></li></ul>

<h2>Accessible Output</h2>

Same as in <a href='SigFlux.md'>sig.flux</a>.