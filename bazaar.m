%%
% Basic principles

%%Installation

%Download the latest public version of the MiningSuite, available in the Release section of the wiki home page.

%Add the folder miningsuite to your Matlab path.

%%Syntax

%The MiningSuite is decomposed into a certain number of packages (SigMinr, AudMinr, etc.) and in order to call an operator of a given package, you need to specify the package it belong to, by adding the proper prefix.

%For instance sig.signal is an operator from the SigMinr package, as indicated by the prefix sig.

%Each operator is related to a particular data type: for instance, sig.signal is related to the loading, transformation and display of signals. Let's first load a WAV file of name test.wav:

sig.signal('test.wav')

%Operations and options to be applied are indicated by particular keywords, expressed as arguments of the functions. For instance, we can just extract a part of the file, for instance from 1 to 2 seconds:

sig.signal('test.wav','Extract',1,2)

%Let's try another operator sig.spectrum, which will be explained in the next section:

sig.spectrum('test.wav')

%We can store the result of one operation into a variable, for instance:

a = sig.signal('test.wav','Extract',1,2)

%In this way, we can perform further operations on that result. For instance, playing the audio:

sig.play(a)

%or computing sig.spectrum on that result:

sig.spectrum(a)

%For more details about the basic principles of the MiningSuite, check this page.

close all

%%
% SigMinr, Part I

%%sig.signal

%You can load various type of audio files, for instance MP3:

sig.signal('beethoven.mp3')

%You can also load other types of signals, for instance delimited text files or spreadsheet files:

sig.signal('insurance.csv')

%Only numerical fields are taken into consideration.

%Various options are available, as detailed in the sig.signal online documentation.

%%sig.spectrum

%To see all the frequencies contained in your signal, use sig.spectrum:

sig.spectrum('test.wav')

%You can select a particular range of frequencies:

sig.spectrum('test.wav','Min',10,'Max',1000)

%To learn more about the maths behind this transformation, and all the possible options, check the sig.spectrum online documentation.

%%sig.frame

%The analysis of a whole temporal signal leads to a global description of the average value of the feature under study. In order to take into account the dynamic evolution of the feature, the analysis has to be carried out on a short-term window that moves chronologically along the temporal signal. Each position of the window is called a frame. For instance:

f = sig.frame('test.wav','FrameSize',1,'Hop',0.5)

%Then we can perform any computation on each of the successive frame easily. For instance, the computation of the spectrum for each successive frame, can be written as:

sig.spectrum(f,'Max',1000)

%What you see in the progressive evolution of the spectrum over time, frame by frame. This is called a spectrogram.

%More simply, you can compute the same thing by writing just one command:

sig.spectrum('test.wav','Max',1000,'Frame')

%Here the frame size was chosen by default. You can of course specify the frame size yourself:

sig.spectrum('test.wav','Max',1000,'Frame','FrameSize',1,'Hop',0.5)

%For more information about sig.frame, click on the link.

%%sig.flux

%Once we have computed the spectrogram

s = sig.spectrum('test.wav','Frame')

%we can evaluate how fast the signal changes from one frame to the next one by computing the spectral flux:

sig.flux(s)

%In the resulting curve, you see peaks that indicate particular moments where the spectrum has changed a lot from one frame to the next one. In other words, those peaks indicate that something new has appeared at that particular moment.

%You can compute spectral flux directly using the simple command:

sig.flux('test.wav')

%The flux can be computed from other representations that the spectrum. For more information about sig.flux, click on the link.

%%sig.rms

%You can get an average of the amplitude of the signal by computing its Root Mean Square (or RMS):

sig.rms('test.wav')

%But this gives a single numerical value, which is not very informative (although you can compared different signals in this way).

%You can also see the temporal evolution of this averaged amplitude by computing RMS frame by frame:

sig.rms('test.wav','Frame')

%We have now seen two ways to detect new events in the signal: sig.flux considers the changes in the spectrum while sig.rms considers the contrasts in the amplitude of the signal.

%For more information about sig.rms, click on the link.

%%sig.envelope

%From a signal can be computed the envelope, which shows the global outer shape of the signal.

e = sig.envelope('test.wav')

%It is particularly useful in order to show the long term evolution of the signal, and has application in particular to the detection of events. So it is very closely related to sig.rms that we just saw.

%You can listen to the envelope itself. This is played by a simple noise that follows exactly the same envelope.

sig.play(e)

%sig.envelope can be estimated using a large range of techniques, and with a lot of parameters that can be tuned. For more information, click on the link.

%%sig.peaks

%For any kind of representation (curve, spectrogram, etc.) you can easily find the peaks showing the local maxima by calling sig.peaks. For instance, on the envelope we just computed:

