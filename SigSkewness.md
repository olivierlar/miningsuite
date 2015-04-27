# sig.skewness: Statistical description of spectral distribution #

`sig.skewness` returns the coefficient of skewness of the data.

The third central moment is called the skewness and is a measure of the symmetry of the distribution. The skewness can have a positive value in which case the distribution is said to be positively skewed with a few values much larger than the mean and therefore a long tail to the right. A negatively skewed distribution has a longer tail to the left. A symmetrical distribution has a skewness of zero. (Koch)

![https://miningsuite.googlecode.com/svn/wiki/SigSkewness_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigSkewness_eq1.png)

The coefficient of skewness is the ratio of the skewness to the standard deviation raised to the third power.

![https://miningsuite.googlecode.com/svn/wiki/SigSkewness_eq2.png](https://miningsuite.googlecode.com/svn/wiki/SigSkewness_eq2.png)

The coefficient of skewness has more convenient units than does the skewness and often ranges from -3.0 to 3.0 for data from natural systems. Again, a symmetrical distribution has a coefficient of skewness of zero. A positive coefficient of skewness often indicates that the distribution exhibits a concentration of mass toward the left and a long tail to the right whereas a negative value generally indicates the opposite. (Koch)

![https://miningsuite.googlecode.com/svn/wiki/SigSkewness_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigSkewness_ex1.png)


<br>
<h2>Flowchart Interconnections</h2>

<code>sig.skewness</code> accepts either:<br>
<ul><li><code>sig.spectrum</code> objects<p>
</li><li><code>sig.input</code> objects (same as for <code>sig.spectrum</code>)<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword.<br>
<br></li></ul>

<h2>Frame decomposition</h2>

<code>'Frame'</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>

<h2>Inputs</h2>

Any data can be used as input.<br>
<br>
If the input is an audio waveform, a file name, or the <code>'Folder'</code> keyword, the skewness is computed on the spectrum (spectral skewness).<br>
<br>
If the input is a series of peak lobes produced by <code>sig.peaks(…,'Extract')</code>, the skewness will be computed for each of these lobes separately.