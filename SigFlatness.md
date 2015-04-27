# sig.flatness: Flatness of the data #

`sig.flatness` returns the flatness of the data.

The flatness indicates whether the distribution is smooth or spiky, and results from the simple ratio between the geometric mean and the arithmetic mean:

![https://miningsuite.googlecode.com/svn/wiki/SigFlatness_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigFlatness_eq1.png)

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.flatness</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>)<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>'Frame'</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Inputs</h2>

Any data can be used as input.<br>
<br>
If the input is an audio waveform, a file name, or the <code>'Folder'</code> keyword, the flatness is computed on the spectrum (spectral flatness).<br>
<br>
<br>
<h2>Options</h2>

<code>sig.flatness(…,'MinRMS',</code><i>m</i><code>)</code> specifies the threshold <i>m</i>, as a value from 0 to 1, for the detection of quasi-silent frames, for which no value is given. For a given frame, if the RMS of the input (for spectral flatness, the input is each frame of the spectrogram, etc.) is below <i>m</i> times the highest RMS value over the frames, NaN is returned. default value: <i>m</i> = .01