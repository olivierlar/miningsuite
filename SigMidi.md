# sig.midi: Automated Transcription #

Segments the audio into events, extracts pitches related to each event and attempts a conversion of the result into a MIDI representation.

The audio segmentation is based on the onset detection given by mironsets with the default parameter, but with the `'Sum'` option toggled off in order to keep the channel decomposition of the input audio data.

The MIDI output is represented using the MIDI Toolbox note matrix representation. The displayed output is the piano-roll representation of the MIDI data, which requires MIDI Toolbox. Similarly, the result can be:

  * sonified using mirplay, with the help of MIDI Toolbox;<p>
<ul><li>saved using mirsave:<p>
<ul><li>as a MIDI file (by default), with the help of MIDI Toolbox,<p>
</li><li>as a LilyPond file (if the specified file has a '.ly' extension).<br>
<br></li></ul></li></ul>

<h2>Flowchart Interconnections</h2>

The <code>'Contrast'</code> parameter associated to <code>sig.pitch</code> can be specified, and is set by default to .3