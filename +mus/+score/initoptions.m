function options = initoptions
    notes.key = 'Notes';
    notes.type = 'Numeric';
options.notes = notes;

    t1.key = 'StartTime';
    t1.type = 'Numeric';
options.t1 = t1;

    t2.key = 'EndTime';
    t2.type = 'Numeric';
options.t2 = t2;

    m1.key = 'StartMetre';
    m1.type = 'Numeric';
options.m1 = m1;

    m2.key = 'EndMetre';
    m2.type = 'Numeric';
options.m2 = m2;

    chan.key = 'Channel';
    chan.type = 'Numeric';
    chan.default = [];
options.chan = chan;

    mode.key = 'Mode';
    mode.type = 'Boolean';
options.mode = mode;

    spell.key = 'Spell';
    spell.type = 'Boolean';
options.spell = spell;

    group.key = 'Group';
    group.type = 'Boolean';
options.group = group;

    fuserepeat.key = 'FuseRepeat';
    fuserepeat.type = 'Boolean';
options.fuserepeat = fuserepeat;

    broderie.key = 'Broderie';
    broderie.type = 'Boolean';
options.broderie = broderie;

    passing.key = 'Passing';
    passing.type = 'Boolean';
options.passing = passing;

    retention.key = 'Retention';
    retention.type = 'Boolean';
options.retention = retention;

    metricanchor.key = 'MetricAnchor';
    metricanchor.type = 'Integer';
    metricanchor.default = NaN;
options.metricanchor = metricanchor;

    motif.key = 'Motif';
    motif.type = 'Boolean';
options.motif = motif;

    contour.key = 'Contour';
    contour.type = 'Boolean';
options.contour = contour;

    mod12.key = 'Octave';
    mod12.type = 'Boolean';
options.mod12 = mod12;

    chro.key = 'Chro';
    chro.type = 'Boolean';
    chro.default = 1;
options.chro = chro;

    dia.key = 'Dia';
    dia.type = 'Boolean';
    dia.default = 1;
options.dia = dia;

    onset.key = 'Onset';
    onset.type = 'Boolean';
options.onset = onset;

    metre.key = 'Metre';
    metre.type = 'Boolean';
options.metre = metre;