# Not valid anymore! Replaced by sig.envelope and aud.minr #

Another way of determining the tempo is based on first the computation of an onset detection curve, showing the successive bursts of energy corresponding to the successive pulses. A peak picking is automatically performed on the onset detection curve, in order to show the estimated positions of the notes.

```
sig.onsets('ragtime')
```

![https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex1.png)

<br>
<h2>Flowchart Interconnections</h2>

The onset detection curve can be computed in various ways:<br>
<br>
<ul><li><code>sig.onsets(…,'Envelope')</code> computes an amplitude envelope, using <code>sig.envelope</code> (default choice). The envelope extraction can be specified, as in <code>sig.envelope</code> using either <code>'Spectro'</code> or <code>'Filter'</code> option:</li></ul>

<h3><code>'Spectro'</code></h3>

The default option.<br>
<br>
<ul><li><code>sig.onsets(…,'SpectroFrame',</code><i>fl</i><code>,</code><i>fh</i><code>)</code> species the frame length <i>fl</i> (in s.) and the hop factor <i>fh</i> (as a value between 0 and 1).<br> Default values: <i>fl</i> = .1 s., <i>fh</i> = .1<p>
</li><li>the frequency reassigment method can be specified: <code>'Freq'</code> (default), <code>'Mel'</code>, <code>'Bark'</code> or <code>'Cents'</code> (cf. SigSpectrum).<p>
</li><li><code>sig.onsets(…,'PowerSpectrum', 0)</code> turns off the computation of the power of the spectrum.<p>
</li><li><code>sig.onsets(…,'Terhardt')</code> toggles on the <code>'Terhardt'</code> operation (cf. SigSpectrum).<p></li></ul>


<h3><code>'Filter'</code></h3>

Related options in <code>sig.envelope</code> can be specified: <code>'FilterType'</code>, <code>'Tau'</code>, <code>'PreDecim'</code> with same default value as for <code>sig.envelope</code>.<br>
<br>
<ul><li><code>sig.onsets(…,'Filterbank',</code><i>N</i><code>)</code> specifies the number of channels for the filterbank decomposition (cf. SigFilterbank): the default value being <i>N</i> = 40. <i>N</i> = 0 toggles off the filterbank decomposition.<p>
</li><li><code>sig.onsets(…,'FilterbankType',</code><i>t</i><code>)</code> specifies the type of filterbank decomposition.<p>
<br>
</li><li><code>sig.onsets(…,'Sum','off')</code> toggles off the channel summation (cf. SigSum) that is performed by default.<p></li></ul>

<ul><li>Other available options, related to <code>sig.envelope</code>: <code>'HalfwaveCenter'</code>, <code>'Log'</code>, <code>'MinLog'</code>, <code>'Mu'</code>, <code>'Power'</code>, <code>'Diff'</code>, <code>'HalfwaveDiff'</code>, <code>'Lambda'</code>, <code>'Center'</code>, <code>'Smooth'</code>, <code>'PostDecim'</code>, <code>'Sampling'</code>, <code>'UpSample'</code>, all with same default as in <code>sig.envelope</code>. In addition, sig.envelope's <code>'Normal'</code> option can be controlled as well, with a default set to 1.<p></li></ul>

<ul><li><code>sig.onsets(…,'SpectralFlux')</code> computes a spectral flux. Options related to <code>sig.flux</code> can be passed here as well: <p>
<ul><li><code>'Inc'</code> (toggled on by default here),<p>
</li><li><code>'Halfwave'</code> (toggled on by default here),<p>
</li><li><code>'Complex'</code> (toggled off by default as usual),<p>
</li><li><code>'Median'</code> (toggled on by default here, with same default parameters as in <code>sig.flux</code>).<p>
</li></ul></li><li><code>sig.onsets(…,'Emerge')</code> is an improved version of the <code>'SpectralFlux'</code> method that is able to detect more notes and in the same time ignore the spectral variation produced by vibrato.</li></ul>

When the <code>'Emerge'</code> method is used for academic research, please cite the following publication:<br>
<br>
<table><thead><th> Lartillot, O., Cereghetti, D., Eliard, K., Trost, W. J., Rappaz, M.-A., Grandjean, D., "Estimating tempo and metrical features by tracking the whole metrical hierarchy", 3rd International Conference on Music & Emotion, Jyväskylä, 2013.</th></thead><tbody></tbody></table>


