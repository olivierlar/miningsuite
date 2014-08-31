function options = options
    options = sig.spectrum.options;
    options.phase.default = 0;
    
        band.type = 'String';
        band.choice = {'Freq','Mel','Bark'};
        band.default = 'Freq';
        band.when = 'Both';
    options.band = band;

        nbbands.key = 'Bands';
        nbbands.type = 'Numeric';
        nbbands.default = 0;
        nbbands.when = 'After';
    options.nbbands = nbbands;
    
        terhardt.key = 'Terhardt';
        terhardt.type = 'Boolean';
        terhardt.default = 0;
        terhardt.when = 'After';
    options.terhardt = terhardt;

        mask.key = 'Mask';
        mask.type = 'Boolean';
        mask.default = 0;
        mask.when = 'After';
    options.mask = mask;
end