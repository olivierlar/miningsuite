# sig.hcdf: Harmonic Change Detection Function #

The Harmonic Change Detection Function (HCDF) is the flux of the tonal centroid (Harte and Sandler, 2006).

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.hcdf</code> accepts either:<br>
<ul><li><code>sig.tonalcentroid</code> frame-decomposed objects,<p>
</li><li><code>sig.chromagram</code> frame-decomposed objects,<p>
</li><li><code>sig.spectrum</code> frame-decomposed objects,<p>
</li><li><code>sig.input</code> objects , where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>). If not decomposed yet, it is decomposed into frames (using the <code>'Frame'</code> option, with by default a frame length of .743 s and a hop factor of .1),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>sig.hcdf(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 743 ms and a hop factor of 10% (74.3 ms). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.