<ul><li><code>sig.onsets(…,'Pitch')</code> computes a frame-decomposed autocorrelation function (cf. SigAutocor), of same default characteristics than those returned by <code>sig.pitch</code> – with however a range of frequencies set by the following options:<br>
<ul><li><code>'Min'</code> (set by default to 30 Hz),<br>
</li><li><code>'Max'</code> (set by default to 1000 Hz),<br>
</li></ul><blockquote>and subsequently computes the novelty curve of the resulting similarity matrix. Option related to <code>sig.novelty</code> can be passed here as well:<br>
</blockquote><ul><li><code>'KernelSize'</code> (set to 32 samples by default).<p>
</li></ul></li><li><code>sig.onsets(…,'Novelty')</code> computes a power-spectrogram (<code>sig.spectrum</code>) in dB with maximum frequency 1000 Hz, minimal frequency resolution 3 Hz and 50 ms frame with 10 ms hop factor, and subsequently computes the novelty curve of the resulting similarity matrix, using <code>'Euclidean'</code> distance and the 'oneminus' similarity measure. Option related to <code>sig.novelty</code> can be passed here as well:<p>
<ul><li><code>'KernelSize'</code> (set to 64 samples by default).<br>
</li></ul></li></ul><blockquote>Besides, the <code>'Diff'</code> option can also be used when using the <code>'Novelty'</code> method.</blockquote>

<blockquote><table><thead><th>Whatever the chosen method, the onset curve is finally converted into an envelope (using <code>sig.envelope</code>), and further operations are performed in this order: <p>1. <code>'Center'</code> (performed if <code>'Center'</code> was specified while calling <code>sig.onset</code>).<br>2. <code>'Normal'</code> (always performed).</th></thead><tbody></blockquote></tbody></table>

<code>sig.onsets</code> accepts as input data type either:<br>
<br>
<ul><li>envelope curves (resulting from <code>sig.envelope</code>),</li></ul>

<ul><li>any scalar object, in particular:<br>
<ul><li>fluxes (resulting from <code>sig.flux</code>)<br>
</li><li>novelty curves (resulting from <code>sig.novelty</code>)</li></ul></li></ul>

<ul><li>similatrix matrices (resulting from <code>sig.simatrix</code>): its novelty is automatically computed, with a <code>'KernelSize'</code> of 32 samples.</li></ul>

<ul><li><code>sig.input</code> objects, where the audio waveform can be:<br>
<ul><li>segmented (using <code>sig.segment</code>),<br>
</li><li>decomposed into channels (using <code>sig.filterbank</code>),<br>
</li><li>decomposed into frames or not (using <code>sig.frame</code>):<br>
<ul><li>if the audio waveform is decomposed into frames, the onset curve will be based on the spectral flux;<br>
</li><li>if the audio waveform is not decomposed into frames, the default onset curve will be based on the envelope;</li></ul></li></ul></li></ul>

<ul><li>file name(s) or the <code>'Folder'</code> keyword: same behavior than for <code>sig.input</code> objects,</li></ul>

<ul><li>any other object: it is decomposed into frames (if not already decomposed) using the parameters specified by the <code>'Frame'</code> option; the flux will be automatically computed by default, or the novelty (if the <code>'Pitch'</code> option has been chosen).</li></ul>

<br>
<h2>Example</h2>

Differentiating the envelope using the <code>'Diff'</code> option highlights the difference of energy. By subsequently applying a halfwave rectification of the result (<code>'HalfwaveDiff'</code>), bursts of energy are emphasized.<br>
<br>
<pre><code>o=sig.onsets('ragtime','Diff','Sum','no','Filterbank',5,'Halfwavediff','Detect','no')<br>
</code></pre>

For the previous example (cf. figure above) we obtain now for the differentiated envelopes the following representation:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex2.png' />

And once the envelopes are summed:<br>
<br>
<pre><code>sig.sum(o)<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex3.png' />

<h2>Onset detection</h2>
<code>sig.onsets(…,'Detect',</code><i>d</i><code>)</code> specifies options related to the peak picking from the onset detection curve:<p>
<ul><li><i>d</i> = <code>'Peaks'</code> (default choice): local maxima are chosen as onset positions;<p>
</li><li><i>d</i> = <code>'Valleys'</code>: local minima are chosen as onset positions;<p>
</li><li><i>d</i> = 0, or <code>'no'</code>, or <code>'off'</code>: no peak picking is performed.<p></li></ul>

