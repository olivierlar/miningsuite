MiningSuite

Version 0.9.1 (Third alpha version) released on August 6 2017

Open-source project hosted at http://olivierlar.github.io/miningsuite/

Copyright (C) 2014—2015, 2017 Olivier Lartillot and the MiningSuite contributors
All rights reserved.
License: New BSD License. See full text of the license in LICENSE.txt.

It is still in development stage, so the results cannot be trusted for the moment.

MiningSuite is a framework developed within the Matlab environment. It is organized into packages related to signal (SigMinr), auditory (AudMinr), music (MusMinr) domains, with further modules dedicated to symbolic sequence processing (SeqMinr) and pattern mining (PatMinr). The MiningSuite features simpler ways of building audio and music analysis processes, using modules that can be thoroughly controlled, with all the model parameters recorded in the output data. A new layer of syntax improves the readability of the modules’ code. Audio and symbolic analyses are unified into a single framework.

The MiningSuite has so far been designed and developed by Olivier Lartillot.

The MiningSuite requires Matlab 7.6 (r2008a) or newer versions. But Matlab 8.2 (r2013b) or newer is strongly recommended, because MiningSuite easily crashes on previous versions. 

The MiningSuite also requires that the Signal Processing Toolbox, one of the optional sub-packages of Matlab, be properly installed. But actually, a certain number of operators can adapt to the absence of this toolbox, and can produce more or less reliable results. But for serious use of the MiningSuite, we strongly recommend a proper installation of the Signal Processing Toolbox.

To use the toolbox, simply add the folder "miningsuite" to your Matlab path.
The list of operators available in the MiningSuite, stored in file Contents.m, can also be displayed by typing "help miningsuite" in Matlab.

A documentation is available in the wiki of the GitHub site of the MiningSuite.
https://github.com/olivierlar/miningsuite/wiki
