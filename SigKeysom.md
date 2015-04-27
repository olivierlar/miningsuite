# sig.keysom: Self-organizing map #

Projects the chromagram (normalized using the `'Normal'` option) into a self-organizing map trained with the Krumhansl-Kessler profiles (modified for chromagrams) (Toiviainen and Krumhansl, 2003; Krumhansl, 1990).

The result is displayed as a pseudo-color map, where colors correspond to Pearson correlation values. In case of frame decomposition, the projection maps are shown one after the other in an animated figure.

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.keysom</code> accepts either:<br>
<ul><li><code>sig.chromagram</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code>),<p>
</li><li>file name or the <code>'Folder'</code> keyword.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>sig.keysom(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 1 s and a hop factor of 50% (0.5 s). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Example</h2>
<pre><code>sig.keysom('ragtime')<br>
</code></pre>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigKeysom_ex1.png' />


<h2>Accessible Output</h2>
cf. §5.2 for an explanation of the use of the <code>'get'</code> method. Specific fields:<br>
<br>
<ul><li><code>'Weight'</code>: the projection value associated to each map location (same as <code>'Data'</code>).