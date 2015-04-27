# aud.fluctuation: Rhythmic periodicity along auditory channels #

One way of estimating the rhythmic is based on spectrogram computation transformed by auditory modeling and then a spectrum estimation in each band (Pampalk et al., 2002).
The implementation proposed in MiningSuite includes a subset of the series of operations proposed in Pampalk et al.:

**1. First a power spectrogram is computed**

  * on frames of 23 ms with a hop rate _hr_, set by default to 80 Hz, but is automatically raised to the double of the maximum fluctuation frequency range _m_, used in step 2.<p>
<ul><li>The Terhardt outer ear modeling is computed.<p>
</li><li>A multi-band redistribution of the energy is performed along the 'Bark' bands decomposition.<br>
<ul><li><code>aud.fluctuation(…,'Mel')</code>  performs a decomposition into 40 Mel bands instead of 20 Bark bands.<p>
</li></ul></li><li>Masking effects are estimated on the multi-band distribution.<p>
</li><li>Finally the amplitudes are represented in dB scale.</li></ul>

This is summarized in one MiningSuite command line:<br>
<pre><code>s=aud.spectrum(…,'Frame',.023,'s',hr,'Hz',…<br>
  'Power','Terhardt',b,'Mask','dB')<br>
</code></pre>

where <i>b</i> is either <code>'Bark'</code> or <code>'Mel</code>'.<br>
<br>
<br>
<b>2. Then a FFT is computed on each band:</b>
<ul><li>Frequencies range from 0 to m Hz, where m is set by default to 10 Hz can be controlled by a <code>'Max'</code> option:<br><code>aud.fluctuation(…,'Max',</code><i>m</i><code>)</code><p>
</li><li>The frequency resolution of the FFT mr is set by default to .01 Hz and can also be controlled by a <code>'MinRes'</code> option:<br><code>aud.fluctuation(…,'MinRes',</code><i>mr</i><code>)</code><p>
</li><li>The amplitude modulation coefficients are weighted based on the psychoacoustic model of the fluctuation strength (Fastl, 1982).</li></ul>

This is summarized in one MiningSuite command line:<br>
<pre><code>f=aud.spectrum(s,'AlongBands','Max',m,'MinRes',mr,'Window',0,…<br>
  'Resonance','Fluctuation','NormalLength')<br>
</code></pre>

We can see in the matrix the rhythmic periodicities for each different Bark band.<br>
<br>
<br>
<b>3. <code>aud.fluctuation(…,'Summary')</code></b> subsequently sums the resulting spectrum across bands, leading to a spectrum summary, showing the global repartition of rhythmic periodicities:<br>
<pre><code>sig.sum(f)<br>
</code></pre>

<br>
<h2>Flowchart Interconnections</h2>

<code>aud.fluctuation</code> accepts as input data type either:<p>
<ul><li><code>sig.Spectrum</code> frame-decomposed objects (i.e., spectrograms),<p>
</li><li><code>sig.signal</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>). The audio waveform is decomposed into frames if it was not decomposed yet.<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword: same behavior than for <code>sig.signal</code> objects.</li></ul>

<br>
<h2>Frame decomposition</h2>

<ul><li><code>aud.fluctuation(…,'InnerFrame',</code><i>l</i><code>,</code><i>r</i><code>)</code> specifies the spectrogram frame length <i>l</i> (in second), and, optionally, the frame rate <i>r</i> (in Hertz), with by default a frame length of 23 ms and a frame rate of 80 Hz.<p>
</li><li><code>aud.fluctuation(…,'OuterFrame',</code><i>l</i><code>,</code><i>h</i><code>)</code> computes fluctuation using a window moving along the spectrogram, whose length <i>l</i> (in second) and frame rate <i>r</i> (in Hertz) can be specified as well, with by default a frame length of 1 s and a frame rate of 10 Hz.