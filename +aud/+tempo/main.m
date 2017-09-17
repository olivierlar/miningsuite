% AUD.TEMPO.MAIN
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(in,option)
    x = in{1};
    if strcmpi(x.yname,'Tempo')
        out = in;
    else
        p = sig.compute(@routine,x.peakpos);
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


function out = routine(d)
    e = d.apply(@convert,{},{'element'},1,'{}');
    out = {e};
end


function y = convert(x)
    y = 60./x{1};
end