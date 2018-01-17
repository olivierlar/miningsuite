% SIG.PLAY
% plays the audio waveform.
% Syntax: sig.play(filename)
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function varargout = play(varargin)

    options = sig.Signal.signaloptions();

%         ch.key = 'Channel';
%         ch.type = 'Integer';
%         ch.default = 0;
%     options.ch = ch;
% 
%         sg.key = 'Segment';
%         sg.type = 'Integer';
%         sg.default = 0;
%     options.sg = sg;
% 
%         se.key = 'Sequence';
%         se.type = 'Integer';
%         se.default = 0;
%     options.se = se;
% 
%         inc.key = 'Increasing';
%         inc.type = 'MIRtb';
%     options.inc = inc;
% 
%         dec.key = 'Decreasing';
%         dec.type = 'MIRtb';
%     options.dec = dec;
% 
%         every.key = 'Every';
%         every.type = 'Integer';
%     options.every = every;
% 
%         burst.key = 'Burst';
%         burst.type = 'Boolean';
%         burst.default = 1;
%     options.burst = burst;


    varargout = sig.operate('sig','play',options,@init,@main,@after,varargin);
end


function [x,type] = init(x,option)
    type = '?';
end


function out = main(x,option)
    x = x{1};
    if iscell(x.design)
        filenames = x.design;
    else
        filenames = x.design.files;
    end
    sig.compute(@playfile,x.Ydata,filenames,x.Srate,x.sonifier);
    out = {};
end


function varargout = playfile(d,name,rate,synth)
    if iscell(name)
        name = name{1};
    end
    display(['Playing file: ' name]);
    nch = d.size('freqband');
    nfr = d.size('frame');
    for i = 1:nch
        di = d;
        if nch > 1
            display(['Playing channel: ' num2str(i)]);
            di = di.extract('freqband',i);
        end
        for j = 1:nfr
            if nfr == 1
                s = di.content;
            else
                s = di.view('frame',j);
            end
            tic
            [s,rate] = synth(s,rate);
            soundsc(s,rate);
            idealtime = length(s)/rate;
            practime = toc;
            if practime < idealtime
                pause(idealtime - practime + .1)
            end
        end
    end
    varargout = {1}; % How to avoid this?
end


function x = after(x,option)
end