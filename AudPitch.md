# aud.pitch: Pitch estimation #

Extract pitches, returned either as continuous pitch curves or as discretized note events.
<br><br>

<h2>Flowchart Interconnections</h2>

The pitch content can be estimated in various ways:<br>
<ul><li><code>aud.pitch(…,'Autocor')</code> computes an autocorrelation function of the audio waveform, using <code>sig.autocor</code>. This is the default strategy. Options related to <code>sig.autocor</code> can be specified:<p>
<ul><li><code>'Enhanced'</code>, toggled on by default here,<br>
</li><li><code>'Compress'</code>, set by default to .5,<br>
</li><li>filterbank configuration can be specified: either <code>'2Channels'</code> (default configuration), <code>'Gammatone'</code> or <code>'NoFilterbank'</code>,<br>
</li><li>if a filterbank is used, <code>'Sum'</code> specifies whether the channels are recombined once the autocorrelation function is computed (<code>'Sum', 1</code>, which is the default), or if on the contrary, the channels are kept separate, and pitch content is extracted in each channel separately (<code>'Sum', 0</code>).<p>
</li></ul></li><li><code>aud.pitch(…,'Spectrum')</code> computes the FFT spectrum (<code>sig.spectrum</code>).<p>
</li><li><code>aud.pitch(…,'AutocorSpectrum')</code> computes the autocorrelation (<code>sig.autocor</code>) of the FFT spectrum (<code>sig.spectrum</code>).<p>
</li><li><code>aud.pitch(…,'Cepstrum')</code> computes the cepstrum (<code>sig.cepstrum</code>).<p>
</li><li>These methods can be combined. In this case, the resulting representations (autocorrelation function or cepstral representations) are all expressed in the frequency domain and multiplied altogether.<br>
<br>
Then a peak picking is applied to the autocorrelation function or to the cepstral representation. The parameters of the peak picking can be tuned.<br>
</li><li><code>aud.pitch(…,'Total',</code><i>m</i><code>)</code> selects only the <i>m</i> best pitches.<p>
</li><li><code>aud.pitch(…,'Mono')</code> only select the best pitch, corresponding hence to: <code>aud.pitch(…,'Total',1)</code>.<p>
</li><li><code>aud.pitch(…,'Min',</code><i>mi</i><code>)</code> indicates the lowest pitch taken into consideration, in Hz. Default value: 75 Hz, following a convention in the Praat software (Boersma & Weenink, 2005).<p>
</li><li><code>aud.pitch(…,'Max',</code><i>ma</i><code>)</code> indicates the highest pitch taken into consideration, expressed in Hz. Default value: 2400 Hz, because there seem to be some problems with higher frequency, due probably to the absence of pre-whitening in our implementation of Tolonen and Karjalainen autocorrelation approach (used by default).<p>
</li><li><code>aud.pitch(…,'Threshold',</code><i>t</i><code>)</code> specifies the threshold factor for the peak picking. Default value: <i>t</i> = 0.4.<p>
</li><li><code>aud.pitch(…,'Contrast',</code><i>c</i><code>)</code> specifies the contrast factor for the peak picking. Default value: <i>c</i> = 0.1.<p>
</li><li><code>aud.pitch(…,'Order',</code><i>o</i><code>)</code> specifies the ordering for the peak picking. Default value: <i>o</i> = <code>'Amplitude'</code>.<br>
<br>
<code>aud.pitch</code> accepts as input data type either:<br>
</li><li><code>aud.pitch</code> objects,<p>
</li><li>output of <code>sig.peaks</code> computation,<p>
</li><li><code>sig.autocor</code> objects,<p>
</li><li><code>sig.cepstrum</code> objects,<p>
</li><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects, where the audio waveform can be:<p>
<ul><li>segmented (using <code>sig.segment</code>),<br>
</li><li>when pitch is estimated by autocorrelating the audio waveform (<code>'Autocor'</code> strategy), the audio waveform is be default first decomposed into channels (cf. the <code>'Filterbank'</code> option below),<br>
</li><li>decomposed into frames or not (using <code>sig.frame</code>);<br>
</li><li>file name(s) or the <code>'Folder'</code> keyword: same behavior than for <code>sig.input</code> objects,<br>
</li><li><code>sig.midi</code> objects.<br>
<br>
aud.pitch can return several outputs:<br>
</li></ul></li></ul><ol><li>the pitch frequencies themselves, and<p>
</li><li>the <code>sig.autocor</code> or  <code>sig.cepstrum</code> data, where is highlighted the (set of) peak(s) corresponding to the estimated pitch (or set of pitches).<br>
<br></li></ol>

