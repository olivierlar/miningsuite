# sig.kurtosis: Kurtosis of the data #

`sig.kurtosis` returns the (excess) kurtosis, of the data.

The fourth standardized moment is defined as:

![https://miningsuite.googlecode.com/svn/wiki/SigKurtosis_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigKurtosis_eq1.png)

Kurtosis is more commonly defined as the fourth cumulant divided by the square of the variance of the probability distribution, equivalent to:

![https://miningsuite.googlecode.com/svn/wiki/SigKurtosis_eq2.png](https://miningsuite.googlecode.com/svn/wiki/SigKurtosis_eq2.png)

which is known as excess kurtosis. The "minus 3" at the end of this formula is often explained as a correction to make the kurtosis of the normal distribution equal to zero. Another reason can be seen by looking at the formula for the kurtosis of the sum of random variables. Because of the use of the cumulant, if _Y_ is the sum of _n_ independent random variables, all with the same distribution as _X_, then _Kurt[Y](Y.md) = Kurt[X](X.md) / n_, while the formula would be more complicated if kurtosis were simply defined as _fourth standardized moment_. (Wikipedia)

![https://miningsuite.googlecode.com/svn/wiki/SigKurtosis_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigKurtosis_ex1.png)

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.kurtosis</code> accepts either:<br>
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
If the input is an audio waveform, a file name, or the <code>'Folder'</code> keyword, the kurtosis is computed on the spectrum (spectral kurtosis).<br>
<br>
If the input is a series of peak lobes produced by <code>sig.peaks(…,'Extract')</code>, the kurtosis will be computed for each of these lobes separately.