The _MiningSuite_ is composed of a large set of modules corresponding to the different possible types of signal processing representations and audio and music descriptors. These modules are structured into packages related to the different domains of study: signal processing (_SigMinr_ package), auditory modelling (_AudMinr_), music analysis (_MusMinr_), voice analysis (_VocMinr_ package under plan), sequence processing (_SeqMinr_) and pattern mining (_PatMinr_).

Thanks to an innovative syntactic layer, both powerful and user-friendly, designed on top of Matlab, these modules can be easily applied to particular files or batch of files, and the numerous options available for each module can be modified. More interestingly, modules can be connected and form data flow graphs. As such, complex design of set of audio or music analysis operations can be written in a very concise way through a simple assemblage of modules. They can be applied to large batches of files as well as to long files without memory issues thanks to implicit signal chunking and concatenation mechanisms. Another syntactic layer within the operators’ Matlab code enables to simplify and clarify the code.

As the internal representation of signals integrates various types of decomposition (into frames, channels, segments) within a unified framework, the modules can adapt automatically to these various types of input.

Audio and symbolic representations and processes are tightly interconnected: The same type of symbolic representation is used to represent discrete constructions inferred from audio representation (such as peaks, segments, onset locations) as well as actual symbolic sequences (such as scores and MIDI sequences). Operators dedicated to high-level musical features extraction (key estimation, tempo, etc.) integrate signal processing, statistical and symbolic-based methods, and can be applied to both symbolic input and audio input (adding automated transcription steps wherever necessary).

The integration of expertise developed in separate areas of study into common modules encourages further reuse of these individual methods and their intermingling into a common framework.

The GuidedTour offers a panorama of the capabilities offered in the MiningSuite.

