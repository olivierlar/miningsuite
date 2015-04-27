# sig.envelope: Amplitude envelope #

From an audio waveform can be computed the envelope, which shows the global outer shape of the signal. It is particularly useful in order to show the long term evolution of the signal, and has application in particular to the detection of musical events such as notes.

Here is an example of audio file with its envelope:<p>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex1.png' />

<blockquote><i>Audio waveform of ragtime excerpt</i><p></blockquote>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex2.png' />

<blockquote><i>Corresponding envelope of the ragtime excerpt</i></blockquote>


<br>
<h2>Flowchart Interconnections</h2>

<code>sig.envelope</code> accepts as input data type either:<br>
<ul><li><code>sig.signal</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>) and/or decomposed into channels (using <code>sig.filterbank</code>),<p>
</li><li>file name(s), <code>'Folder'</code> or <code>'Folders'</code> keywords, etc.<p>
</li><li>any scalar object (i.e., where there is one numerical value associated to each successive frame, such as <i>sig.flux, sig.novelty</i>, etc.): in this case, the mirscalar object is simply converted into a <code>sig.envelope</code> object. The advantages of this operation is that the resulting <i>sig.envelope</i> can be further decomposed into frames, which would not have been possible using the mirscalar object as it is already decomposed into frames.</li></ul>

<br>
<h2>Parameters Specification</h2>

The envelope extraction is based on two alternate strategies: either based on a filtering of the signal (<code>'Filter'</code> option, used by default), or on a decomposition into frames via a spectrogram computation (<code>'Spectro'</code> option). Each of these strategies accepts particular options:<br>
<br>
<h3><code>'Filter'</code></h3>

<code>sig.envelope(…,'Filter')</code> extract the envelope through a filtering of the signal. <b>(Default method.)</b>

<ul><li>First the signal can be converted from the real domain to the complex domain using a Hilbert transform. In this way the envelope is estimated in a three-dimensional space defined by the product of the complex domain and the temporal axis. Indeed in this representation the signal looks like a “spring” of varying width, and the envelope would correspond to that varying width. In the real domain, on the other hand, the constant crossing of the signal with the zero axis may sometime give erroneous results.</li></ul>

<blockquote>An Hilbert transform can be performed in <i>sig.envelope</i>, based on the <i>Matlab</i> function <code>hilbert</code>. In order to toggle on the Hilbert transform, the following keyword should be added:<br>
<pre><code>sig.envelope(…,'Hilbert')<br>
</code></pre></blockquote>

<blockquote>Beware however that, although sometimes the use of the Hilbert transform seems to improve somewhat the results, and might in particular show clearer burst of energy, we noticed some problematic behavior, in particular at the beginning and the end of the signal, and after some particular bursts of energy. This becomes all the more problematic when chunk decompositions are used (cf. §5.3), since the continuity between chunk cannot be ensured any more. For that reason, since version 1.1 of <i>MIRtoolbox</i>, the use of Hilbert transform is toggled off by default.</blockquote>

<blockquote>If the signal is in the real domain, the next step consists in a full-wave rectification, reflecting all the negative lobes of the signal into the positive domain, leading to a series of  positive half-wave lobes. The further smoothing of the signal (in the next step) will leads to an estimation of the envelope. If on the contrary the signal is in the complex domain, a direct estimation of the envelope can be obtained by computing the modulus, i.e., the width of the “string”. These two operations, either from the real or the complex domains, although apparently different, relate to the same <i>Matlab</i> command <code>abs</code>.</blockquote>

<ul><li><code>sig.envelope(…,'PreDecim',</code><i>N</i><code>)</code> down-samples by a factor <i>N</i>>1, where <i>N</i> is an integer, before the low-pass filtering (Klapuri, 1999). <b>Default value: <i>N</i> = 1, corresponding to no down-sampling.</b></li></ul>

<ul><li>The next step consists in a low-pass filter than retain from the signal only the long-term evolution, by removing all the more rapid oscillations. This is performed through a filtering of the signal. Two types of filters are available, either a simple autoregressive coefficient, with Infinite Impulse Response (<code>'IIR'</code> default value in <code>'FilterType'</code> option), or a half-Hanning (raised cosine) filter (<code>'HalfHann'</code> value in <code>'FilterType'</code> option).<br>
<ul><li><code>sig.envelope(…,'FilterType','IIR')</code> extract the envelope using an auto-regressive filter of infinite impulse response (IIR). <b>This is the default method.</b> The range of frequencies to be filtered can be controlled by selecting a proper value for the a parameter. Another way of expressing this parameter is by considering its time constant. If we feed the filter with a step function (i.e. 0 before time 0, and 1 after time 0), the time constant will correspond to the time it will take for the output to reach 63 % of the input. Hence higher time constant means smoother filtering. <b>The default time constant is set to .02 seconds</b> and can be changed using the option:<br>
<pre><code>sig.envelope(…,'Tau',t)<br>
</code></pre></li></ul></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex3.png' />
<blockquote><i>Detail of the ‘IIR’ envelope extraction process</i></blockquote>

<table><thead><th> <b>Remarks</b> </th></thead><tbody>
<tr><td>  As low-pass filters actually lead to a shifting of the phases of the signal. This is counteracted using a second filtering of the reverse signal. The time constant <i>t</i> is the time constant of each separate filter, therefore <i>the resulting time constant is around twice bigger</i>. </td></tr>
<tr><td>  The reverse filtering is not performed using Matlab <code>filtfilt</code> function because this would not work in the case of chunk decomposition (cf. ChunkDecomposition) – but has been partly re-implemented. In particular, contrary to <code>filtfilt</code>, care is not yet taken to minimize startup and ending transients by matching initial conditions. </td></tr></tbody></table>

