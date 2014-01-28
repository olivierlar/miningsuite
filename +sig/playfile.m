function playfile(synth,d,name,rate,varargin)

if iscell(name)
    name = name{1};
end
display(['Playing file: ' name]);

d = synth(d,varargin{:});

tic
sound(d,rate);
idealtime = length(d)/rate;
practime = toc;
if practime < idealtime
    pause(idealtime-practime)
end