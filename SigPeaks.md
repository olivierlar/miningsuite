# sig.peaks: Peak picking #

Peaks (or important local maxima) can be detected automatically from any data _x_ produced in MiningSuite using the command

```
sig.peaks(x)
```

If _x_ is a curve, peaks are represented by red circles:

![https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex1.png)

If _x_ is a frame-decomposed matrix, peaks are represented by white crosses:

![https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex2.png](https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex2.png)

<br>
<h2>Parameters specification</h2>

<ul><li><code>sig.peaks(…,'Total',</code><i>m</i><code>)</code>: only the <i>m</i> highest peaks are selected. If <i>m = Inf</i>, no limitation of number of peaks. Default value: <i>m = Inf</i><p>
</li><li>Border effects can be specified:<br>
<ul><li><code>sig.peaks(…,'NoBegin')</code> does not consider the first sample as a possible peak candidate.<br>
</li><li><code>sig.peaks(…,'NoEnd')</code> does not consider the last sample as a possible peak candidate.<p>
</li></ul></li><li><code>sig.peaks(…,'Order',</code><i>o</i><code>)</code> specifies the ordering of the peaks.<br>
<ul><li><i>o</i> = <code>'Amplitude'</code> orders the peaks from highest to lowest (Default choice.)<br>
</li><li><i>o</i> = <code>'Abscissa'</code> orders the peaks along the abscissa axis.<p>
</li></ul></li><li><code>sig.peaks(…,'Valleys')</code> detects valleys (local minima) instead of peaks.<p>
</li><li><code>sig.peaks(…,'Contrast',</code><i>cthr</i><code>)</code>: A given local maximum will be considered as a peak if the difference of amplitude with respect to both the previous and successive local minima (when they exist) is higher than the threshold <i>cthr</i>. This distance is expressed with respect to the total amplitude of the input signal: a distance of 1, for instance, is equivalent to the distance between the maximum and the minimum of the input signal. Default value: <i>cthr</i> = 0.1<p>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex3.png' /></li></ul>

<ul><li><code>sig.peaks(…,'SelectFirst',</code><i>fthr</i><code>)</code>: If the <code>'Contrast'</code> selection has been chosen, this additional option specifies that when one peak has to be chosen out of two candidates, and if the  difference of their amplitude is below the threshold <i>thr</i>, then the most ancien one is selected. Option toggled off by default. Default value if toggled on: <i>fthr</i> = <i>cthr</i>/2<p>
</li><li><code>sig.peaks(…,'Threshold',</code><i>thr</i><code>)</code>: A given local maximum will be considered as a peak if its normalized amplitude is higher than this threshold thr. A given local minimum will be considered as a valley if its normalized amplitude is lower than this threshold.  The normalized amplitude can have value between 0 (the minimum  of the signal in each frame) and 1 (the maximum in each frame). Default value: <i>thr</i> = 0 for peaks, <i>thr</i> = 1 for valleys.<p>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex4.png' />
</li><li><code>sig.peaks(…,'Interpol',</code><i>i</i><code>)</code> estimates more precisely the peak position and amplitude using interpolation. Performed only on data with numerical abscissae axis.<br>
<ul><li><i>i</i> = <code>'', 'no', 'off', 0</code>: no interpolation<br>
</li><li><i>i</i> = <code>'Quadratic'</code>: quadratic interpolation. (default value).<p>
</li></ul></li><li><code>sig.peaks(…,'Reso',</code><i>r</i><code>)</code> removes peaks whose abscissa distance to one or several higher peaks is lower than a given threshold. Possible value for the threshold: <i>r</i> = <code>'SemiTone'</code>: ratio between the two peak positions equal to 2^(1/12). By default, out of two conflicting peaks, the higher peak remains. If the keyword <code>'First'</code> is added, the peak with lower abscissa value remains instead.<p>
</li><li><code>sig.peaks(…,'Pref',</code><i>c</i><code>,</code><i>std</i><code>)</code> indicates a region of preference for the peak picking, centered on the abscissa value <i>c</i>, with a standard deviation of <i>std</i>.<p>
</li><li><code>sig.peaks(…,'Nearest',</code><i>t</i><code>,</code><i>s</i><code>)</code> takes the peak nearest a given abscissa values <i>t</i>. The distance is computed either on a linear scale (<i>s</i> = <code>'Lin'</code>) or logarithmic scale (<i>s</i> = <code>'Log'</code>). When using the <code>'Nearest'</code> option, only one peak is extracted.<p>
<blockquote>The <code>'Total'</code> parameter can then be used to indicate the number of peaks to preselect before the <code>'Nearest'</code> selection. If <code>'Total'</code> was still set to 1, it is then ignored – i.e., forced to Inf – in order to preselect all possible peaks.<p>
</blockquote></li><li><code>sig.peaks(…,'Normalize',</code><i>n</i><code>)</code> specifies whether frames are normalized globally or individually.<br>
<ul><li><i>n</i> = <code>'Global'</code> normalizes across the whole frames (as well as across the whole segments) of each audio file from 0 to  1 (default choice).<br>
</li><li><i>n</i> = <code>'Local'</code>: normalizes each segment, each frame, from 0 to 1 separately.<p>
</li></ul></li><li><code>sig.peaks(…,'Extract')</code> extracts from the curves all the positive continuous segments (or "curve portions") where peaks are located. First, a low-pass filtered version of the curve is computed, on which the temporal span of the positive lobes containing each peak are stored. The output consists of the part of the original non-filtered curve corresponding to the same temporal span. For instance:<p>
<pre><code> ac=sig.autocor('ragtime')<br>
</code></pre></li></ul>

