# sig.centroid: Centroid of the data #

An important and useful description of the shape of a distribution can be obtained through the use of its moments. The first moment, called the mean, is the geometric center (centroid) of the distribution and is a measure of central tendency for the random variable.

![https://miningsuite.googlecode.com/svn/wiki/SigCentroid_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigCentroid_eq1.png)

![https://miningsuite.googlecode.com/svn/wiki/SigCentroid_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigCentroid_ex1.png)

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.centroid</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>)<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>'Frame'</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Input</h2>

Any data can be used as input.<br>
<br>
If the input is an audio waveform, a file name, or the <code>'Folder'</code> keyword, the centroid is computed on the spectrum (spectral centroid). For quasi-silent frames, as specified by the <code>'MinRMS'</code> option, NaN is returned.<br>
<br>
If the input is a series of peak lobes produced by <code>sig.peaks(…,'Extract')</code>, the centroid will be computed for each of these lobes separately.<br>
<br>
<br>
<h2>Options</h2>

<ul><li>When the input contains peaks (using <code>sig.peaks</code>), <code>sig.centroid(…,'Peaks',</code><i>i</i><code>)</code> will compute the centroids of the distribution of peaks. The argument i accepts two arguments:<br>
<ul><li><i>i</i> = <code>'NoInterpol'</code>: the centroid is computed on the non-interpolated peaks (default choice),<br>
</li><li><i>i</i> = <code>'Interpol'</code>: the centroid is computed on the interpolated peaks (cf. <code>'Interpol'</code> option in SigPeaks).<p>
</li></ul></li><li><code>sig.centroid(…,'MinRMS',</code><i>m</i><code>)</code> specifies the threshold <i>m</i>, as a value from 0 to 1, for the detection of quasi-silent frames, for which no value is given. For a given frame, if the RMS of the input (for spectral centroid, the input is each frame of the spectrogram, etc.) is below m times the highest RMS value over the frames, NaN is returned. default value: <i>m</i> = .005<p>
</li><li><code>sig.centroid(…,'MaxEntropy'</code><i>h</i><code>)</code> specifies the threshold <i>h</i>, as a value from 0 to 1, for the detection of quasi-flat frames, for which no value is given. For a given frame, if the entropy of the input (for spectral centroid, the input is each frame of the spectrogram, etc.) is over <i>m</i>, NaN is returned. default value: <i>m</i> = .95