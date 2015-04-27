# mus.chromagram: Energy distribution along pitches #

The chromagram, also called Harmonic Pitch Class Profile, shows the distribution of energy along the pitches or pitch classes.
<br><br>
<ul><li>First the spectrum is computed in the logarithmic scale, with selection of, by default, the 20 highest dB, and restriction to a certain frequency range that covers an integer number of octaves, and normalization of the audio waveform before computation of the FFT.<br>
<pre><code>s=sig.spectrum(…,'dB',20,'Min',fmin,'Max',fmax,'NormalInput','MinRes',r,'OctaveRatio',.85)<br>
</code></pre>
<ul><li>The minimal frequency <i>fmin</i> is specified by the <code>'Min'</code> option (cf. below).<br>
</li><li>The maximal frequency <i>fmax</i> is at least equal to the <code>'Max'</code> option, but the frequency range is extended if necessary in order to obtain an integer number of octaves.<br>
</li><li>The minimal frequency resolution of the spectrum is chosen such that even lowest chromas will be segregated from the spectrum. It is based on the number of chromas per octave <i>r</i> (<code>'Res'</code> option , cf. below). Lowest frequencies are ignored if they do not meet this resolution constraint, and a warning message is sent by <code>sig.spectrum</code> (cf. <code>'OctaveRatio'</code> keyword).<p>
</li></ul><blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigChromagram_ex1.png' />
</blockquote></li><li>￼The chromagram is a redistribution of the spectrum energy along the different pitches (i.e., “chromas”):<br>
<pre><code>c=mus.chromagram(s,'Wrap','no')<br>
</code></pre></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigChromagram_ex2.png' />

<ul><li>If the <code>'Wrap'</code> option is selected, the representation is wrapped along the 12 pitch classes:<br>
<pre><code>c=mus.chromagram(c,'Wrap','yes')<br>
</code></pre></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigChromagram_ex3.png' />
<br>


<h2>Flowchart Interconnections</h2>

The <code>'Min'</code> and <code>'Max'</code> range used in sig.spectrum can be tuned directly in <code>mus.chromagram</code>, as well as the <code>'dB'</code> threshold (that can be written <code>'Threshold'</code> as well). These parameters are set by default to <i>Min</i> = 100 Hz, <i>Max</i> = 5000 Hz (Gómez, 2006) and <i>Threshold</i> = 20 dB. However, it seems that the spectrum should span as closely as possible an integer number of octaves, in order to avoid emphasizing particular pitches covered more often than others. Hence the higher limit of the frequency range of the spectrum computation is increased accordingly. Hence for the default parameters value (<i>Min</i> = 100 Hz, <i>Max</i> = 5000 Hz), the actual maximum frequency <i>fmax</i> is set to 6400 Hz. The <code>'MinRes'</code> value corresponds to the <code>'Res'</code> chromagram resolution parameter, as explained in the option section below.<br>
<br>
<code>mus.chromagram</code> accepts either:<br>
<br>
<ul><li><code>sig.spectrum</code> objects,<p>
</li><li><code>sig.input</code> objects , where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code> or the <code>'Frame'</code> option, with by default a frame length of 200 ms and a hop factor of .05),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>


<h2>Frame decomposition</h2>

<code>mus.chromagram(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 200 ms and a hop factor of 5% (10 ms). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>


<h2>Options</h2>

<ul><li><code>c = mus.chromagram(…,'Tuning',</code><i>t</i><code>)</code> specifies the frequency (in Hz.) associated to  chroma C. Default value, <i>t</i> = 261.6256 Hz.<p>
</li><li><code>c = mus.chromagram(…,'Triangle')</code> weights the contribution of each frequency with respect to the distance with the actual frequency of the corresponding chroma.<p>
</li><li><code>c = mus.chromagram(…,'Weight',</code><i>o</i><code>)</code> specifies the relative radius of the weighting window, with respect to the distance between frequencies of successive chromas.<br>
<ul><li><i>o</i> = <code>1</code>: each window begins at the centers of the previous one.<br>
</li><li><i>o</i> = <code>.5</code>: each window begins at the end of the previous one. (default value)<p>
</li></ul></li><li><code>c = mus.chromagram(…,'Res',</code><i>r</i><code>)</code> indicates the resolution of the chromagram in number of bins per octave. Default value, <i>r</i> = 12.<br>
<br></li></ul>


<h2>Post-processing operations</h2>

<ul><li><code>c = mus.chromagram(…,'Wrap',</code><i>w</i><code>)</code> specifies whether the chromagram is wrapped or not.<br>
<ul><li><i>w</i> = <code>'yes'</code>: groups all the pitches belonging to same pitch classes (default value)<br>
</li><li><i>w</i> = <code>'no'</code>: pitches are considered as absolute values.<p>
</li></ul></li><li><code>c = mus.chromagram(…,'Center')</code> centers the result.<p>
</li><li><code>c = mus.chromagram(…,'Normal',</code><i>n</i><code>)</code> normalizes the result, using the n-norm. The default value is <i>n</i> = Inf, corresponding to a normalization by the maximum value. <i>n</i> = 0 toggles off the normalization. Alternative keyword: <code>'Norm'</code>.<p>
</li><li><code>c = mus.chromagram(…,'Pitch',</code><i>p</i><code>)</code> specifies how to label chromas in the figures.<br>
<ul><li><i>p</i> = <code>'yes'</code>: chromas are labeled using pitch names (default)<br>
</li><li><i>p</i> = <code>'no'</code>: chromas are labeled using MIDI pitch numbers.</li></ul></li></ul>



<h2>Example</h2>
<pre><code>mus.chromagram('ragtime','Frame')<br>
</code></pre>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigChromagram_ex4.png' />

<br>


<h2>￼Accessible Output</h2>
cf. §5.2 for an explanation of the use of the <code>'get'</code> method. Specific fields:<br>
<ul><li><code>'Magnitude'</code>: same as <code>'Data'</code>,<p>
</li><li><code>'Chroma'</code>: the chroma related to each magnitude (same as <code>'Pos'</code>),<p>
</li><li><code>'ChromaClass'</code>: the chroma class (<code>'A'</code>, <code>'A#'</code>, <code>'B'</code>, etc.) related to each chroma,<p>
</li><li><code>'ChromaFreq'</code>: the central frequency of each chroma, in the unwrapped representation,<p>
</li><li><code>'Register'</code>: the octave position,<p>
</li><li><code>'PitchLabel'</code>: whether the chroma are represented as simple numeric positions (0), or as couples (ChromaClass, Register) (1).<p>
</li><li><code>'Wrap'</code>: whether the chromagram is represented along all possible chromas (0), or along the 12 chroma-classes only (1).