<blockquote><img src='https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex5.png' />
<pre><code> sig.peaks(ac,'Extract')<br>
</code></pre>
<img src='https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex6.png' /></blockquote>

<ul><li>￼<code>sig.peaks(…,'Only')</code>, keeps from the original curve only the data corresponding to the peaks, and zeroes the remaining data.<p>
<pre><code> sig.peaks(ac,'Only')<br>
</code></pre></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex7.png' />

<ul><li><code>sig.peaks(…,'Track',</code><i>t</i><code>)</code>, where the input is some frame-decomposed vectorial data – such as spectrogram, for instance –, tracks peaks along time using McAulay & Quatieri's (1986) method: lines are drawn between contiguous temporal series of peaks that are sufficiently aligned. If a value <i>t</i> is specified, the variation between successive frames is tolerated up to <i>t</i>, expressed using the abscissae unit. For instance, the figure below shows the result (zoomed) of the following commands:<p>
<pre><code> s=sig.spectrum('trumpet','Frame');<br>
   sig.peaks(s,'Track', 25)<br>
</code></pre></li></ul>

<img src='https://miningsuite.googlecode.com/svn/wiki/SigPeaks_ex8.png' />

<ul><li><code>sig.peaks(…,'CollapseTracks',</code><i>ct</i><code>)</code>, collapses tracks into one single track, and remove small track transitions, of length shorter than <i>ct</i> samples. Default value: <i>ct</i> = 7.</li></ul>

<br>
<h2>Accessible Output</h2>

cf. §5.2 for an explanation of the use of the get method. Specific fields:<br>
<br>
<ul><li><code>'PeakPos'</code>: the abscissae position of the detected peaks, in sample index,</li></ul>

<ul><li><code>'PeakPosUnit'</code>: the abscissae position of the detected peaks, in the default abscissae representation,</li></ul>

<ul><li><code>'PeakPrecisePos'</code>: a more precise estimation of the abscissae position of the detected peaks computed through interpolation, in the default abscissae representation,</li></ul>

<ul><li><code>'PeakVal'</code>: the ordinate values associated to the detected peaks,</li></ul>

<ul><li><code>'PeakPreciseVal'</code>: a more precise estimation of the ordinate values associated to the detected peaks, computed through interpolation,</li></ul>

<ul><li><code>'PeakMode'</code>: the mode values associated to the detected peaks,</li></ul>

<ul><li><code>'TrackPos'</code>: the abscissae position of the peak tracks, in sample index,</li></ul>

<ul><li><code>'TrackPosUnit'</code>: the abscissae position of the peak tracks, in the default abscissae representation,</li></ul>

<ul><li><code>'TrackVal'</code>: the ordinate values of the peak tracks.