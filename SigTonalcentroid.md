# sig.tonalcentroid: 6-dimensional tonal centroid vector #

Calculates the 6-dimensional tonal centroid vector from the chromagram. It corresponds to a projection of the chords along circles of fifths, of minor thirds, and of major thirds (Harte and Sandler, 2006).

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.tonalcentroid</code> accepts either:<br>
<ul><li><code>sig.chromagram</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects , where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code>),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.</li></ul>

<br>
<code>sig.tonalcentroid</code> can return several outputs:<br>
<ol><li>the tonal centroid itself, and<p>
</li><li>the <code>sig.chromagram</code> data.</li></ol>

<br>
<h2>Frame decomposition</h2>
<code>sig.tonalcentroid(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 743 ms and a hop factor of 10% (74.3 ms). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Accessible Output</h2>
cf. §5.2 for an explanation of the use of the <code>'get'</code> method. Specific fields:<br>
<ul><li><code>'Dimensions'</code>: the index of the 6 dimensions (same as <code>'Pos'</code>),<p>
</li><li><code>'Positions'</code>: the position of each data within the 6-dimensional space (same as <code>'Data'</code>).