sig.peaks(e)

%You can specify that you just want the highest peak:

sig.peaks(e,'Total',1)

%set some threshold, for instance selecting all peaks higher than half the maximum value:

sig.peaks(e,'Threshold',.5)

%You can see that by default sig.peaks selects some peaks in a kind of adaptive way. You can turn off this adaptive peak picking by toggling off the 'Contrast' option:

sig.peaks(e,'Contrast',0)

%For more information about sig.peaks, click on the link.

%%sig.autocor

%We saw that we can find all the frequencies in a signal by computing sig.spectrum. But it is actually focused on finding sinusoids. More generally, if you want to find any kind of periodicities in a signal, for instance our envelope we just computed, we can compute an autocorrelation function by using sig.autocor:

sig.autocor(e)

%Each peak in the autocorrelation function indicates periodicities. But these periodicities are expressed as lags, which corresponds to the duration of one period. If you want to see instead periodicities as frequencies (similar to sig.spectrum), use the 'Freq' option:

sig.autocor(e,'Freq')

%And again you can specify the range of frequencies. For instance:

sig.autocor(e,'Freq','Max',10,'Hz')

%For more information about sig.autocor, click on the link.

%%sig.filterbank

%Something more technical, not necessarily useful for you, but of interest for experts in signal processing. Here is an example of more complex operation that can be performed: the decomposition of the signal into different channels corresponding to different frequency regions:

f = sig.filterbank('test.wav','CutOff',[-Inf,1000,5000])

%You can play each channel separately:

sig.play(f)

%You can then compute any operation on each channel separately, for instance:

e = sig.envelope(f)

%And you can finally sum back all the channels together:

e = sig.sum(e)

%For more information about sig.filterbank, click on the link.

close all

%%
% Useful general tricks

%%'Folder'

%You can perform any operation to a whole folder of files. For instance, if you would like to analyse all the audio and text files available in the mining suite distribution, first select the miningsuite folder as your Current Folder in Matlab. Then Instead of writing the name of a particular file, write the 'Folder' keyword instead. For instance:

sig.spectrum('Folder')

%%get data

%This paragraph requires some basic knowledge of Matlab. If you are not familiar with Matlab, you can skip this for the moment.

%You have noticed that every time you perform a command, you obtain either a graphic on a new window, or the display of a single value directly in Matlab's Command Window. But you can of course get the actual numerical results in a Matlab structure (an array, for instance).

%For instance, if you store the result of your analysis in a variable:

a = sig.spectrum('test.wav')

%Then you can use the following syntax to output the actual results in Matlab.

a.getdata

%When extracting peaks:

p = sig.peaks(e)

%you can get the position of each peak:

get(p,'PeakPos')

%and the value associated to each peak:

get(p,'PeakVal')

%More information in the Advanced use page.

%%show design

%Let's suppose we compute a series of operations such as the following:

f = sig.filterbank('test.wav','CutOff',[-Inf,1000,5000]);
e = sig.envelope(f);
s = sig.sum(e);
p = sig.peaks(s);

%Then it is possible to see again the series of operations, with detailed information about all the parameters, by using the .show command:

p.show

%%sig.Signal

%Again for Matlab experienced users, you can import in the MiningSuite any data you have already computed in Matlab. For instance let's say we generate an array using this Matlab command:

c = rand(100,1)

%Then we can import this array as values of sig.signal. Here you need to know that sig.signal actually outputs a Matlab object of class sig.Signal. So to create your own object, use the sig.Signal method:

sig.Signal(c)

%You can specify the sampling rate:

sig.Signal(c,'Srate',100)

%I have not yet added a proper documentation of those classes in the MiningSuite. Please use the discussion list if you have any question meanwhile.

close all

%%
% AudMinr

%So far we have considered the analysis of any kind of signals. Let's now focus on the analysis of audio files.

%%mono/stereo

%The file test.wav we were using previously turns out to be a mono file. If we load now a stereo file:

sig.signal('ragtime.wav')

%We actually can see the left and right channels separately. Any type of analysis can then be performed on each channel separately:

sig.envelope('ragtime.wav')

%But if you prefer considering the audio file as a simple signal, you can mix altogether the left and right channels into a single mono signal by using the 'Mix' option:

sig.signal('ragtime.wav','Mix')

%The 'Mix' option can be used for any command:

sig.envelope('ragtime.wav','Mix')

%%aud.pitch

%We can extract the fundamental frequency of each sound in the recording by calling aud.pitch:

aud.pitch('voice.wav','Frame')

%The algorithms used in aud.pitch are currently being improved. We see in the example that there are some spurious high frequencies detected that should not be there. One possible way to remove those high frequencies could be to constrain the frequencies to remain below a given threshold:

