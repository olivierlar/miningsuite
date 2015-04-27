# sig.pulseclarity: Estimating rhythmic clarity #

Estimates the rhythmic clarity, indicating the strength of the beats estimated by the `sig.tempo` function.

When `sig.pulseclarity` is used for academic research, please cite the following publication:

|Olivier Lartillot, Tuomas Eerola, Petri Toiviainen, Jose Fornari, "Multi-feature modeling of pulse clarity: Design, validation, and optimization", International Conference on Music Information Retrieval, Philadelphia, 2008.|
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<br>
<h2>Flowchart Interconnections</h2>

The pulse clarity can be estimated in various ways:<br>
<br>
<ul><li><code>sig.pulseclarity(…,</code><i>s</i><code>)</code> selects a particular heuristic for pulse clarity estimation. Most heuristics are based on the autocorrelation curve computed for tempo estimation (i.e., the second output of <code>sig.tempo</code>) (Lartillot, Eerola, Toiviainen, and Fornari, 2008):<p>
<ul><li><i>s</i> = <code>'MaxAutocor'</code> selects the maximum correlation value in the autocorrelation curve (default heuristic).<br>
</li><li><i>s</i> = <code>'MinAutocor'</code> selects the minimum correlation value in the autocorrelation curve.<br>
</li><li><i>s</i> = <code>'MeanPeaksAutocor'</code> averages the local maxima in the autocorrelation curve.<br>
</li><li><i>s</i> = <code>'KurtosisAutocor'</code> computes the kurtosis of the autocorrelation curve.<br>
</li><li><i>s</i> = <code>'EntropyAutocor'</code> computes the entropy of the autocorrelation curve.<br>
</li><li><i>s</i> = <code>'InterfAutocor'</code> computes the harmonic relations between pulsations.<br>
</li><li><i>s</i> = '<code>TempoAutocor'</code> selects the tempo related to the highest autocorrelation.<br>
</li></ul><blockquote>Others heuristics are based more simply on the onset curve itself:<br>
</blockquote><ul><li><i>s</i> = <code>'Articulation'</code> estimates the average silence ratio of the onset curve (option <code>'ASR'</code> in <code>sig.lowenergy</code>).<br>
</li><li><i>s</i> = <code>'Attack'</code> averages the attack slopes of all onsets (the <code>'Diff'</code>, <code>'Gauss'</code> can be specified, with same default).<br>
</li><li><i>s</i> = <code>'ExtremEnvelope'</code> estimates the total amplitude variability of the onset curve.<br>
</li></ul><blockquote><code>sig.pulseclarity(…,'Model',</code><i>m</i><code>)</code> selects one out of two possible models that have been found as optimal in our experiments<br>(Lartillot, Eerola, Toiviainen, and Fornari, 2008):<br>
</blockquote><ul><li><i>m</i> = 1 selects the default model with its associated weight.<br>
</li><li><i>m</i> = 2 selects the following model: <code>'Gammatone'</code>, no log, no <code>'Resonance'</code>, <code>'Lambda'</code> set to .8, and <code>'Sum'</code> set to <code>'After'</code>, with its associated weight.<br>
</li><li><i>m</i> = <a href='1.md'>2</a> sums the two models altogether.<br>
<br><br>
The onset detection curve computed in <code>sig.onsets</code> can be controlled using the following options:</li></ul></li></ul>

<ul><li><code>'Envelope'</code> (default) and <code>'DiffEnvelope'</code>:<p>
<ul><li>with the <code>'Method'</code> set by default to <code>'Spectro'</code>, and the <code>'Freq'</code>, <code>'Mel'</code>, <code>'Bark'</code>, <code>'Cents'</code> selection can be specified, with same default.<p>
</li><li><code>'Method'</code> can be set to <code>'Filter'</code> as well:<br>
<ul><li>with <code>'FilterType'</code> option with same default,<br>
</li><li>with <code>'Filterbank'</code> option set to 20 by default,<br>
</li><li>with <code>'FilterbankType'</code> option set to 'Scheirer' by default,<p>
</li></ul></li><li>Besides <code>'Method'</code>: <code>'HalfwaveDiff'</code>, <code>'Lambda'</code>, <code>'Smooth'</code>, <code>'Log'</code> with same default, and <code>'Mu'</code>, set by default here to 100.<p>
</li></ul></li><li><code>'SpectralFlux'</code>: with <code>'Inc'</code> with same default, and <code>'Median'</code> and <code>'Halfwave'</code> toggled off by default,<p>
</li><li>and <code>'Pitch'</code>.<br>
<br><br>
The autocorrelation function performed in <code>sig.autocor</code> can be controlled using the following options:</li></ul>

<ul><li><code>'Enhanced'</code> (toggled off by default; forced to <code>'Off'</code> in <code>'MinAutocor'</code>),<p>
</li><li><code>'Resonance'</code>, <code>'Min'</code>, <code>'Max'</code> (with same default as in <code>sig.autocor</code>).<br>
<br><br>
Some further options operates as in <code>sig.tempo</code>:<br>
</li><li><code>'Sum'</code>,<p>
</li><li><code>'Total'</code> (ignored in <code>'MaxAutocor'</code>, <code>'MinAutocor'</code> and <code>'EntropyAutocor'</code> methods),<p>
</li><li><code>'Contrast'</code>: with a default value set to .01,<br>
<br><br>
<code>sig.pulseclarity</code> accepts as input data type either:<br>
</li><li><code>sig.autocor</code> objects,<p>
</li><li>onset detection curve (resulting from <code>sig.onsets</code>), frame-decomposed or not, channel-decomposed or not,<p>
</li><li>and all the input data accepted by <code>sig.onsets</code>.<br>
<br><br>
<code>sig.pulseclarity</code> can return several outputs:<br>
</li></ul><ol><li>the pulse clarity value and<p>
</li><li>the <code>sig.autocor</code> data that was used for the estimation of pulse clarity.<br>
<br><br></li></ol>

<h2>Frame decomposition</h2>
<code>sig.pulseclarity(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 5 s and a hop factor of 10% (0.5 s). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.