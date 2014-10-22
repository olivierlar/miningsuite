function p = paramstruct

p = seq.paramstruct('audio',{'onset','offset'},1);

        ons = seq.paramtype('onset');
        %ons.general = seq.paramgeneral(@inbar);
        ons.inter = seq.paraminter(@diff); 
        %ons.inter.general = seq.paramgeneral(@inbar);
    p = p.setfield('onset',ons);

    p = p.setfield('offset',seq.paramtype('offset'));


function z = diff(x,y)
z = x - y;