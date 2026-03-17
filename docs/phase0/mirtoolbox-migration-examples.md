# MIRtoolbox-style Migration Examples (Starter)

> Goal: lower onboarding cost without forcing strict legacy compatibility.

1. **Spectrum from file**
   - Legacy style: `mirspectrum('song.wav')`
   - New style: `ms.audio('song.wav').spectrum().compute()`

2. **Tempo estimate**
   - Legacy style: `mirtempo('song.wav')`
   - New style: `ms.audio('song.wav').tempo().compute()`

3. **Pitch curve**
   - Legacy style: `mirpitch('song.wav')`
   - New style: `ms.audio('song.wav').pitch().compute()`

4. **Pulse clarity**
   - Legacy style: `mirpulseclarity('song.wav')`
   - New style: `ms.audio('song.wav').pulse_clarity().compute()`

5. **MFCC extraction**
   - Legacy style: `mirmfcc('song.wav')`
   - New style: `ms.audio('song.wav').mfcc().compute()`

6. **Batch spectrum**
   - Legacy pattern: user loops over files
   - New style: `ms.batch('/data/**/*.wav').pipeline(lambda x: x.spectrum()).run()`

7. **Key estimation from symbolic file**
   - Legacy style: separate symbolic routines
   - New style: `ms.midi('piece.mid').key().compute()`

8. **Complex chained analysis**
   - Legacy style: nested calls
   - New style: `ms.audio('song.wav').frame().spectrum().flux().tempo().compute()`

9. **Custom parameterized analysis**
   - Legacy style: long positional option lists
   - New style: `ms.audio('song.wav').frame(size=0.05, hop=0.01).spectrum(scale='mel').compute()`

10. **Reproducible run export**
   - Legacy style: manual scripts/logging
   - New style: `result.provenance.to_json('run-meta.json')`
