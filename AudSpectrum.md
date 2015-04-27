# aud.spectrum: Spectrum decomposition based on auditory modelling #

This operations is a specialisation of the general signal processing operator [sig.spectrum](SigSpectrum.md) focused on auditory models.

## Flowchart Interconnections ##

Same as in [sig.spectrum](SigSpectrum.md).

## Defaults Specification ##

Particular default is set for the following parameter:
  * `’Phase’` is set to 0.

## Outer-ear modelling ##

  * `aud.spectrum(…,'Terhardt')` modulates the energy following (Terhardt, 1979) outer ear model. The function is mainly characterized by an attenuation in the lower and higher registers of the spectrum, and an emphasis around 2–5 KHz, where much of the speech information is carried. (Code based on Pampalk's MA toolbox).


## Frequency redistribution ##

  * `aud.spectrum(…,'Mel')` redistributes the frequencies along Mel bands. The Mel-scale of auditory pitch was established on the basis of listening experiments with simple tones (Stevens and Volkman, 1940). The Mel scale is now mainly used for the reason of its historical priority only. It is closely related to the Bark scale. It requires the _Auditory Toolbox_.
    * `aud.spectrum(…,'Bands',`_b_`)` specifies the number of band in the decomposition. By default _b_ = 40.

In our example we obtain the following:<p>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex6.png' /></blockquote>

The Mel-scale transformation requires a sufficient frequency resolution of the spectrum: as the lower bands are separated with a distance of 66 Hz, the frequency resolution should be higher than 66 Hz in order to ensure that each Mel band can be associated with at least one frequency bin of the spectrum. If the <code>'Mel'</code> option is performed in the same <i>sig.spectrum</i> command that performs the actual FFT, then the minimal frequency resolution is implicitly ensured, by forcing the minimal frequency resolution (<code>'MinRes'</code> parameter) to be equal or below 66 Hz. If on the contrary the <code>'Mel'</code> is performed in a second step, and if the frequency resolution is worse than 66 Hz, then a warning message is displayed in the Command Window.<br>
<br>
<ul><li><code>aud.spectrum(…,'Bark')</code> redistributes the frequencies along critical band rates (in Bark). Measurement of the classical "critical bandwidth" typically involves loudness summation experiments (Zwicker et al., 1957). The critical band rate scale differs from Mel-scale mainly in that it uses the critical band as a natural scale unit. The code is based on the <i>MA</i> toolbox.</li></ul>

<ul><li><code>aud.spectrum(…,'Mask')</code> models masking phenomena in each band: when a certain energy appears at a given frequency, lower frequencies in the same frequency region may be unheard, following particular equations. By modeling these masking effects, the unheard periodicities are removed from the spectrum. The code is based on the <i>MA</i> toolbox. In our example this will lead to:<p></li></ul>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigSpectrum_ex7.png' /></blockquote>

<h2>Accessible Output</h2>

Same as in <a href='SigSpectrum.md'>sig.spectrum</a>.