# sig.beatspectrum: Beat spectrum #

The beat spectrum has been proposed as a measure of acoustic self-similarity as a function of time lag, and is computed from the similarity matrix (cf. SigSimatrix) (Foote, Cooper and Nam, 2002).

<br>
<h2>Flowchart Interconnections</h2>

One parameter related to <code>sig.simatrix</code> is accessible in <code>sig.beatspectrum</code>:<br>
<ul><li>'Distance'.<br>
<br>
<code>sig.beatspectrum</code> accepts either:<br>
</li><li><code>sig.simatrix</code> objects,<p>
</li><li><code>sig.spectrum</code> frame-decomposed objects,<p>
</li><li><code>sig.input</code> objects: in this case, the similarity matrix will be based on the mfcc (<code>sig.mfcc</code>), computed from ranks 8 to 33. The audio waveform is decomposed into frames if it was not decomposed yet<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword: same behavior as for <code>sig.input</code> objects,<p>
</li><li>other frame-decomposed analysis.<br>
<br>
<code>sig.beatspectrum</code> can return several outputs:</li></ul>

<ol><li>the beat spectrum curve itself, and<p>
</li><li>the similarity matrix (<code>sig.simatrix</code>).</li></ol>

<br>
<h2>Frame decomposition</h2>
<code>sig.beatspectrum(…,'Frame',…)</code> specifies the frame configuration, with by default a frame length of 25 ms and a hop factor of 10 ms. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.