# sig.flux: Distance between successive frames #

Given a spectrogram:
```
s=sig.spectrum(a,'Frame')
```

![https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex1.png)

we can compute the spectral flux as being the distance between the spectrum of each successive frames.

```
sig.flux(s)
```

![https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex2.png](https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex2.png)

The peaks in the curve indicate the temporal position of important contrast in the spectrogram.

In MiningSuite fluxes are generalized to any kind of frame-decomposed representation, for instance a cepstral flux:

```
c=sig.cepstrum(a,'Frame')
```

![https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex3.png](https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex3.png)

```
sig.flux(c)
```

![https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex4.png](https://miningsuite.googlecode.com/svn/wiki/SigFlux_ex4.png)

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.flux</code> usually accepts either:<br>
<ul><li><code>sig.spectrum</code> frame-decomposed objects.<p>
</li><li><code>sig.input</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>). The audio waveform is decomposed into frames if it was not decomposed yet. If the input is a <i>sig.input</i> object, the default flux is a spectral flux: i.e., the audio waveform is passed to the <i>sig.spectrum</i> operator before being fed into <i>sig.flux</i>.<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword: same behavior as for <code>sig.input</code> objects;<p>
</li><li><code>sig.autocor</code> frame-decomposed objects;<p>
</li><li><code>sig.cepstrum</code> frame-decomposed objects;<p>
</li><li><code>sig.mfcc</code> frame-decomposed objects;<p>
</li><li><code>sig.chromagram</code> frame-decomposed objects;<p>
</li><li><code>sig.keystrength</code> frame-decomposed objects.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>sig.flux(…,'Frame',…)</code> specifies the frame configuration, the default being a frame length of 50 ms and half overlapping. For the syntax, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Parameters specification</h2>

<ul><li><code>sig.flux(</code><i>x</i><code>,'Dist',</code><i>d</i><code>)</code> specifies the distance between successive frames, among the list of distances available in pdist (cf. <code>help pdist</code>). Default distance: <code>'Euclidean'</code>.<p>
</li><li><code>sig.flux(…,'Inc')</code>: Only positive difference between frames are summed, in order to focus on increase of energy solely. If toggled on, <code>'Dist'</code> parameter can only accept <code>'Euclidean'</code>, <code>'Cosine'</code> or 'City'`.<p>
</li><li><code>sig.flux(…,'Complex')</code>, for spectral flux, combines the use of both energy and phase information (Bello et al, 2004).<p></li></ul>

<br>

<h2>Auditory model</h2>

Auditory modelling of spectral flux is available in <a href='AudFlux.md'>aud.flux</a>.