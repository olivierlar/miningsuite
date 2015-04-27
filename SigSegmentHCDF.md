# sig.segment(…,'HCDF'): Segmenting using HCDF #

Peak detection applied to the HCDF returns the temporal position of tonal discontinuities that can be used for the actual segmentation of the audio sequence.

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.segment</code> accepts uniquely as main input <code>sig.input</code> objects not frame-decomposed, not channel decomposed, and not already segmented.<br>
<br>
Alternatively, file name(s) or the <code>'Folder'</code> keyword can be used as well.<br>
<br>
<br>
<code>sig.segment(…,'HCDF')</code> can return several outputs:<br>
<ol><li>the segmented audio waveform itself,<p>
</li><li>the HCDF (<code>sig.hcdf</code>) after peak picking (<code>sig.peaks</code>),<p>
</li><li>the tonal centroid (<code>sig.tonalcentroid</code>), and<p>
</li><li>the chromagram (<code>sig.chromagram</code>).