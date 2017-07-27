% MUS.PARAM
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function p = param(ps,chro,letter,accident,ons,off,channel,harm)

p = ps.type2val;
    
p = p.setfield('chro',seq.paramval(ps.getfield('chro'),chro));

if isempty(letter)
    p = p.setfield('dia',seq.paramval(ps.getfield('dia'),[]));
else
    dia.letter = letter;
    dia.accident = accident;
    dia.octave = [];
    p = p.setfield('dia',seq.paramval(ps.getfield('dia'),dia));
end
    
p = p.setfield('onset',seq.paramval(ps.getfield('onset'),ons));

p = p.setfield('offset',seq.paramval(ps.getfield('offset'),off));

if 0
    p = p.setfield('metre',seq.paramval(ps.getfield('metre'),[]));
    p = p.setfield('channel',seq.paramval(ps.getfield('channel'),channel));

    if nargin == 8
        if strcmp(harm,'-')
            harm = [];
        end
        p = p.setfield('harmony',seq.paramval(ps.getfield('harmony'),harm));
    end
end

%p = p.setfield('level',ps.getfield('level'));