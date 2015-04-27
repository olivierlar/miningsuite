# sig.tempo: Tempo estimation #

Estimates the tempo by detecting periodicities from the onset detection curve.

## 1. Classical Version ##
The classical paradigm for tempo estimation is based on detecting periodicities in a range of BPMs, and choosing the maximum periodicity score for each frame separately.

Tempo estimation is carried out in several steps:

  * The onset detection curve computed in `sig.onsets` can be controlled using the following options:<p>
<ul><li><code>'Envelope'</code> (default) and <code>'DiffEnvelope'</code>:<br>
<ul><li>with the <code>'Method'</code> set by default to <code>'Filter'</code>:<br>
<ul><li>with <code>'FilterType'</code> option with same default,<br>
</li><li>with <code>'Filterbank'</code> option set to 10 by default,<br>
</li><li>with <code>'FilterbankType'</code> option with same default,<br>
</li></ul></li><li><code>'Method'</code> can be set to <code>'Spectro'</code> as well, and the <code>'Freq'</code>,<code>'Mel'</code>,<code>'Bark'</code>,<code>'Cents'</code> selection can be specified, with same default.<br>
</li><li>Besides <code>'Method'</code>: <code>'HalfwaveCenter'</code>, <code>'HalfwaveDiff'</code>, <code>'Lambda'</code>, <code>'Center'</code>, <code>'Smooth'</code>, <code>'Sampling'</code>, <code>'Log'</code> and <code>'Mu'</code>, all with same default and <code>'Diff'</code> set to <code>'On'</code> by default.<p>
</li></ul></li><li><code>'SpectralFlux'</code>: with <code>'Complex'</code>, <code>'Inc'</code>, <code>'Median'</code> and <code>'Halfwave'</code> with same default.<p>
</li><li><code>'Pitch'</code> and <code>'Novelty'</code>.</li></ul></li></ul>

Other options related to <code>sig.onsets</code> can be specified:<br>
<ul><li><code>'Filterbank'</code>, with same default value as for <code>sig.onsets</code>,<p>
</li><li><code>sig.onsets(…,'Sum',</code><i>w</i><code>)</code> specifies when to sum the channels. Possible values:<br>
<ul><li><i>w</i> = <code>'Before'</code>: sum before the autocorrelation or spectrum computation.<br>
</li><li><i>w</i> = <code>'After'</code>: autocorrelation or spectrum computed for each band, and summed into a "summary".<br>
</li><li><i>w</i> = <code>0</code>: tempo estimated for each band separately, with no channel recombination.</li></ul></li></ul>

<ul><li><code>sig.tempo(…,'Frame',…)</code> optionally performs a frame decomposition of the onset curve, with by default a frame length of 3 s and a hop factor of 10% (0.3 s). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<p>
</li><li>Periodicities are detected on the onset detection curve based on several possible strategies:<p>
<ul><li><code>sig.tempo(…,'Autocor')</code> computes an autocorrelation function of the onset detection curve, using <code>sig.autocor</code> (default choice). Options related to <code>sig.autocor</code> can be specified:<br>
<ul><li><code>'Enhanced'</code> (toggled on by default<sup>*</sup> here),<br>
</li><li><code>'Resonance'</code> (set by default to <code>'ToiviainenSnyder'</code>),<br>
</li><li><code>'NormalWindow'</code> (same default value).<p>
</li></ul></li><li><code>sig.tempo(…,'Spectrum')</code> computes a spectral decomposition of the onset detection curve, using <code>sig.spectrum</code>. Options related to <code>sig.spectrum</code> can be passed here as well:<br>
<ul><li><code>'ZeroPad'</code> (set by default here to 10 000 samples),<br>
</li><li><code>'Prod'</code> (same default, when toggled on, as for <code>sig.spectrum</code>),<br>
</li><li><code>'Resonance'</code> either <code>'ToiviainenSnyder'</code> (default value) or <code>0</code>, <code>'off'</code>, or <code>'no'</code>.<p>
</li></ul></li><li><code>sig.tempo(…,'Autocor','Spectrum')</code> combines both strategies: the autocorrelation function is translated into the frequency domain in order to be compared to the spectrum curve, and the two curves are subsequently multiplied.<p>
</li></ul></li><li>A peak picking is applied to the autocorrelation function or to the spectrum representation. The parameters of the peak picking can be tuned:<p>
<ul><li><code>sig.tempo(…,'Total',</code><i>m</i><code>)</code> selects not only the best tempo, but the <i>m</i> best tempos.<p>
</li><li><code>sig.tempo(…,'Min',</code><i>mi</i><code>)</code> indicates the lowest tempo taken into consideration, expressed in bpm. Default value: 40 bpm.<p>
</li><li><code>sig.tempo(…,'Max',</code><i>ma</i><code>)</code> indicates the highest tempo taken into consideration, expressed in bpm. Default value: 200 bpm.<p>
</li><li><code>sig.tempo(…,'Track',</code><i>t</i><code>)</code> tracks peaks along time, in order to obtain a stabilized tempo curve and to limit therefore switches between alternative pulsations. Default value when option toggled on: <i>t</i> = 0.1 s. When <code>'Track'</code> is toggled on, <code>'Enhanced'</code> is forced to off.<p>
</li><li><code>sig.tempo(…,'Contrast',</code><i>c</i><code>)</code> specifies the contrast factor for the peak picking. Default value: <i>c</i> = 0.1<p>
</li><li><code>sig.tempo(…,'Nearest',</code><i>n</i><code>)</code> chooses the peak closest to <i>n</i> (in s.). Default value when option toggled on: <i>n</i> = 0.5 s.<p></li></ul></li></ul>

