% AUD.TEMPO.MAIN
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(in,option)
    x = in{1};
    if strcmpi(x.yname,'Tempo')
        out = in;
    else
        p = sig.compute(@routine,x.peakpos,x.Xaxis.name);
        pc = zeros(1,length(p.content));
        for i = 1:length(p.content)
            if isempty(p.content{i})
                pc(i) = NaN;
            else
                pc(i) = p.content{i};
            end
        end
        t = sig.Signal(pc','Name','Tempo','Srate',in{1}.Srate,'FbChannels',in{1}.fbchannels);
        out = {t in{1}};
    end
end


function out = routine(d,xname)
    if strcmp(xname,'Lag')
        method = @lag2bpm;
    else
        method = @freq2bpm;
    end
    e = d.apply(method,{},{'element'},1,'{}');
    out = {e};
end


function y = lag2bpm(x)
    y = 60./x{1};
end


function y = freq2bpm(x)
    y = 60.*x{1};
end