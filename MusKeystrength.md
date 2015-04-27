# mus.keystrength: Probability of key candidates #

mus.keystrength computes the key strength, a score between -1 and +1 associated with each possible key candidate, through a cross-correlation of the chromagram returned by `mus.chromagram`, wrapped and normalized (using the `'Normal'` option), with similar profiles representing all the possible tonality candidates (Krumhansl, 1990; Gomez, 2006).
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigKeystrength_ex1.png' />

The resulting graph indicate the cross-correlation score for each different tonality candidate.<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigKeystrength_ex2.png' />
<br><br>


<h2>Flowchart Interconnections</h2>

For the moment, only the <code>'Weight'</code> and <code>'Triangle'</code> options used in <code>mus.chromagram</code> can be tuned directly in <code>mus.keystrength</code>.<br>
<br>
<code>mus.keystrength</code> accepts either:<br>
<ul><li><code>mus.chromagram</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects (same as for <code>mus.chromagram</code>),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br>
mus.keystrength can return several outputs:<br>
</li><li>the key strength itself, and<p>
</li><li>the <code>mus.chromagram</code> data.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>mus.keystrength(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 200 ms and a hop factor of 5% (10 ms). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Example</h2>
<pre><code>mus.keystrength('ragtime','Frame')<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigKeystrength_ex3.png' />


<h2>Accessible Output</h2>

cf. §5.2 for an explanation of the use of the <code>'get'</code> method. Specific fields:<br>
<br>
<ul><li><code>'Strength'</code>: the key strength value for each key and each temporal position (same as <code>'Data'</code>). The resulting matrix is distributed along two layers along the fourth dimension: a first layer for major keys, and a second layer for minor keys.<p>
</li><li><code>'Tonic'</code>: the different key centres (same as <code>'Pos'</code>).