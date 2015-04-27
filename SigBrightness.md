# sig.brightness: High-frequency energy (II) #

A dual method consists in fixing this time the cut-off frequency, and measuring the amount of energy above that frequency (Juslin, 2000). The result is expressed as a number between 0 and 1.
<br><br>
<h2>Flowchart Interconnections</h2>

<code>sig.brightness</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects, or<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>).<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>sig.brightness(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>

<h2>Options</h2>

<ul><li><code>sig.brightness(…,'CutOff',</code><i>f</i><code>)</code> specifies the frequency cut-off, in Hz. Default value: 1500 Hz. The value 1000 Hz has been proposed in (Laukka, Juslin and Bresin, 2005), and the value of 3000 Hz has been proposed in (Juslin, 2000).<p>
</li><li><code>sig.brightness(…,'MinRMS',</code><i>m</i><code>)</code> specifies the threshold <i>m</i>, as a value from 0 to 1, for the detection of quasi-silent frames, for which no value is given. For a given frame, if the RMS of the input spectrogram is below m times the highest RMS value over the frames, NaN is returned. default value: <i>m</i> = .005