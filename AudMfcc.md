# aud.mfcc: Mel-Frequency Cepstral Coefficients #

MFCC offers a description of the spectral shape of the sound. We recall that the computation of the cepstrum followed the following scheme:

![https://miningsuite.googlecode.com/svn/wiki/SigMfcc_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigMfcc_ex1.png)

<br>
The computation of mel-frequency cepstral coefficients is highly similar:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigMfcc_ex2.png' />

Here the frequency bands are positioned logarithmically (on the Mel scale) which approximates the human auditory system's response more closely than the linearly-spaced frequency bands. And the Fourier Transform is replaced by a Discrete Cosine Transform. A discrete cosine transform (DCT) is a Fourier-related transform similar to the discrete Fourier transform (DFT), but using only real numbers. It has a strong "energy compaction" property: most of the signal information tends to be concentrated in a few low-frequency components of the DCT. That is why by default only the first 13 components are returned.<br>
<br>
By convention, the coefficient of rank zero simply indicates the average energy of the signal.<br>
<br>
<br>
<h2>Flowchart Interconnections</h2>

<code>aud.mfcc</code> accepts either:<br>
<ul><li><code>sig.Spectrum</code> objects, or<p>
</li><li><code>sig.input</code> objects (same as for sig.spectrum),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>

<code>aud.mfcc</code> can return several outputs:<br>
<ul><li>the mfcc coefficients themselves and<p>
</li><li>the spectral representation (output of <code>aud.spectrum</code>), in mel-band and log-scale.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>aud.mfcc(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>


<h2>Options</h2>

<ul><li><code>aud.mfcc(…,'Bands',</code><i>b</i><code>)</code> indicates the number of bands used in the mel-band spectrum decomposition. By default, <i>b</i> = 40.<p>
</li><li><code>aud.mfcc(…,'Rank',</code><i>N</i><code>)</code> computes the coefficients of rank(s) <i>N</i>. The default value is <i>N</i> = 1:13. Beware that the coefficient related to the average energy is by convention here of rank 0. This zero value can be included to the array <i>N</i> as well.<p>
</li><li>If the output is frame-decomposed, showing the the temporal evolution of the MFCC along the successive frames, the temporal differentiation can be computed:<p>
<ul><li><code>aud.mfcc(…,'Delta',</code><i>d</i><code>)</code> performs temporal differentiations of order <i>d</i> of the coefficients, also called delta-MFCC (for <i>d</i> = 1) or delta-delta-MFCC (for <i>d</i> = 2). By default, <i>d</i> = 1.<p>
</li><li><code>aud.mfcc(…,'Radius',</code><i>r</i><code>)</code> specifies, for each frame, the number of successive and previous neighbouring frames taken into consideration for the least-square approximation used for the derivation. For a given radius <i>r</i>, the Delta operation for each frame <i>i</i> is computed by summing the MFCC coefficients at frame <i>i+j</i> (with <i>j</i> from <i>-r</i> to <i>+r</i>) , each coefficient being multiplied by its weight <i>j</i>. Usually the radius is equal to 1 or 2. Default value: <i>r</i> = 2.</li></ul></li></ul>

<br>
<h2>Accessible Output</h2>

<ul><li><code>.xdata</code>: the series of rank(s) taken into consideration,<p>
</li><li><code>.delta</code>: the number of times the delta operation has been performed.