<h2>Frame decomposition</h2>

<code>aud.pitch(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 46.4 ms and a hop factor of 10 ms (Tolonen & Karjalainen, 2000). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>

<h2>Post-Processing Options</h2>
<ul><li><code>aud.pitch(…,'Cent')</code> convert the pitch axis from Hz to cent scale. One octave corresponds to 1200 cents, so that 100 cents correspond to a semitone in equal temperament.<p>
</li><li><code>aud.pitch(…,'Segment')</code> segments the obtained monodic<sup>*</sup> pitch curve in cents as a succession of notes with stable frequencies.</li></ul>

When <code>'Segment'</code> is used for academic research, please cite the following publication:<br>
<table><thead><th>Olivier Lartillot, “Computational analysis of maqam music: From audio transcription to musicological analysis, everything is tightly intertwined”, Acoustics 2012 Hong Kong Conference.</th></thead><tbody></tbody></table>

<ul><li><code>aud.pitch(…,'SegMinLength',</code><i>l</i><code>)</code> specifies the minimum length of segments, in number of samples. Default length: <i>l</i> = 7 samples.<p>
</li><li><code>aud.pitch(…,'SegPitchGap',</code><i>g</i><code>)</code> specifies the maximum tolerated pitch gap within a segment, in cents. The pitch distance is computed between the current sample is more distant and the average pitch of the segment before that point. Default gap: <i>g</i> = 10 cents.<p>
</li><li><code>aud.pitch(…,'SegTimeGap',</code><i>g</i><code>)</code> specifies the maximum tolerated silence within a segment, in number of samples. Default gap: <i>g</i> = 20 samples.<p>
</li><li>Segments with too low pitch periodicity (of autocorrelation value lower than 5% of the maximal value in that audio piece) are discarded.<br>
</li></ul><ul><li><code>aud.pitch(…,'Median',</code><i>l</i><code>)</code> performs a median filtering of the pitch curve. The length of the median filter is given by <i>l</i> (in s.). Its default value is .1 s. The median filtering can only be applied to mono-pitch curve. If several pitches were extracted in each frame, a mono-pitch curve is first computed by selecting the best peak of each successive frame.<p>
</li><li><code>aud.pitch(…,'Stable',</code><i>th</i><code>,</code><i>n</i><code>)</code> remove pitch values when the difference (or more precisely absolute logarithmic quotient) with the <i>n</i> precedent frames exceeds the threshold <i>th</i>.<br>
<ul><li>if <i>th</i> is not specified, the default value .1 is used.<br>
</li><li>if <i>n</i> is not specified, the default value 3 is used.<p>
</li></ul></li><li><code>aud.pitch(…,'Reso','SemiTone')</code> removes peaks whose distance to one or several higher peaks is lower than a given threshold 2<sup>(1/12)</sup> (corresponding to a semitone).<p></li></ul>

<sup>*</sup> This <code>'Segment'</code> option requires a monodic pitch curve extraction using the <code>'Mono'</code> option, which is therefore toggled on, as well as the <code>'Cent'</code> and <code>'Frame'</code> options.<br>
<br>
<br>

<h2>Preset Model</h2>
<ul><li><code>aud.pitch(…,'Tolonen')</code> implements (part of) the model proposed in (Tolonen & Karjalainen, 2000). It is equivalent to:<br>
<pre><code>aud.pitch(…, 'Enhanced', 2:10, 'Generalized', .67, '2Channels')<br>
</code></pre>
<br>
<h2>Example</h2>
<pre><code>[p ac] = aud.pitch('ragtime', 'Frame')<br>
</code></pre></li></ul>


<img src='https://miningsuite.googlecode.com/svn/wiki/SigPitch_ex1.png' /><p>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigPitch_ex2.png' />

<br>
<h2>￼￼Accessible Output</h2>

cf. §5.2 for an explanation of the use of the get method. Specific fields:<br>
<ul><li><code>'Amplitude'</code>: the amplitude associated with each pitch component.<br>
<br></li></ul>

<h2>Importation of Pitch Data</h2>

<code>aud.pitch(</code><i>f</i><code>,</code><i>a</i><code>,</code><i>r</i><code>)</code> creates a <code>aud.pitch</code> object based on the frequencies specified in <i>f</i> and the related amplitudes specified in <i>a</i>, using a frame sampling rate of <i>r</i> Hz (set by default to 100 Hz).<br>
<br>
Both <i>f</i> and <i>a</i> can be either:<br>
<br>
<ul><li>a matrix where each column represent one pitch track and lines corresponds to frames,<p>
</li><li>an array of cells, where each cell, representing one individual frame, contains a vector.