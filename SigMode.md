# sig.mode: Modality estimation #

Estimates the modality, i.e. major vs. minor, returned as a numerical value between -1 and +1: the closer it is to +1, the more major the given excerpt is predicted to be, the closer the value is to -1, the more minor the excerpt might be.

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.mode</code> accepts either:<br>
<ul><li><code>sig.keystrength</code> objects, where peaks have been already extracted or not,<p>
</li><li><code>sig.chromagram</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.key</code>) or<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br>
<code>sig.mode</code> can return several outputs:<br>
</li></ul><ol><li>modality itself, and<p>
</li><li>the <code>sig.keystrength</code> result used for the computation of modality.</li></ol>

<br>
<h2>Frame decomposition</h2>
<code>sig.mode(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 1 s and a hop factor of 50% (0.5 s). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Strategies</h2>
<ul><li><code>sig.mode(…,'Best')</code> computes the key strength difference between the best major key (highest key strength value) and the best minor key (lowest key strength value). (default choice)<p>
<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigMode_ex1.png' />
</blockquote></li><li><code>sig.mode(…,'Sum')</code> sums up the key strength differences between all the major keys and their relative minor keys.