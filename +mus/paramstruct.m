% MUS.PARAMSTRUCT
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function p = paramstruct(options)

p = seq.paramstruct('music',...
            {'freq','chro','dia','onset','offset'...
             %,'metre','channel','harmony','group'...
             },1);

%p = p.setfield('pitch',seq.paramstruct('pitch',{'freq','chro','dia'},0));

    freq = seq.paramtype('freq');
    freq.general = seq.paramgeneral(@octave);
    freq.inter = seq.paraminter(@mrdivide);
    freq.inter.general = seq.paramgeneral(@octave);
    if options.contour
        freq.inter.general(2) = seq.paramgeneral(@sign);
    end
p = p.setfield('freq',freq);

    chro = seq.paramtype('chro');
    if options.mod12
        chro.general = seq.paramgeneral(@mod12);
    end
    chro.inter = seq.paraminter(@diff);
    if options.mod12
        chro.inter.general = seq.paramgeneral(@mod12);
    end
    if options.contour
        chro.inter.general = seq.paramgeneral(@sign);
    end
p = p.setfield('chro',chro);

    dia = seq.paramtype('dia',{'letter','accident','octave'});
    %dia.general = seq.paramgeneral(@letter);
    dia.inter = seq.paraminter(@interdia,{'number','quality'});
    %dia.inter.general = seq.paramgeneral(@number);
    %dia.inter.general.general = seq.paramgeneral(@mod12);
p = p.setfield('dia',dia);

%p = p.setfield('rhythm',seq.paramstruct('rhythm',{'onset','offset'},0));
        
        ons = seq.paramtype('onset');
        %ons.general = seq.paramgeneral(@inbar);
        ons.inter = seq.paraminter(@diff); 
        %ons.inter.general = seq.paramgeneral(@inbar);
    p = p.setfield('onset',ons);

    p = p.setfield('offset',seq.paramtype('offset'));

if 0
        metre = seq.paramtype('metre',{'bar','inbar'});
        metre.general = seq.paramgeneral(@inbar);
    p = p.setfield('metre',metre);

    p = p.setfield('channel',seq.paramtype('channel'));

    p = p.setfield('harmony',seq.paramtype('harmony'));

    p = p.setfield('group',seq.paramtype('group'));
end

%    level = seq.paramtype('level');
%    level.inter = seq.paraminter(@diff);
%p = p.setfield('level',level);


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

if ~isempty(x.octave)
    x.letter = x.letter + x.octave*7;
end
if ~isempty(y.octave)
    y.letter = y.letter + y.octave*7;
end
z.number = x.letter - y.letter;

z.quality = (x.accident - y.accident);
if z.number < 0
    z.quality = - z.quality;
end
if ismember(mod(abs(z.number),8),[1 2 5 6])
    switch mod(abs(z.number),8)
        case 1  % Secund interval
            minor = [2 6];  % EF and BC
        case 2  % Third interval
            minor = [1 2 5 6];
        case 5  % Sixth interval
            minor = [2 5 6];
        case 6  % Seventh interval
            minor = [1 2 4 5 6];
    end
    if ismember(mod(min(x.letter,y.letter),8),minor)
        z.quality = z.quality - 1;
    else
        %z.quality = z.quality + 1;
    end
end


function y = number(x)
if isempty(x)
    y = x;
else
    y = x.number;
end


function y = inbar(x)
y = x.inbar;