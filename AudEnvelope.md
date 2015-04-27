# aud.envelope: Amplitude envelope  based on auditory modelling #

This operations is a specialisation of the general signal processing operator [sig.envelope](SigEnvelope.md) focused on auditory models. The envelope extraction attempts a modelling of human perception, suggested in (Klapuri et al., 2006).

## Flowchart Interconnections ##

Same as in [sig.envelope](SigEnvelope.md).

## Defaults Specification ##

Particular defaults are set for the following parameters:
  * `’Method’` is set to `’Spectro’`,
  * `’Up’` is set to 2,
  * `’HalfwaveDiff’` is turned on.

## Post-processing options ##

  * `sig.envelope(…,'Mu',`_mu_`)` computes the logarithm of the envelope, before the eventual differentiation, using a mu-law compression.. Default value for _mu_: 100

  * `sig.envelope(…,'Lambda',`_l_`)` sums the half-wave rectified envelope with the non-differentiated envelope, using the respective weight 0<l<1 and (1-l). Default value for _lambda_: .8

(+ Adjacent channel fusion)

## Accessible Output ##

Same as in [sig.envelope](SigEnvelope.md).