# sig.save: Saving audio rendering into files #

Certain classes of temporal data can be saved:

  * `sig.input` objects: the waveform is directly saved, and
    * if the audio waveform is segmented (using `sig.segment`), segments are concatenated with a short burst of noise in-between;
    * if the audio waveform is decomposed into channels (using `sig.filterbank`), each channel is saved in a separate file;
    * if the audio is decomposed into frames (using `sig.frame`), frames are concatenated;<p>
</li></ul><ul><li>file name(s) or the <code>'Folder'</code> keyword: same behavior as for <code>sig.input</code> objects;<p>
</li><li><code>sig.envelope</code> objects (frame-decomposed or not) are sonified using a white noise modulated in amplitude by the envelope,<p>
</li><li><code>sig.pitch</code> results: each extracted frequency is sonified using a sinusoid.</li></ul>

<br>
<h2>Frame decomposition</h2>

<code>sig.save(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 50 ms and half overlapping. For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. 'Frame' section.<br>
<br>
<br>
<h2>Options</h2>

<ul><li>The name and extension of the saved file can be specified in different ways, as shown in the tables below.<br>
<ul><li>By default, the files are saved in WAV format, using the extension <code>'.mir.sav'</code> in order to lower the risk of overwriting original audio files.<br>
</li><li>If the string <code>'.au'</code> is indicated as second argument of sig.save, the audio will be saved in AU format.<br>
</li><li>A string can be indicated as second argument of sig.save.<br>
<ul><li>If the <code>sig.input</code> object to be saved contains only one audio file, the specified string will be used as the name of the new audio file.<br>
</li><li>If the <code>sig.input</code> object to be saved contains several audio files, the specified string will be concatenated to the original name of each audio file.<br>
</li></ul></li><li>If the second argument of sig.save is a string ended by <code>'.au'</code>, the file name will follow the convention explained in the previous point, and the files will be saved in AU format.</li></ul></li></ul>

<br>
<table><thead><th> <b>Diverse ways of saving into an audio file</b> </th></thead><tbody>
<tr><td> <code>a=sig.input('mysong.au')</code> </td><td> mysong.au </td></tr>
<tr><td> <code>sig.save(a)</code> </td><td> mysong.mir.wav </td></tr>
<tr><td> <code>sig.save(a,'new')</code> </td><td> new.wav </td></tr>
<tr><td> <code>sig.save(a,'.au')</code> </td><td> mysong.mir.au </td></tr>
<tr><td> <code>sig.save(a,'new.au')</code> </td><td> new.au </td></tr></tbody></table>

<br>
<table><thead><th> <b>Diverse ways of saving as a batch of audio files</b> </th></thead><tbody>
<tr><td> <code>a=sig.input('Folder')</code> </td><td> song1.wav </td><td> song2.wav </td><td> song3.au </td></tr>
<tr><td> <code>sig.save(a)</code> </td><td> song1.mir.wav </td><td> song2.mir.wav </td><td> song3.mir.wav </td></tr>
<tr><td> <code>sig.save(a,'new')</code> </td><td> song1new.wav </td><td> song2new.wav </td><td> song3new.wav </td></tr>
<tr><td> <code>sig.save(a,'.au')</code> </td><td> song1.mir.au </td><td> song2.mir.au </td><td> song3.mir.au </td></tr>
<tr><td> <code>sig.save(a,'new.au')</code> </td><td> song1new.au </td><td> song2new.au </td><td> song3new.au </td></tr></tbody></table>

<br>
<ul><li><code>sig.save(a,filename,'SeparateChannels')</code> save each separate channel in a different file. The channel number is added to the file name, before any file extension.<p>
</li><li><code>sig.save(a,filename,'SeparateSegments')</code> save each separate segment in a different file. The segment number is added to the file name, before any file extension.