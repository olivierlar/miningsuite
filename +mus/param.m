function p = param(ps,chro,letter,accident,ons,off)

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
p = p.setfield('metre',seq.paramval(ps.getfield('metre'),[]));