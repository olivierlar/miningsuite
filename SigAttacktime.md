# sig.attacktime: Attack phase detection #

The attack phase detected using the `'Attacks'` option in `sig.onsets` can offer some timbral characterizations. One simple way of describing the attack phase, proposed in `sig.attacktime`, consists in estimating its temporal duration.

![https://miningsuite.googlecode.com/svn/wiki/SigAttacktime_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigAttacktime_ex1.png)

<br>
<h2>Flowchart Interconnections</h2>

<code>sig.attacktime</code> accepts as input data type either:<br>
<br>
<ul><li>onset detection curves (resulting from <code>sig.onsets</code>), already including peaks or not,<p>
</li><li>and all the input data accepted by <code>sig.onsets</code>. In this case <code>sig.onsets</code> is called with the <code>'Filter'</code> method.</li></ul>

<br>
<code>sig.onsets</code> is normalized using the <code>'Normal'</code> option set to <code>'AcrossSegments'</code>.<br>
<br><br>

Some options in <code>sig.onsets</code> can be controlled:<br>
<ul><li><code>sig.attacktime(…,'Single')</code> toggles on the <code>'Single'</code> option in <code>sig.onsets</code>.<p>
</li><li><code>sig.attacktime(…,'LogOnset')</code> toggles on the <code>'Log'</code> option in <code>sig.onsets</code>.<p>
</li><li><code>sig.attacktime(…,'MinLog',</code><i>ml</i><code>)</code> controls the <code>'MinLog'</code> option in <code>sig.onsets</code>.</li></ul>

<br>
<code>sig.attacktime</code> can return several outputs:<br>
<ol><li>the attack time itself and<p>
</li><li>the onset detection curve returned by <code>sig.onsets</code>, including the detected onsets.</li></ol>

<br>
<h2>Options</h2>

<code>sig.attacktime(…,</code><i>scale</i><code>)</code> specifies the output scale, linear or logarithmic. Possible values for <i>scale</i> are:<p>
<ul><li><i>scale</i> = <code>'Lin'</code> returns the duration in a linear scale (in seconds). (Default choice)<p>
</li><li><i>scale</i> = <code>'Log'</code> returns the duration in a log scale (Krimphoff et al., 1994).