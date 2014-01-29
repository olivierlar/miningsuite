function out = play(obj,varargin)

if nargin>1 && iscell(varargin) && isstruct(varargin{1})
    options = varargin{1};
else
        ch.key = 'Channel';
        ch.type = 'Integer';
        ch.default = 0;
    options.ch = ch;

        sg.key = 'Segment';
        sg.type = 'Integer';
        sg.default = 0;
    options.sg = sg;

        se.key = 'Sequence';
        se.type = 'Integer';
        se.default = 0;
    options.se = se;

        inc.key = 'Increasing';
        inc.type = 'MIRtb';
    options.inc = inc;

        dec.key = 'Decreasing';
        dec.type = 'MIRtb';
    options.dec = dec;

        every.key = 'Every';
        every.type = 'Integer';
    options.every = every;

        burst.key = 'Burst';
        burst.type = 'Boolean';
        burst.default = 1;
    options.burst = burst;

    options = sig.options(options,[{obj},varargin],'sig.play');
end

obj.playclass(options);
out = {};