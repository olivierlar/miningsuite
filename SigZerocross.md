# sig.zerocross: Waveform sign-change rate #

A simple indicator of noisiness consists in counting the number of times the signal crosses the X-axis (or, in other words, changes sign).

![https://miningsuite.googlecode.com/svn/wiki/SigZerocross_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigZerocross_ex1.png)


## Flowchart Interconnections ##

`sig.zerocross` actually accepts any input data type (cf. section 4.2).
<br><br>

<h2>Frame decomposition</h2>

<code>sig.zerocross(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br><br>

<h2>Options</h2>

<ul><li><code>sig.zerocross(…,'Per',</code><i>p</i><code>)</code> precises the temporal reference for the rate computation. Possible values:<br>
<ul><li><i>p</i> = <code>'Second'</code>: number of sign-changes per second (Default).<br>
</li><li><i>p</i> = <code>'Sample'</code>: number of sign-changes divided by the total  number of samples. The <code>'Second'</code> option returns a result equal to the one returned by the <code>'Sample'</code> option multiplied by the sampling rate.<p>
</li></ul></li><li><code>sig.zerocross(…,'Dir',</code><i>d</i><code>)</code> precises the definition of sign change. Possible values:<br>
<ul><li><i>d</i> = <code>'One'</code>: number of sign-changes from negative to positive only (or, equivalently, from positive to negative only). (Default)<br>
</li><li><i>d</i> = <code>'Both'</code>: number of sign-changes in both ways. The <code>'Both'</code> option returns a result equal to twice the one returned by the <code>'One'</code> option.