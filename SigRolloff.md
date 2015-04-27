# sig.rolloff: High-frequency energy (I) #

One way to estimate the amount of high frequency in the signal consists in finding the frequency such that a certain fraction of the total energy is contained below that frequency. This ratio is fixed by default to .85 (following Tzanetakis and Cook, 2002), others have proposed .95 (Pohle, Pampalk and Widmer, 2005).

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.rolloff</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects, or<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>sig.rolloff(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Options</h2>

<ul><li><code>sig,rolloff(…,'Threshold',</code><i>p</i><code>)</code> specifies the energy threshold, as a percentage. Default value: .85<p>
</li><li><code>sig.rolloff(…,'MinRMS',</code><i>m</i><code>)</code> specifies the threshold <i>m</i>, as a value from 0 to 1, for the detection of quasi-silent frames, for which no value is given. For a given frame, if the RMS of the input spectrogram is below <i>m</i> times the highest RMS value over the frames, NaN is returned. default value: <i>m</i> = .005