# aud.roughness: Sensory dissonance #

Plomp and Levelt (1965) have proposed an estimation of the sensory dissonance, or roughness, related to the beating phenomenon whenever pair of sinusoids are closed in frequency. The authors propose as a result an estimation of roughness depending on the frequency ratio of each pair of sinusoids represented as follows:

![https://miningsuite.googlecode.com/svn/wiki/SigRoughness_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigRoughness_ex1.png)

An estimation of the total roughness is available in `sig.roughness` by computing the peaks of the spectrum, and taking the average of all the dissonance between all possible pairs of peaks (Sethares, 1998).
<br><br>

<h2>Flowchart Interconnections</h2>

The <code>'Contrast'</code> parameter associated to <code>sig.peaks</code> can be specified, and is set by default to .01<br>
<br>
<code>aud.roughness</code> accepts either:<br>
<br>
<ul><li><code>sig.spectrum</code> objects, where peaks have already been picked or not,<p>
</li><li><code>sig.input</code> objects: same as for sig.spectrum, except that a frame decomposition is automatically performed. This forced frame decomposition is due to the fact that roughness can only be associated to a spectral representation association to a short-term sound excerpt: there is no sensory dissonance provoked by a pair of sinusoid significantly distant in time.<p>
</li><li>file name(s) or the 'Folder' keyword.<br>
<br></li></ul>

<code>aud.roughness</code> can return several outputs:<br>
<ol><li>the roughness value itself and<p>
</li><li>the spectral representation (output of <code>sig.spectrum</code>) showing the picked peaks (returned by <code>sig.peaks</code>).<br>
<br></li></ol>

<h2>Frame decomposition</h2>

<code>aud.roughness(…,'Frame',…)</code> specifies the frame configuration, with by default a frame length of 50 ms and half overlapping. For the syntax, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>

<h2>Options</h2>

<ul><li><code>aud.roughness(…,</code><i>m</i><code>)</code> specifies the method used:<p>
<ul><li><i>m</i> = <code>'Sethares'</code> (default): based on the summation of roughness between all pairs of sines (obtained through spectral peak-picking) (Sethares, 1998). For each pair of peaks, the corresponding elementary roughness is obtained by multiplying the two peak amplitudes altogether, and by weighting the results with the corresponding factor given on the dissonance curve.<p>
<ul><li><code>sig.roughness(…,'Min')</code>: Variant of the Sethares model where the summation is weighted by the minimum amplitude of each pair of peak, instead of the product of their amplitudes (Weisser and Lartillot, 2013).<p>
</li></ul></li><li><i>m</i> = <code>'Vassilakis'</code>: variant of Sethares model with a more complex weighting (Vassilakis, 2001, Eq. 6.23).