<blockquote><sup>*</sup> except when <code>'Track'</code> option is used, as explained above.</blockquote>

When <code>'Track'</code> is used for academic research, please cite the following publication:<br>
<table><thead><th>Olivier Lartillot, “mirtempo: Tempo estimation through advanced frame-by-frame peaks tracking”, Music Information Retrieval Evaluation eXchange (MIREX 2010).</th></thead><tbody></tbody></table>



<br>
<code>sig.tempo</code> accepts as input data type either:<br>
<ul><li><code>sig.autocor</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li>onset detection curve (resulting from <code>sig.onsets</code>), frame-decomposed or not, channel-decomposed or not,<p>
</li><li>and all the input data accepted by <code>sig.onsets</code>.<p>
<br>
<code>sig.tempo</code> can return several outputs:<br>
</li></ul><ol><li>the tempo itself (or set of tempi) and<p>
</li><li>the <code>sig.spectrum</code> or <code>sig.autocor</code> data, where is highlighted the (set of) peak(s) corresponding to the estimated tempo (or set of tempi).<br>
<br>
The tempo estimation related to the ragtime example<br>
<pre><code>[t ac]=sig.tempo('ragtime')<br>
</code></pre>
leads to a tempo <i>t</i> = 129.1832 bpm and to the following autocorrelation curve <i>ac</i>:</li></ol>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex1.png' />

The frame-decomposed tempo estimation related to the czardas example<br>
<pre><code>[t ac]=sig.tempo('czardas','Frame')<br>
</code></pre>

leads to the following tempo curve <i>t</i>:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex2.png' />

and the following autocorrelation frame decomposition <i>ac</i>:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex3.png' />

￼Below are the results of the analysis of a more challenging example: the first seconds of the first movement of a performance of J.S. Bach's  Brandenburg concert No.2 in F Major, BWV 1047:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex4.png' />

<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex5.png' />

￼￼The classical method generates a tempo curve with a lot of shifts from one metrical level to another.<br>
<br><br>

<h2>2. Metre-Based Version</h2>

<code>sig.tempo(…,'Metre')</code> tracks tempo by building a hierarchical metrical structure (using <code>sig.metre</code>). This enables to find coherent metrical levels leading to a continuous tempo curve.<br>
<br>
When the <code>'Metre'</code> option is used for academic research, please cite the following publication:<br>
<br>
<table><thead><th>Lartillot, O., Cereghetti, D., Eliard, K., Trost, W. J., Rappaz, M.-A., Grandjean, D., "Estimating tempo and metrical features by tracking the whole metrical hierarchy", 3rd International Conference on Music & Emotion, Jyväskylä, 2013.</th></thead><tbody></tbody></table>


<br>
<code>sig.tempo(…,'Metre')</code> accepts as input data type either:<br>
<ul><li><code>sig.autocor</code> objects,<p>
</li><li>onset detection curve (resulting from <code>sig.onsets</code>), frame-decomposed or not, channel-decomposed or not,<p>
</li><li>and all the input data accepted by <code>sig.onsets</code>.<br>
<br>
<code>sig.tempo(…,'Metre')</code> can return several outputs:<p>
</li></ul><ol><li>the tempo itself and<p>
</li><li>the <code>sig.metre</code> representation.<br>
<br>
Below are the results of the analysis of the same excerpt of J.S. Bach's  Brandenburg concert No.2 in F Major, BWV 1047, this time using the 'Metre' option:</li></ol>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex6.png' />

<img src='https://miningsuite.googlecode.com/svn/wiki/SigTempo_ex7.png' />

The metrical structure built using the <code>'Metre'</code> strategy enables to find coherent metrical levels leading to a continuous tempo curve.<br>
<br><br>
<h2>Tempo Change</h2>
<code>sig.tempo(…,'Change')</code> computes the difference between successive values of the tempo curve. Tempo change is expressed independently from the choice of a metrical level by computing the ratio of tempo values between successive frames, and is expressed in logarithmic scale (base 2), so that no tempo change gives a value of 0, increase of tempo gives positive value, and decrease of tempo gives negative value.