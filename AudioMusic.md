# Guided Tour: Audio-based music analysis #

This is a part of the MiningSuite GuidedTour.

## Non music-specific analyses ##

First of all, have a look at the audio-based method that were not conceived for music in the first place, but that can be of high interest anyway: So please take the SignalTour.

## Tempo estimation ##

```
t = mus.tempo('ragtime.wav')
t.getdata
```
Estimates tempo.

```
t = mus.tempo('ragtime.wav','FrameSize',2)
```

```
mus.tempo('laksin.mid')
```
Estimates tempo from a MIDI file, using the same audio-based method as for the audio file.

## To be continued... ##

You can go back to the MiningSuite GuidedTour.