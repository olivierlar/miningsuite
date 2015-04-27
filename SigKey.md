# sig.key: Tonal center estimation #

Gives a broad estimation of tonal center positions and their respective clarity.

<br>
<h2>Flowchart Interconnections</h2>

It consists simply of a peak picking in the <code>sig.keystrength</code> curve(s). Two options of <code>sig.peaks</code> are accessible from <code>sig.key</code>:<br>
<ul><li><code>'Total'</code>, set to 1<p>
</li><li><code>'Contrast'</code>, set to .1<br>
<br>
The <code>'Weight'</code> and <code>'Triangle'</code> options used in <code>sig.chromagram</code> can be changed directly in <code>sig.keystrength</code>.</li></ul>

<br>
<code>sig.key</code> accepts either:<br>
<ul><li><code>sig.keystrength</code> objects, where peaks have been already extracted or not,<p>
</li><li><code>sig.chromagram</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects , where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code> or the <code>'Frame'</code> option, with by default a frame length of 1 s and half overlapping),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.</li></ul>

<br>
<code>sig.key</code> can return several outputs:<br>
<ol><li>the best key(s), i.e., the peak abscissa(e);<p>
</li><li>the key clarity: i.e., the key strength associated to the best key(s), i.e., the peak ordinate(s);<p>
</li><li>the <code>sig.keystrength</code> data including the picked peaks (sig.peaks).</li></ol>

<br>
<h2>Frame decomposition</h2>

<code>sig.key(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 1 s and a hop factor of 50% (0.5 s). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Example</h2>
<pre><code>[k c s]=sig.key('ragtime','Frame')<br>
</code></pre>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigKey_ex1.png' /><p>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigKey_ex2.png' /><p>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigKey_ex3.png' />