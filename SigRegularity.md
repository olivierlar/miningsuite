# sig.regularity: Spectral peaks variability #

The irregularity of a spectrum is the degree of variation of the successive peaks of the spectrum.
<br><br>

<h2>Flowchart Interconnections</h2>

The <code>'Contrast'</code> parameter associated to <code>sig.peaks</code> can be specified, and is set by default to .01<br>
<br>
<code>sig.regularity</code> accepts either:<br>
<br>
<ul><li><code>sig.spectrum</code> objects, where peaks have already been picked or not,<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>sig.regularity(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>

<h2>Options</h2>

<ul><li><code>sig.regularity(…,'Jensen')</code> is based on (Jensen, 1999), where the irregularity is the sum of the square of the difference in amplitude between adjoining partials.(Default approach)<p> <img src='https://miningsuite.googlecode.com/svn/wiki/SigRegularity_eq1.png' /><p>
</li><li><code>sig.regularity(…,'Krimphoff')</code> is based on (Krimphoff et al., 1994), where the irregularity is the sum of the amplitude minus the mean of the preceding, same and next amplitude.<p><img src='https://miningsuite.googlecode.com/svn/wiki/SigRegularity_eq2.png' />