<br>
Options associated to the <code>sig.peaks</code> function can be specified as well. In particular:<p>
<ul><li><code>sig.onsets(…,'Contrast',</code><i>c</i><code>)</code> with default value here <i>c</i> = .01, <p>
</li><li><code>sig.onsets(…,'Threshold',</code><i>t</i><code>)</code> with default value here <i>t</i> = 0.<p>
</li><li><code>sig.onsets(…,'Single')</code> selects only the highest peak.<p></li></ul>

<br>
<h2>Attack and release</h2>
The maxima of the onset detection curve show the positions of the note onsets, but more precisely the end of the attack phase. The <code>'Attack'</code> and <code>'Release'</code> options estimate the beginning of the attack phase and the end of the release phase of each note by searching for the local minimum before and after each peak.<br>
<br>
<ul><li><code>sig.onsets(…,'Attack')</code> (or <code>'Attacks'</code>) detects attack phases.</li></ul>

<pre><code>sig.onsets('ragtime','attacks')<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex4.png' />

<ul><li><code>sig.onsets(…,'Release',</code><i>r</i><code>)</code> (or <code>'Releases'</code>) detects release phases.</li></ul>

<pre><code>￼sig.onsets('ragtime','releases')<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex5.png' />

If the <code>'Attack'</code> or <code>'Release'</code> method discovers that some attack/release phases are overlapped, the redundant onset is filtered out. If for instance, two successive peaks have either the same start attack time, or the same end release time, only one peak is kept.<br>
<br>
<br>
<h2>Segmentation</h2>

The onset points can be used for segmentation of the initial waveform:<br>
<br>
<pre><code>o=sig.onsets('ragtime');<br>
sig.segment('ragtime',o)<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex6.png' />

Alternatively, the beginning of the attack phases can be used for the segmentation:<br>
<br>
<pre><code>o=sig.onsets('ragtime','Attacks');<br>
sig.segment('ragtime',o)<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigOnsets_ex7.png' />

<h2>Frame decomposition</h2>

The onset detection curve can be further decomposed into frames if the <code>'Frame'</code> option has been specified, with default frame length 3 seconds and hop factor of 10% (0.3 second).<br>
<br>
<br>
<h2>Preselected Model</h2>

Complete (or nearly complete) models are available:<br>
<br>
<ul><li><code>sig.onsets(…,'Scheirer')</code> follows the model proposed in (Scheirer, 1998). It corresponds to:<br>
<pre><code>sig.onsets(…,'FilterbankType','Scheirer','FilterType','HalfHann','Sampling',200,'HalfwaveDiff','Sum',0,'Detect',0)<br>
</code></pre></li></ul>

<ul><li>sig.envelope(…,'Klapuri99) follows the model proposed in (Klapuri., 1999). It corresponds to:<br>
<pre><code>o=sig.onsets(…,'FilterbankType','Klapuri','FilterType','HalfHann','PreDecim',180,'Sum',0,'PostDecim',0);<br>
<br>
o2=sig.envelope(o,'HalfwaveDiff'); % absolute distance function D<br>
<br>
o=sig.envelope(o,'Mu','HalfwaveDiff'); % relative distance function W<br>
<br>
p=sig.peaks(o,'Contrast',.2,'Chrono');<br>
<br>
p2=sig.peaks(o2,'ScanForward',p,'Chrono');<br>
<br>
o=combinepeaks(p,p2,.05);<br>
</code></pre></li></ul>

<blockquote>where combinepeaks is a dedicated function that creates a curve made of burst at position of peaks <i>p</i> and with amplitude related to peaks <i>p2</i>.<br>
<pre><code>o=sig.sum(o,'Weights',fB);<br>
</code></pre></blockquote>

<blockquote>The intensity is multiplied by the band center frequency fB.<br>
<pre><code>o=sig.envelope(o,'Smooth',12);<br>
</code></pre></blockquote>

<br>
<h2>Accessible Output</h2>

cf. §5.2 for an explanation of the use of the get method. Specific fields:<br>
<br>
<ul><li><code>'AttackPos'</code>: the abscissae position of the starting attack phases, in sample index,<p>
</li><li><code>'AttackPosUnit'</code>: the abscissae position of the starting attack phases, in the default abscissae representation,<p>
</li><li><code>'ReleasePos'</code>: the abscissae position of the ending release phases, in sample index,<p>
</li><li><code>'ReleasePosUnit'</code>: the abscissae position of the ending release phases, in the default abscissae representation.