aud.pitch('voice.wav','Frame','Max',300)

%Or we can just extract the most dominant pitch in each frame:

aud.pitch('voice.wav','Frame','Total',1)

%It is also theoretically possible to detect multiple pitches, for instance in a chord made of several notes played simultaneously:

aud.pitch('chord.wav','Frame')

%But again, please notice that the algorithms need to be improved. For more information about aud.pitch, click on the link.

%%aud.brightness

%One particular timbral quality of sounds is brightness, which relates to the relative amount of energy on high frequencies. This can be estimated using aud.brightness:

aud.brightness('beethoven.mp3','Frame')

%We can specify the frequency threshold, or cut-off, used for the estimation:

aud.brightness('beethoven.mp3','Frame','CutOff',3000)

%But again, please notice that the algorithms need to be improved. For more information about aud.brightness, click on the link.

%%aud.mfcc

aud.mfcc('george.wav','Frame')

%%aud.events

aud.events('voice.wav')
aud.events('test.wav')
aud.events('test.wav','Attacks','Decays')
aud.attacktime('test.wav')
aud.attackslope('test.wav')
aud.attackleap('test.wav')
aud.decaytime('test.wav')
aud.decayslope('test.wav')
aud.decayleap('test.wav')

%%aud.fluctuation

aud.fluctuation('test.wav')
aud.fluctuation('test.wav','Summary')

close all

%%
% MusMinr

%%mus.score

mus.score('test.wav')
mus.score('song.mid')
mus.score('song.mid','Notes',1:10)
mus.score('song.mid','EndTime',5)

%%Signal analysis of score

p = mus.pitch('song.mid')
sig.histogram(p)
p = mus.pitch('song.mid','Inter')
sig.histogram(p)
p = mus.pitch('song.mid','Sampling',.1)
sig.autocor(p)

%%mus.tempo

mus.tempo('test.wav')
o = aud.events('test.wav','Filter')
do = aud.events(o,'Diff')
ac = mus.autocor(do,'Resonance')
pa = sig.peaks(ac,'Total',1)
mus.tempo('test.wav','Frame')
mus.tempo('song.mid','Frame')

%%mus.pulseclarity

mus.pulseclarity('test.wav')
mus.pulseclarity('test.wav','Frame')
mus.pulseclarity('song.mid')

%%mus.chromagram

mus.chromagram('ragtime.wav')
mus.chromagram('ragtime.wav','Frame')
mus.chromagram('ragtime.wav','Wrap')
mus.chromagram('ragtime.wav','Wrap','Frame')
mus.chromagram('song.mid')

%%mus.keystrength

mus.keystrength('ragtime.wav')
mus.keystrength('ragtime.wav','Frame')
mus.keystrength('song.mid')

%%mus.key

ks = mus.keystrength('ragtime.wav');
sig.peaks(ks,'Total',1)
mus.key('ragtime.wav')
mus.key('ragtime.wav','Frame')
mus.key('song.mid')

%%mus.majorness

mus.majorness('ragtime.wav')
mus.majorness('ragtime.wav','Frame')
mus.majorness('song.mid')

%%mus.keysom

mus.keysom('ragtime.wav')
mus.keysom('ragtime.wav','Frame')
mus.keysom('song.mid')

%%Musicological analysis

mus.score('song.mid','Spell')
mus.score('song.mid','Spell','Group')
mus.score('song.mid','Spell','Group','Broderie','Passing')
mus.score('auclair.mid','Motif')
mus.score('auclair.mid','Motif','Onset')
mus.score('mozart.mid','Motif')
mus.score('mozart.mid','Motif','Spell')
mus.score('mozart.mid','Motif','Spell','Group')

close all
%%
% SigMinr, Part II

%%sig.simatrix

s = sig.spectrum('test.wav','Frame')
sig.simatrix(s)
m = aud.mfcc('george.wav','Frame')
sig.simatrix(m)
m = aud.mfcc('george.wav','Frame','FrameLength',1,'Hop',.5)
sig.simatrix(m)

%%sig.novelty

s = sig.spectrum('test.wav','Frame')
sm = sig.simatrix(s)
sig.novelty(sm)
sig.novelty(s)

%%sig.segment

n = sig.novelty(sm)
p = sig.peaks(n)
sg = sig.segment('test.wav',p)
sig.play(sg)
s = aud.mfcc(sg)

%%Statistics

s = sig.spectrum('test.wav')
sig.mean(s)
sig.std(s)
sig.histogram(s)
sig.centroid(s)
sig.spread(s)
sig.skewness(s)
sig.kurtosis(s)
sig.flatness(s)
sig.entropy(s)