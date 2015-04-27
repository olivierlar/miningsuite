# sig.lowenergy: Less than average energy #

The energy curve can be used to get an assessment of the temporal distribution of energy, in order to see if its remains constant throughout the signal, or if some frames are more contrastive than others. One way to estimate this consists in computing the low energy rate, i.e. the percentage of frames showing less-than-average energy (Tzanetakis and Cook, 2002).

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.lowenergy</code> accepts as input data type either:<br>
<br>
<ul><li><code>sig.rms</code> frame-decomposed data,<p>
</li><li><code>sig.input</code> objects, where the audio waveform can be segmented (using mirsegment), decomposed into channels (using <code>sig.filterbank</code>). The audio waveform is decomposed into frames if it was not decomposed yet. <p>
</li><li>file name(s) or the <code>'Folder'</code> keyword: same behavior than for sig.input objects.</li></ul>

<br>
<code>sig.lowenergy</code> can return several outputs:<br>
<ul><li>the low-energy rate itself and<p>
</li><li>the <code>sig.rms</code> frame-decomposed data.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>sig.lowenergy(…,'Frame',…)</code> specifies the frame configuration, with by default a frame length of 50 ms and half overlapping. For the syntax, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Examples</h2>

If we take for instance this energy curve:<br>
<pre><code>r1=sig.rms('a1','Frame')<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigLowenergy_ex1.png' />

We can see that due to some rare frames containing particularly high energy, most of the frames are below the average RMS. And indeed if we compute the low-energy rate<br>
<pre><code>sig.lowenergy(r1)<br>
</code></pre>

we obtain the value 0.71317.<br>
<br>
<br>
For this opposite example:<br>
<pre><code>r2=sig.rms('a2','Frame')<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigLowenergy_ex2.png' />

there are two kind of frames basically, those that have quite constant high energy, and fewer that have very low energy. Hence most of the frames are over the average energy, leading to a low low-energy rate:<br>
<pre><code>sig.lowenergy(r2)<br>
</code></pre>
equal to 0.42398.<br>
<br>
<br>
<h2>Options</h2>

<ul><li><code>sig.lowenergy(…,'Threshold',</code><i>t</i><code>)</code> expressed as a ratio to the average energy over the frames. Default value: <i>t</i> = 1<p>
</li><li><code>sig.lowenergy(…,'ASR')</code> computes the Average Silence Ratio (Feng, Zhuang, Pan, 2003), which corresponds to a RMS without the square-root, and a default threshold set to <i>t</i> = .5