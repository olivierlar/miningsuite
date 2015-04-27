# sig.play: Sonification of the result #

Certain classes of temporal data can be sonified:
  * `sig.input` objects: the waveform is directly played, and
    * if the audio waveform is segmented (using `sig.segment`), segments are played successively with a short burst of noise in-between;
    * if the audio waveform is decomposed into channels (using `sig.filterbank`), channels are played successively from low to high register;
    * if the audio is decomposed into frames (using `sig.frame`), frames are played successively;

  * file name(s) or the `'Folder'` keyword: same behavior than for `sig.input` objects;

  * `sig.envelope` objects (frame-decomposed or not) are sonified using a white noise modulated in amplitude by the envelope, and
    * if peaks have been picked on the envelope curve (using sig.peaks), they are sonified using a short impulse sound;

  * `sig.pitch` results: each extracted frequency is sonified using a sinusoid.

<br>
<h2>Frame decomposition</h2>

<code>sig.play(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. ‘Frame' section.<br>
<br>
<br>
<h2>Options</h2>

<ul><li><code>sig.play(…,'Channel',</code><i>i</i><code>)</code> plays the channel(s) of rank(s) indicated by the array <i>i</i>.<p>
</li><li><code>sig.play(…,'Segment',</code><i>k</i><code>)</code> plays the segment(s) of rank(s) indicated by the array <i>k</i>.<p>
</li><li><code>sig.play(…,'Sequence',</code><i>l</i><code>)</code> plays a sequence of audio files using the order indicated by the array <i>l</i>.<p>
</li><li><code>sig.play(…,'Increasing',</code><i>d</i><code>)</code> plays the sequences in increasing order of <i>d</i>, which can be either an array of number or a sig.scalar data (i.e., a scalar data returned by sig.toolbox).<p>
</li><li><code>sig.play(…,'Decreasing',</code><i>d</i><code>)</code> plays the sequences in decreasing order of <i>d</i>, which can be either an array of number or a sig.scalar data (i.e., a scalar data returned by sig.toolbox).<p>
</li><li><code>sig.play(…,'Every',</code><i>s</i><code>)</code> plays every <i>s</i> sequence, where <i>s</i> is a number indicating the step between sequences.<p>
</li><li><code>sig.play(…,'Burst','No')</code> toggles off the burst sound between segments.</li></ul>

<br>
<h2>Example</h2>

<pre><code>e=sig.envelope('Folder');<br>
<br>
rms=sig.rms('Folder');<br>
<br>
sig.play(e,'increasing',rms,'every',5)<br>
</code></pre>