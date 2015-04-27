# sig.spread: Standard deviation of the data #

`sig.spread` returns the standard deviation of the data.

The second central moment, called the variance, is usually given the symbol sigma squared and is defined as:

![https://miningsuite.googlecode.com/svn/wiki/SigSpread_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigSpread_eq1.png)<p>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigSpread_ex1.png' />

Being the squared deviation of the random variable from its mean value, the variance is always positive and is a measure of the dispersion or spread of the distribution. The square root of the variance is called the standard deviation, and is more useful in describing the nature of the distribution since it has the same units as the random variable. (Koch)<br>
<br>
<br>
<h2>Flowchart Interconnections</h2>

<code>sig.spread</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>)<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>'Frame'</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>

<br>
<h2>Inputs</h2>

Any data can be used as input.<br>
<br>
If the input is an audio waveform, a file name, or the <code>'Folder'</code> keyword, the spread is computed on the spectrum (spectral spread).<br>
<br>
If the input is a series of peak lobes produced by <code>sig.peaks(…,'Extract')</code>, the spread will be computed for each of these lobes separately.<br>
<br>
<br>
<h2>Options</h2>
<code>sig.spread(…,'MinRMS',</code><i>m</i><code>)</code> specifies the threshold <i>m</i>, as a value from 0 to 1, for the detection of quasi-silent frames, for which no value is given. For a given frame, if the RMS of the input (for spectral spread, the input is each frame of the spectrogram, etc.) is below m times the highest RMS value over the frames, NaN is returned. default value: <i>m</i> = .01