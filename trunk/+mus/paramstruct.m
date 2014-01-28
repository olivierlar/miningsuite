function p = paramstruct

p = seq.paramstruct('music',...
                    {'freq','chro','dia','onset','offset','metre'},1);

%p = p.setfield('pitch',seq.paramstruct('pitch',{'freq','chro','dia'},0));

    freq = seq.paramtype('freq');
    freq.general = seq.paramgeneral(@octave);
    freq.inter = seq.paraminter(@mrdivide);
    freq.inter.general = seq.paramgeneral(@octave);
    freq.inter.general(2) = seq.paramgeneral(@sign);
p = p.setfield('freq',freq);

    chro = seq.paramtype('chro');
    chro.general = seq.paramgeneral(@mod12);
    chro.inter = seq.paraminter(@diff);
    chro.inter.general = seq.paramgeneral(@mod12);
    chro.inter.general(2) = seq.paramgeneral(@sign);
p = p.setfield('chro',chro);

    dia = seq.paramtype('dia',{'letter','accident','octave'});
    dia.general = seq.paramgeneral(@letter);
    dia.inter = seq.paraminter(@interdia,{'number','quality'});
    dia.inter.general = seq.paramgeneral(@number);
    dia.inter.general.general = seq.paramgeneral(@mod12);
p = p.setfield('dia',dia);

%p = p.setfield('rhythm',seq.paramstruct('rhythm',{'onset','offset'},0));
    
    ons = seq.paramtype('onset');
    %ons.general = seq.paramgeneral(@inbar);
    ons.inter = seq.paraminter(@diff); 
    %ons.inter.general = seq.paramgeneral(@inbar);
p = p.setfield('onset',ons);

p = p.setfield('offset',seq.paramtype('offset'));

p = p.setfield('metre',seq.paramtype('metre'));
    

function y = mod12(x)
y = mod(x,12);


function z = diff(x,y)
z = x - y;


function y = letter(x)
y = x.letter;


function z = interdia(x,y)
if isnumeric(x)
    z = x-y;
    return
end

z.number = x.letter - y.letter;
z.quality = x.accident - y.accident;
if ismember(mod(z.number,8),[1 2 5 6])
    switch mod(z.number,8)
        case 1
            minor = [1 4];
        case 2
            minor = [0 1 3 4];
        case 5
            minor = [0 1 4 5];
        case 6
            minor = [0 1 3 4 6];
    end
    if ismember(mod(x.letter,8),minor)
        z.quality = z.quality - 1;
    else
        z.quality = z.quality + 1;
    end
end


function y = number(x)
if isempty(x)
    y = x;
else
    y = x.number;
end


function y = inbar(x)
y = mod(x,8);