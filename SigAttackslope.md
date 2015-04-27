# sig.attackslope: Average slope of the attack phase #

Another description of the attack phase is related to its average slope. Values are expressed in the same scale than the original signal, but normalized by time in seconds.


## Flowchart Interconnections ##

`sig.attackslope` accepts as input data type either:
  * onset detection curves (resulting from `sig.onsets`),<p>
<ul><li>and all the input data accepted by <code>sig.onsets</code>. In this case <code>sig.onsets</code> is called with the <code>'Filter'</code> method.<br>
<br>
<code>sig.onsets</code> is normalized using the <code>'Normal'</code> option set to <code>'AcrossSegments'</code>.<br>
<br><br></li></ul>

Some options in sig.onsets can be controlled:<br>
<br>
<ul><li><code>sig.attackslope(…,'Single')</code> toggles on the <code>'Single'</code> option in <code>sig.onsets</code>.<p>
</li><li><code>sig.attackslope(…,'LogOnset')</code> toggles on the <code>'Log'</code> option in <code>sig.onsets</code>.<p>
</li><li><code>sig.attackslope(…,'MinLog',</code><i>ml</i><code>)</code> controls the <code>'MinLog'</code> option in <code>sig.onsets</code>.<br>
<br>
The peak picking from the onset detection is performed in any case. Its <code>'Contrast'</code> parameter can be specified. Its default value is the same as in <code>sig.onsets</code>.<br>
<br><br></li></ul>

<code>sig.attackslope</code> can return several outputs:<br>
<ul><li>the attack slope itself and<p>
</li><li>the onset detection curve returned by <code>sig.onsets</code>, including the detected onsets.<br>
<br></li></ul>

<h2>Options</h2>

<ul><li><code>sig.attackslope(x,</code><i>meth</i><code>)</code> specifies the method for slope estimation. Possible values for <i>meth</i> are:<p>
<ul><li><i>meth</i> = <code>'Diff'</code> computes the slope as a ratio between the magnitude difference at the beginning and the ending of the attack period, and the corresponding time difference. (Default choice)<p>
</li></ul><blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigAttackslope_ex1.png' />
</blockquote><ul><li><i>meth</i> = <code>'Gauss'</code> computes the average of the slope, weighted by a gaussian curve that emphasizes values at the middle of the attack period (similar to Peeters, 2004).