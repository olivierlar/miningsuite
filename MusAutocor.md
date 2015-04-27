# mus.autocor: Music-theoretical representation of autocorrelation function #

This operations is a specialisation of the general signal processing operator [sig.autocor](SigAutocor.md) focused on music theory.

## Flowchart Interconnections ##

Same as in [sig.autocor](SigAutocor.md).

## Post-processing ##

  * `mus.autocor(…,'Resonance',`_r_`)` multiplies the autocorrelation curve with a resonance curve that emphasizes pulsations that are more easily perceived. Two resonance curves are proposed:
    * _r_ = `'ToiviainenSnyder'` (Toiviainen & Snyder 2003) (default value if `'Resonance'` option toggled on),
    * _r_ = `'vanNoorden'` (van Noorden & Moelants, 1999).<p>
</li></ul><blockquote>This option should be used only when the input of the `sig.autocor` function is an amplitude envelope, i.e., a `´sig.envelope´` object.<p></blockquote>

![https://miningsuite.googlecode.com/svn/wiki/SigAutocor_Toiviainen.png](https://miningsuite.googlecode.com/svn/wiki/SigAutocor_Toiviainen.png)
![https://miningsuite.googlecode.com/svn/wiki/SigAutocor_vanNoorden.png](https://miningsuite.googlecode.com/svn/wiki/SigAutocor_vanNoorden.png)<p>
<blockquote><i>Resonance curves <code>'ToiviainenSnyder'</code> (left) and <code>'vanNoorden'</code> (right)</i><p></blockquote>

<h2>Accessible Output</h2>

Same as in <a href='SigAutocor.md'>sig.autocor</a>.