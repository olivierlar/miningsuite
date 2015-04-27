# sig.entropy: Relative entropy of the data #

`sig.entropy` returns the relative Shannon (1948) entropy of the input. The Shannon entropy, used in information theory, is based on the following equation:

![https://miningsuite.googlecode.com/svn/wiki/SigEntropy_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigEntropy_eq1.png)

where _b_ is the base of the logarithm.

In order to obtain a measure of entropy that is independent on the sequence length, `sig.entropy` actually returns the relative entropy, computed as follows:

![https://miningsuite.googlecode.com/svn/wiki/SigEntropy_eq2.png](https://miningsuite.googlecode.com/svn/wiki/SigEntropy_eq2.png)

Shannon entropy offers a general description of the input curve _p_, and indicates in particular whether it contains predominant peaks or not. Indeed, if the curve is extremely flat, corresponding to a situation of maximum uncertainty concerning the output of the random variable _X_ of probability mass function _p(xi)_, then the entropy is maximal. Reversely, if the curve displays only one very sharp peak, above a flat and low background, then the entropy is minimal, indicating a situation of minimum uncertainty as the output will be entirely governed by that peak.

The equation of Shannon entropy can only be applied to functions _p(xi)_ that follow the characteristics of a probability mass function: all the values must be non-negative and sum up to 1. Inputs of `sig.entropy` are transformed in order to respect these constraints:

  * The non-negative values are replaced by zeros (i.e., half-wave rectification).<p>
<ul><li>The remaining data is scaled such that it sums up to 1.</li></ul>


<br>
<h2>Flowchart Interconnections</h2>

<code>sig.entropy</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>)<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>'Frame'</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Inputs</h2>
Any data can be used as input.<br>
<br>
If the input is an audio waveform, a file name, or the <code>'Folder'</code> keyword, the entropy is computed on the spectrum (spectral entropy).<br>
<br>
<br>
<h2>Options</h2>
<ul><li><code>sig.entropy(…,'Center')</code> centers the input data before half-wave rectification.<p>
</li><li><code>sig.entropy(…,'MinRMS',</code><i>m</i><code>)</code>, when the input is an audio waveform, a spectrum or a cepstrum, specifies the threshold <i>m</i>, as a value from 0 to 1, for the detection of quasi-silent frames, for which no value is given. For a given frame, if the RMS of the input (for spectral entropy, the input is each frame of the spectrogram, etc.) is below <i>m</i> times the highest RMS value over the frames, NaN is returned. default value: <i>m</i> = .005