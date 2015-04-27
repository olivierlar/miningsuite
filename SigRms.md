# sig.rms: Root-mean-square energy #

The global energy of the signal _x_ can be computed simply by taking the root average of the square of the amplitude, also called root-mean-square (RMS):

> ![https://miningsuite.googlecode.com/svn/wiki/SigRms_eq1.png](https://miningsuite.googlecode.com/svn/wiki/SigRms_eq1.png)

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.rms</code> accepts as input data type either:<br>
<br>
<ul><li><code>sig.input</code> objects, where the audio waveform can be segmented (using <code>sig.segment</code>), decomposed into channels (using <code>sig.filterbank</code>), and/or decomposed into frames (using <code>sig.frame</code>),<p>
</li><li>file name(s) or the <code>'Folder'</code> keyword,<p>
</li><li>other vectorial objects, such as <code>sig.spectrum</code>, are accepted as well, although a warning is displayed in case this particular configuration was unintended, i.e., due to an erroneous script.</li></ul>

The following command orders the computation of the RMS related to a given audio file:<br>
<br>
<pre><code>sig.rms('ragtime')<br>
</code></pre>

which produce the resulting message in the Command Window:<br>
<pre><code>The RMS energy related to file ragtime is 0.017932<br>
</code></pre>

<br>
<h2>Frame decomposition</h2>

<code>sig.rms(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
For instance:<br>
<br>
<pre><code>sig.rms('ragtime','Frame')<br>
</code></pre>

we obtain a temporal evolution of the energy:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigRms_ex1.png' />

We can note that this energy curve is very close to the envelope:<br>
<br>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigRms_ex2.png' />

<br>
<h2>Options</h2>

<ul><li><code>sig.rms(…,'Warning',0)</code> toggles off the warning message, explained above, i.e., when the input is a vectorial data that is not a <code>sig.input</code> object.