# sig.spectrum: Fourier transform #

A decomposition of the energy of a signal (be it an audio waveform, or an envelope, etc.) along frequencies can be performed using a Discrete Fourier Transform, which, for an audio signal x has for equation:<p>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_eq1.png' /></blockquote>

This decomposition is performed using a Fast Fourier Transform by the `sig.spectrum function by calling Matlab <i>fft</i> function. The graph returned by the function highlights the repartition of the amplitude of the frequencies (i.e., the modulus of <i>Xk</i> for all <i>k</i>), such as the following:<p>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex1.png' />

We can also obtain for each frequency the actual phase position (i.e., the phase of <i>Xk</i>), which indicates the exact position of each frequency component at the instant <i>t = 0</i>. If the result of the spectrum decomposition is s, the phase spectrum is obtained by using the command:<br>
<br>
<pre><code>get(s,'Phase')<br>
</code></pre>

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.spectrum</code> accepts as input data type either:<br>
<br>
<ul><li><code>sig.input</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code>);<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword;<p>
</li><li>data in the onset detection curve category (cf. SigOnset):<p>
</li><li><code>sig.envelope</code> objects, frame-decomposed or not,<p>
</li><li>fluxes (cf. SigFlux), frame-decomposed or not;<p>
</li><li><code>sig.spectrum</code> frame-decomposed objects: by calling again <code>sig.spectrum</code> with the <code>'AlongBands'</code> option, Fourier transforms are computed this time on each temporal signal related to each separate frequency bin (or frequency band, cf. below).</li></ul>

<br>
<h2>Frame decomposition</h2>
<code>sig.spectrum(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Parameters specification</h2>
The range of frequencies, in Hz, can be specified by the options:<br>
<br>
<ul><li><code>sig.spectrum(…,'Min',</code><i>mi</i><code>)</code> indicates the lowest frequency taken into consideration, expressed in Hz. Default value: 0 Hz.<p>
</li><li><code>sig.spectrum(…,'Max',</code><i>ma</i><code>)</code> indicates the highest frequency taken into consideration, expressed in Hz. Default value: the maximal possible frequency, corresponding to the sampling rate divided by 2.<p>
</li><li><code>sig.spectrum(…,'Window',</code><i>w</i><code>)</code> specifies the windowing method. Windows are used to avoid the problems due to the discontinuities provoked by finite signals. Indeed, an audio sequence is not infinite, and the application of the Fourier Transform requires to replace the infinite time before and after the sequence by zeroes, leading to possible discontinuities at the borders. Windows are used to counteract those discontinuities. Possible values for <i>w</i> are either <i>w = 0</i> (no windowing) or any windowing function proposed in the <i>Signal Processing Toolbox<sup>*</sup></i>. Default value: <i>w</i> = <code>'Hamming'</code>, the Hamming window being a particular good window for Fourier Transform.<p>
</li><li><code>sig.spectrum(…,'NormalInput')</code> normalizes the waveform between 0 and 1 before computing the Fourier Transform.<p>
</li><li><code>sig.spectrum(…,'Phase','No')</code> does not compute the related FFT phase. The FFT phase is not computed anyway whenever another option that will make the phase information irrelevant (such as <code>'Log','dB'</code>, etc.) is specified.<br>
</li></ul><blockquote><sup>*</sup> The list of possible window arguments can be found in the <i>window</i> documentation:<br>
<pre><code>help window<br>
</code></pre></blockquote>

<br>
<h2>Resolution specification</h2>

The frequency resolution of the spectrum directly depends on the size of the audio waveform: the longer the waveform, the better the frequency resolution. It is possible, however, to increase the frequency resolution of a given audio waveform by simply adding a series of zeros at the end of the sequence, which is called <i>zero-padding</i>. Besides, an optimized version of the Discrete Fourier Transform, called Fast Fourier Transform (FFT) can be performed if the length of the audio waveform (including the zero-padding) is a power of 2. For this reason, by default, a zero-padding is performed by default in order to ensure that the length of the audio waveform is a power of 2. But these operations can be tuned individually:<br>
<br>
<ul><li><code>sig.spectrum(…,'MinRes',</code><i>mr</i><code>)</code> adds a constraint related to the a minimal frequency resolution, fixed to the value <i>mr</i> (in Hz). The audio waveform is automatically zero-padded to the lowest power of 2 ensuring the required frequency resolution.</li></ul>

<ul><li><code>sig.spectrum(…,'MinRes',</code><i>r</i><code>,'OctaveRatio',</code><i>tol</i><code>)</code>: Indicates the minimal accepted resolution in terms of number of divisions of the octave. Low frequencies are ignored in order to reach the desired resolution. The corresponding required frequency resolution is equal to the difference between the first frequency bins, multiplied by the constraining multiplicative factor <i>tol</i> (set by default to .75).</li></ul>

<ul><li><code>sig.spectrum(…,'Res',</code><i>r</i><code>)</code> specifies the frequency resolution <i>r</i> (in Hz) that will be secured as closely as possible, through an automated zero-padding. The length of the resulting audio waveform will not necessarily be a power of 2, therefore the FFT routine will rarely be used.</li></ul>

<ul><li><code>sig.spectrum(…,'Length',</code><i>l</i><code>)</code> specifies the length of the audio waveform after zero-padding. If the length is not a power of 2, the FFT routine will not be used.</li></ul>

<ul><li><code>sig.spectrum(…,'ZeroPad',</code><i>s</i><code>)</code> performs a zero-padding of s samples. If the total length is not a power of 2, the FFT routine will not be used.</li></ul>

<ul><li><code>sig.spectrum(…,'WarningRes',</code><i>mr</i><code>)</code> indicates a required frequency resolution, in Hz, for the input signal. If the resolution does not reach that prerequisite, a warning is displayed.</li></ul>

Alternatively, the spectrum decomposition can be performed through a Constant Q Transform instead of a FFT, which enables to express the frequency resolution as a constant number of bins per octave:<br>
<br>
<ul><li><code>sig.spectrum(…,'ConstantQ',</code><i>nb</i><code>)</code> fixes the number of bins per octave to <i>nb</i>. Default value when the <code>'ConstantQ'</code> option is toggled on: <i>nb</i> = 12 bins per octave.</li></ul>

Please note however that the Constant Q Transform is implemented as a <i>Matlab</i> M file, whereas <i>Matlab's</i> FFT algorithm is optimized, therefore faster.<br>
<br>
<br>

<h2>Post-processing options</h2>

<ul><li><code>sig.spectrum(…,'Normal')</code> normalizes with respect to energy: each magnitude is divided by the euclidian norm (root sum of the squared magnitude).</li></ul>

<ul><li><code>sig.spectrum(…,'NormalLength')</code> normalizes with respect to the duration (in s.) of the audio input data.</li></ul>

<ul><li><code>sig.spectrum(…,'Power')</code> squares the energy: each magnitude is squared.</li></ul>

<ul><li><code>sig.spectrum(…,'dB')</code> represents the spectrum energy in decibel scale. For the previous example we obtain the following spectrum:<p></li></ul>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex2.png' /></blockquote>

<ul><li><code>sig.spectrum(…,'dB',</code><i>th</i><code>)</code> keeps only the highest energy over a range of <i>th</i> dB. For example if we take only the 20 most highest dB in the previous example we obtain:<p></li></ul>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex3.png' /></blockquote>

<ul><li><code>sig.spectrum(…,'Smooth',</code><i>o</i><code>)</code> smooths the spectrum curve using a moving average of order <i>o</i>. Default value when the option is toggled on: <i>o</i> = 10</li></ul>

<ul><li><code>sig.spectrum(…,'Gauss',</code><i>o</i><code>)</code> smooths the spectrum curve using a gaussian of standard deviation <i>o</i> samples. Default value when the option is toggled on: <i>o</i> = 10</li></ul>

<ul><li><code>sig.spectrum(…,'TimeSmooth',</code><i>o</i><code>)</code> smooths each frequency channel of a spectrogram using a moving average of order <i>o</i>. Default value when the option is toggled on: <i>o</i> = 10</li></ul>

<br>

<h2>Harmonic spectral analysis</h2>

A lot of natural sounds, especially musical ones, are harmonic: each sound consists of a series of frequencies at a multiple ratio of the one of lowest frequency, called fundamental. Techniques have been developed in signal processing to reduce each harmonic series to its fundamental, in order to simplify the representation. <i>MiningSuite</i> includes two related techniques for the attenuation of harmonics in spectral representation (Alonso et al, 2003):<br>
<br>
<ul><li><code>sig.spectrum(…,'Prod',</code><i>m</i><code>)</code> Enhances components that have harmonics located at multiples of range(s) <i>m</i> of the signal's fundamental frequency. Computed by compressing the signal by a list of factors <i>m</i>, and by multiplying all the results with the original signal. Default value is <i>m</i> = 1:6. Hence for this initial spectrum:</li></ul>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex8.png' /></blockquote>

we obtain this reduced spectrum:<br>
<br>
<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex9.png' /></blockquote>

<ul><li><code>sig.spectrum(…,'Sum',</code><i>m</i><code>)</code> Similar idea using addition of the multiples instead of multiplication.</li></ul>

<br>
<h2>Auditory model</h2>

Auditory models related spectrum decomposition are available in <a href='AudSpectrum.md'>aud.spectrum</a>.<br>
<br>
<br>
<h2>Music-theory based model</h2>

Music-theory transformations related to spectrum decomposition are available in <a href='MusSpectrum.md'>mus.spectrum</a>.<br>
<br>
<br>
<h2>Accessible Output</h2>

<ul><li><code>phase</code>: the phase associated to each bin,</li></ul>

<ul><li><code>power</code>: whether the spectrum has been squared (1) or not (0),</li></ul>

<ul><li><code>log</code>: whether the spectrum is in log-scale (1) or in linear scale (0).