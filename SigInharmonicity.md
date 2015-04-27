# sig.inharmonicity: Partials non-multiple of fundamentals #

`sig.inharmonicity(`_x_`)` estimates the inharmonicity, i.e., the amount of partials that are not multiples of the fundamental frequency, as a value between 0 and 1. More precisely, the inharmonicity considered here takes into account the amount of energy outside the ideal harmonic series.

For that purpose, we use a simple function estimating the inharmonicity of each frequency given the fundamental frequency _f0_:

![https://miningsuite.googlecode.com/svn/wiki/SigInharmonicity_ex1.png](https://miningsuite.googlecode.com/svn/wiki/SigInharmonicity_ex1.png)


|**WARNING**: This simple model presupposes that there is only one fundamental frequency.|
|:---------------------------------------------------------------------------------------|

<br>
<h2>Flowchart Interconnections</h2>

mirinharmonicity accepts as main input either:<br>
<ul><li>sig.spectrum objects,<p>
</li><li>sig.input objects (same as for sig.spectrum),<p>
</li><li>file name(s) or the 'Folder' keyword.<br>
<br></li></ul>

sig.inharmonicity can return several outputs:<br>
<ol><li>the inharmonicity rate itself,<p>
</li><li>the <code>sig.spectrum data</code>, and<p>
</li><li>the fundamental frequency <i>'f0'</i>.</li></ol>

<br>
<h2>Frame decomposition</h2>

<code>sig.inharmonicity(…,'Frame',…)</code> performs first a frame decomposition, with by default a frame length of 10 ms and a hop factor of 12,5% (1.25 ms). For the specification of other frame configuration using additional parameters, cf. the previous SigFrame vs. ‘Frame’ section.<br>
<br>
<br>
<h2>Option</h2>

<code>sig.inharmonicity(…,'f0',</code><i>f</i><code>)</code> bases the computation of the inharmonicity on the fundamental frequency indicated by <i>f</i>. The frequency data can be either a number, or a sig.scalar object (for instance, the output of a <code>sig.pitch</code> computation).<br>
<br>
By default, the fundamental frequency is computed using the command:<br>
<br>
<pre><code>f=mirpitch(…,'Mono')<br>
</code></pre>