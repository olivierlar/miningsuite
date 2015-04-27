# sig.autocor: Autocorrelation function #

Another way to evaluate periodicities in signals (be it an audio waveform, a spectrum, an envelope, etc.) consists in looking at local correlation between samples. If we take a signal x, such as for instance this trumpet sound:<p>
￼<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_ex1.png' />

the autocorrelation function is computed as follows:<p>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_eq1.png' />

For a given lag <i>j</i>, the autocorrelation <i>Rxx(j)</i> is computed by multiplying point par point the signal with a shifted version of it of <i>j</i> samples. We obtain this curve:<p>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_ex1.png' />

Hence when the lag <i>j</i> corresponds to a period of the signal, the signal is shifted to one period ahead, and therefore is exactly superposed to the original signal. Hence the summation gives very high value, as the two signals are highly correlated.<br>
<br>
<br>
<h2>Flowchart Interconnections</h2>

<code>sig.autocor</code> usually accepts either:<br>
<br>
<ul><li>file name(s) or the 'Folder' keyword,<p>
</li><li><code>sig.input</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code>),<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li>data in the onset detection curve category (cf. SigOnsets):<br>
<ul><li><code>sig.envelope</code> objects, frame-decomposed or not,<br>
</li><li>fluxes (cf. SigFlux), frame-decomposed or not,<p>
</li></ul></li><li><code>sig.autocor</code> objects, for further processing.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>mirautocor(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Parameters specification</h2>

<ul><li><code>sig.autocor(…,'Min',</code><i>mi</i><code>)</code> indicates the lowest delay taken into consideration. Default value: 0 s. The unit can be specified:<br>
<ul><li><code>sig.autocor(…,'Min',</code><i>mi,'s'</i><code>)</code> (default unit)<br>
</li><li><code>sig.autocor(…,'Min',</code><i>mi,'Hz'</i><code>)</code></li></ul></li></ul>

<ul><li><code>sig.autocor(…,'Max',</code><i>ma</i><code>)</code> indicates the highest delay taken into consideration. The unit can be specified as for <code>'Min'</code>. Default value:<br>
<ul><li>if the input is an audio waveform, the highest delay is by default 0.05 s (corresponding to a minimum frequency of 20 Hz).<br>
</li><li>if the input is an envelope, the highest delay is by default 2 s.</li></ul></li></ul>

<ul><li><code>sig.autocor(…,'Normal',</code><i>n</i><code>)</code> specifies a normalization option for the cross-correlation (<code>'biased', 'unbiased', 'coeff', 'none'</code>). This corresponds exactly to the normalization options in <i>Matlab xcorr</i> function, as <code>sig.autocor</code> actually calls <i>xcorr</i> for the actual computation. The default value is <i>'coeff'</i>,  corresponding to a normalization so that the autocorrelation at zero lag is identically 1. If the data is multi-channel, the normalization is such that the sum over channels at zero lag becomes identically 1. Note however that the <code>'coeff'</code> routine is not used when the compression (<code>'Compres'</code>) factor <i>k</i> is not equal to 2 (see below).</li></ul>

<br>
<h2>Post-processing options</h2>

<ul><li><code>sig.autocor(…,'Freq')</code> represents the autocorrelation function in the frequency domain: the periods are expressed in Hz instead of seconds (see the last curve in the figure below for an illustration).</li></ul>

<ul><li><code>sig.autocor(…,'NormalWindow')</code> divides the autocorrelation by the autocorrelation of the window. Boersma (1993) shows that by default the autocorrelation function gives higher coefficients for small lags, since the summation is done on more samples. Thus by dividing by the autocorrelation of the window, we normalize all coefficients in such a way that this default is completely resolved. At first sight, the window should simply be a simple rectangular window. But Boersma (1993) shows that it is better to use <code>'hanning'</code> window in particular, in order to obtain better harmonic to noise ratio.<br>
<ul><li><code>sig.autocor(…,'NormalWindow',</code><i>w</i><code>)</code> specifies the window to be used, which can be any window available in the Signal Processing Toolbox. Besides w = 'rectangular' will not perform any particular windowing (corresponding to a rectangular (“invisible”) window), but the normalization of the autocorrelation by the autocorrelation of the invisible window will be performed nonetheless. The default value is <i>w</i> = <code>'hanning'</code>.<br>
</li><li><code>sig.autocor(…,'NormalWindow','off')</code> toggles off this normalization (which is <code>'on'</code> by default).</li></ul></li></ul>

<ul><li><code>sig.autocor(…,'Halfwave')</code> performs a half-wave rectification on the result, in order to just show the positive autocorrelation coefficients.</li></ul>

<br>
<h2>Generalized autocorrelation</h2>

<code>sig.autocor(…,'Compres',</code><i>k</i><code>)</code> – or equivalently <code>sig.autocor(…,'Generalized',</code><i>k</i><code>)</code> – computes the autocorrelation in the frequency domain and includes a magnitude compression of the spectral representation. Indeed an autocorrelation can be expressed using Discrete Fourier Transform as:<br>
<br>
<i>y = IDFT(|DFT(x)|<sup>2</sup>),</i>

which can be generalized as:<br>
<br>
<i>y = IDFT(|DFT(x)|<sup>k</sup>)</i>

Compression of the autocorrelation (i.e., setting a value of <i>k</i> lower than 2) are recommended in (Tolonen & Karjalainen, 2000) because this decreases the width of the peaks in the autocorrelation curve, at the risk however of increasing the sensitivity to noise. According to this study, a good compromise seems to be achieved using value <i>k</i> = .67. By default, no compression is performed (hence <i>k</i> = 2), whereas if the <code>'Compress'</code> keyword is used, value <i>k</i> = .67 is set by default if no other value is indicated.<br>
<br>
<br>
<h2>Enhanced autocorrelation</h2>
In the autocorrelation function, for each periodicity in the signal, peaks will be shown not only at the lag corresponding to that periodicity, but also to all the multiples of that periodicity. In order to avoid such redundancy of information, techniques have been proposed that automatically remove these harmonics. In the frequency domain, this corresponds to sub-harmonics of the peaks.<br>
<br>
<code>sig.autocor(…,'Enhanced',</code><i>a</i><code>)</code>: The original autocorrelation function is half-wave rectified, time-scaled by factor a (which can be a factor list as well), and subtracted from the original clipped function (Tolonen & Karjalainen, 2000). If the <code>'Enhanced'</code> option is not followed by any value, the default value is <i>a</i> = 2:10, i.e., from 2 to 10.<br>
<br>
If the curve does not start from zero at low lags but begins instead with strictly positive values, the initial discontinuity would be propagated throughout all the scaled version of the curve. In order to avoid this phenomenon, the curve is modified in two successive ways:<br>
<ul><li>if the curve starts with a descending slope, the whole part before the first local minimum is removed from the curve,<p>
</li><li>if the curve starts with an ascending slope, the curve is prolonged to the left following the same slope but which is increased by a factor of 1.1 at each successive bin, until the curve reaches the x-axis.</li></ul>

See the figure below for an example of enhanced autocorrelation when computing the pitch content of a piano <i>Amin3</i> chord, with the successive step of the default enhancement, as used by default in <code>sig.pitch</code> (cf. description of SigPitch).<p>

<table><thead><th> 1. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_enhanced1.png' />  </th><th> 2. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_enhanced2.png' /> </th></thead><tbody></tbody></table>

<table><thead><th> 3. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_enhanced3.png' /> </th><th> 4. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_enhanced4.png' /> </th></thead><tbody></tbody></table>

<table><thead><th> 5. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_enhanced5.png' /> </th><th> 6. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_enhanced6.png' /> </th></thead><tbody></tbody></table>

<table><thead><th> 7. <img src='https://miningsuite.googlecode.com/svn/wiki/SigAutocor_freqenhanced.png' /> </th></thead><tbody></tbody></table>

<ul><li><i>Fig 1: Waveform autocorrelation of a piano chord Amaj3 (blue), and scaled autocorrelation of factor 2 (red);<br>
</li><li>Fig 2: Subtraction of the autocorrelation by the previous scaled autocorrelation (blue), scaled autocorrelation of factor 3 (red);<br>
</li><li>Fig 3: Resulting subtraction (blue), scaled autocorrelation of factor 4(red);<br>
</li><li>Fig 4: Idem for factor 5;<br>
</li><li>Fig 5: Idem for factor 6;<br>
</li><li>Fig 6: Idem for factor 7;<br>
</li><li>Fig 7: Resulting autocorrelation curve in the frequency domain and peak picking</i></li></ul>

<br>

<h2>Music-theory based model</h2>

Music-theory representation of autocorrelation function is available in <a href='MusAutocor.md'>mus.autocor</a>.<br>
<br>
<br>
<h2>Accessible Output</h2>
cf. §5.2 for an explanation of the use of the <code>'get'</code> method. Specific fields:<br>
<ul><li><code>'Coeff'</code>: the autocorrelation coefficients (same as <code>'Data'</code>),<p>
</li><li><code>'Lag'</code>: the lags (same as <code>'Pos'</code>),<p>
</li><li><code>'FreqDomain'</code>: whether the lags are in s. (0) or in Hz. (1),<p>
</li><li><code>'OfSpectrum'</code>: whether the input is a temporal signal (0), or a spectrum (1),<p>
</li><li><code>'Window'</code>: contains the complete envelope signal used for the windowing,<p>
</li><li>`'Resonance': indicates the resonance curve that has been applied, or empty string if no resonance curve has been applied.