# sig.segment(…,'RMS') #

Segmentation at positions of long silences. A frame decomposed RMS is computed using sig.rms (with default options), and segments are selected from temporal positions where the RMS rises to a given `'On'` threshold, until temporal positions where the RMS drops back to a given `'Off'` threshold.

<br>
<h2>Options</h2>

<ul><li><code>sig.segment(…,'Off',</code><i>t1</i><code>)</code> specifies the RMS <code>'Off'</code> threshold. Default value: <i>t1</i> = .01<p>
</li><li><code>sig.segment(…,'On',</code><i>t2</i><code>)</code> specifies the RMS <code>'On'</code> threshold. Default value: <i>t2</i> = .02</li></ul>

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.segment</code> accepts uniquely as main input a miraudio objects not frame-decomposed, not channel decomposed, and not already segmented. Alternatively, file name or the <code>'Folder'</code> keyword can be used as well.<br>
<br>
<code>sig.segment(…,'RMS')</code> can return several outputs:<br>
<br>
<ul><li>the segmented audio waveform itself,<p>
</li><li>the RMS curve (<code>sig.rms</code>).