<ul><li>Once the signal has been smoothed, as there is a lot of redundancy between the successive samples, the signal can be down-sampled. The default parameter related to down-sampling is the down-sampling rate <i>N</i>, i.e. the <i>integer</i> ratio between the old and the new sampling rate. <b><i>N</i> is set by default to 16</b>, and can be changed using the option:<br>
<pre><code>sig.envelope(…,'PostDecim',N)<br>
</code></pre></li></ul>

<blockquote>Alternatively, any sampling rate <i>r</i> (in Hz) can be specified using the post-processing option <code>'Sampling'</code>.</blockquote>

<ul><li><code>sig.envelope(…,'Trim')</code>: trims the initial ascending phase of the curves related to the transitory state.</li></ul>

<h3><code>'Spectro'</code></h3>

<code>sig.envelope(…,'Spectro')</code> extracts the envelope through the computation of a spectrogram, with frame size 100 ms, hop factor 10% and the use of Hanning windowing:<br>
<pre><code>sig.spectrum(…,'Frame',.1,'s',.1,'/1','Window','hanning',b)<br>
</code></pre>

<ul><li><code>sig.envelope(…,</code><i>b</i><code>)</code> specifies whether the frequency range is further decomposed into bands (cf. SigSpectrum). Possible values:<br>
<ul><li><i>b</i> = <code>'Freq'</code>: no band decomposition (default value),<br>
</li><li><i>b</i> = <code>'Mel'</code>: Mel-band decomposition,<br>
</li><li><i>b</i> = <code>'Bark'</code>: Bark-band decomposition,<br>
</li><li><i>b</i> = <code>'Cents'</code>: decompositions into cents.</li></ul></li></ul>

<ul><li><code>sig.envelope(…,'Frame',…)</code> modifies the default frame configuration.</li></ul>

<ul><li><code>sig.envelope(…,'UpSample',</code><i>N</i><code>)</code> upsamples by a factor <i>N</i> > 1, where <i>N</i> is an integer. Default value if <code>'UpSample'</code> called: <i>N</i> = 2</li></ul>

<ul><li><code>sig.envelope(…,'Complex')</code> toggles on the <code>'Complex'</code> method for the spectral flux computation (cf. SigFlux).</li></ul>

<ul><li><code>sig.envelope(…,'PowerSpectrum',0)</code> turns off the computation of the power of the spectrum.</li></ul>

<ul><li><code>sig.envelope(…,'Terhardt')</code> toggles on the <code>'Terhardt'</code> operation (cf. SigSpectrum).</li></ul>

<ul><li><code>sig.envelope(…,'TimeSmooth',0)</code> toggles on and controls the <code>'TimeSmooth'</code> operation. (cf. SigSpectrum).</li></ul>


<br>
<h2>Post-processing options</h2>

Different operations can be performed on the envelope curve:<br>
<br>
<ul><li><code>sig.envelope(…,'Sampling',</code><i>r</i><code>)</code> resamples to rate <i>r</i> (in Hz). <code>'PostDecim'</code> and <code>'Sampling'</code> options cannot therefore be combined.</li></ul>

<ul><li><code>sig.envelope(…,'Halfwave')</code> performs a half-wave rectification on the envelope.</li></ul>

<ul><li><code>sig.envelope(…,'Center')</code> centers the extracted envelope.<p></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex4.png' />

<br>
<ul><li><code>sig.envelope(…,'HalfwaveCenter)</code> performs a half-wave rectification on the centered envelope.<p></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex5.png' />

<br>
<ul><li><code>sig.envelope(…,'Log')</code> computes the common logarithm (base 10) of the envelope.<br>
<ul><li><code>sig.envelope(…,'MinLog',</code><i>ml</i><code>)</code> selects the data in the logarithmic range [<i>-ml</i> dB, 0 dB], where 0 dB corresponds to the maximal logarithmic amplitude, and excludes the data below that range.</li></ul></li></ul>

<ul><li><code>sig.envelope(…,‘Power')</code> computes the power (square) of the envelope.</li></ul>

<ul><li><code>sig.envelope(…,'Diff')</code> computes the differentiation of the envelope, i.e., the differences between successive samples.<p></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex6.png' />

<br>
<ul><li><code>sig.envelope(…,'HalfwaveDiff')</code> performs a half-wave rectification on the differentiated envelope.<p></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigEnvelope_ex7.png' />


<ul><li><code>sig.envelope(…,'Normal')</code> normalizes the values of the envelope by fixing the maximum value to 1.<br>
<ul><li>If the audio signal is decomposed into segments, each segment is normalized individually.<br>
</li><li><code>sig.envelope(…,'Normal','AcrossSegments')</code>, on the contrary, normalizes across segments, i.e., with respect to the global maxima across all the segments of that audio signal.<p></li></ul></li></ul>

<ul><li><code>sig.envelope(…,‘Smooth’,</code><i>o</i><code>)</code> smooths the envelope using a movering average of order <i>o</i>. The default value when the option is toggled on: <i>o</i> = 30</li></ul>

<ul><li><code>sig.envelope(…,‘Gauss’,</code><i>o</i><code>)</code> smooths the envelope using a gaussian of standard deviation <i>o</i> samples. The default value when the option is toggled on: <i>o</i> = 30</li></ul>

<br>
<h2>Auditory model</h2>

Auditory modelling of envelope extraction is available in <a href='AudEnvelope.md'>aud.envelope</a>.<br>
<br>
<br>
<h2>Accessible Output</h2>

Specific fields:<br>
<br>
<ul><li><code>method</code>: the value of the <code>'Method'</code> option,<p>
</li><li><code>log</code>: whether the envelope has been logged using the <code>'Log'</code> option (1) or not (0),<p>
</li><li><code>diff</code>: whether the envelope has been differentiated (1) or not (0).