# MiningSuite-style Migration Examples (Starter)

> Goal: lower onboarding cost for MiningSuite users without forcing strict legacy compatibility.

1. **Spectrum from file**
   - Legacy style: `sig.spectrum('song.wav')`
   - New style: `op.audio('song.wav').spectrum().compute()`

2. **Tempo estimate**
   - Legacy style: `mus.tempo('song.wav')`
   - New style: `op.audio('song.wav').tempo().compute()`

3. **Pitch curve**
   - Legacy style: `aud.pitch('song.wav')`
   - New style: `op.audio('song.wav').pitch().compute()`

4. **Pulse clarity**
   - Legacy style: `aud.pulseclarity('song.wav')`
   - New style: `op.audio('song.wav').pulse_clarity().compute()`

5. **MFCC extraction**
   - Legacy style: `aud.mfcc('song.wav')`
   - New style: `op.audio('song.wav').mfcc().compute()`

6. **Batch spectrum**
   - Legacy pattern: user loops over files
   - New style: `op.batch('/data/**/*.wav').pipeline(lambda x: x.spectrum()).run()`

7. **Key estimation from symbolic file**
   - Legacy style: `mus.key('piece.mid')`
   - New style: `op.midi('piece.mid').key().compute()`

8. **Complex chained analysis**
   - Legacy style: nested/operator-chained calls
   - New style: `op.audio('song.wav').frame().spectrum().flux().tempo().compute()`

9. **Custom parameterized analysis**
   - Legacy style: long positional option lists
   - New style: `op.audio('song.wav').frame(size=0.05, hop=0.01).spectrum(scale='mel').compute()`

10. **Reproducible run export**
   - Legacy style: manual scripts/logging
   - New style: `result.provenance.to_json('run-meta.json')`
