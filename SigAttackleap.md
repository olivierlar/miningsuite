# sig.attackleap: estimating amplitude differences of the attack phase #

Another simple way of describing the attack phase, proposed in `sig.attackleap`, consists in estimating the amplitude difference between the beginning and the end of the attack phase. Values are expressed in the same scale than the original signal.

![https://miningsuite.googlecode.com/svn/wiki/SigAttackleap_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigAttackleap_ex1.png)


## Flowchart Interconnections ##

`sig.attackleap` accepts as input data type either:
  * onset detection curves (resulting from `sig.onsets`), already including peaks or not,<p>
<ul><li>and all the input data accepted by <code>sig.onsets</code>. In this case <code>sig.onsets</code> is called with the <code>'Filter'</code> method.<br>
<br>
<code>sig.onsets</code> is normalized using the <code>'Normal'</code> option set to <code>'AcrossSegments'</code>.<br>
<br><br></li></ul>

Some options in <code>sig.onsets</code> can be controlled:<br>
<br>
<ul><li><code>sig.attackleap(…,'Single')</code> toggles on the <code>'Single'</code> option in <code>sig.onsets</code>.<p>
</li><li><code>sig.attackleap(…,'LogOnset')</code> toggles on the <code>'Log'</code> option in <code>sig.onsets</code>.<p>
</li><li><code>sig.attackleap(…,'MinLog',</code><i>ml</i><code>)</code> controls the <code>'MinLog'</code> option in <code>sig.onsets</code>.</li></ul>

<br>
The peak picking from the onset detection is performed in any case. Its <code>'Contrast'</code> parameter can be specified. Its default value is the same as in <code>sig.onsets</code>.<br>
<br>
<br>
<code>sig.attackleap</code> can return several outputs:<br>
<ol><li>the attack leap itself and<p>
</li><li>the onset detection curve returned by <code>sig.onsets</code>, including the detected onsets.