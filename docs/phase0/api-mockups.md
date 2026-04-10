# API Mockups (Phase 0)

## Design targets
- One-liner for common tasks.
- Chainable pipelines for advanced use.
- Explicit but concise parameterization.

## Mockup A: one-liner
```python
import orpheon as op
result = op.audio("song.wav").spectrum().centroid().compute()
```

## Mockup B: declarative pipeline
```python
import orpheon as op

pipe = (
    op.pipeline("song.wav")
      .frame(size=0.05, hop=0.01)
      .spectrum(scale="mel")
      .flux()
      .tempo()
)
out = pipe.compute()
```

## Mockup C: corpus mode
```python
job = (
    op.batch("/data/corpus/**/*.wav")
      .pipeline(lambda x: x.spectrum().mfcc().pitch())
      .cache(".op_cache")
      .workers(16)
)
summary = job.run(resume=True)
```

## Mockup D: modality adapters
```python
score = op.midi("piece.mid").pianoroll().key().compute()
motion = op.mocap("gesture.c3d").velocity().events().compute()
```
