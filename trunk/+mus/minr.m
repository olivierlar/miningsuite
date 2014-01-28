function out = minr(arg,varargin)
%varargout = sig.operate('musi','minr',initoptions,@init,@main,varargin);

options = mus.options(initoptions,varargin);

%function [x type] = init(x,option)
%type = 'mus.sequence';


%function out = main(in,option,postoption)

if isa(arg,'mus.Sequence')
    out = arg;
else
    out = mus.Sequence;
end

if options.mode
    concept = initmode;
else
    concept = [];
end

if ischar(arg)
    if strcmpi(arg,'Folder')
        dd = dir;
        dn = {dd.name};
        for i = 1:length(dn)
            out = read(out,dn{i},options,concept,1);
        end
    else
        out = read(out,arg,options,concept,0);
    end
elseif isa(arg,'sig.design')
    if strcmpi(arg.input,'Folder')
        dd = dir;
        dn = {dd.name};
        for i = 1:length(dn)
            in = arg.eval(dn{i});
            p = in{1}.sdata(in{1}.peak.content{1});
        end
    else
        in = arg.eval;
        p = in{1}.sdata(in{1}.peak.content{1});
        memory = [];
        note = [];
        ps = mus.paramstruct;
        for i = 1:length(p)
            param = mus.param(ps,0,NaN,NaN,p(i),p(i)+.01);
            note = pat.event(out,param,note);
            out = out.integrate(note);
            if ~isempty(options)
                [out.concept,memory] = process(out.concept,note,memory,...
                                               options);
            end
        end
    end
elseif isa(arg,'mus.Sequence')
    out = arg;
    if iscell(arg.files)
        for i = 1:length(arg.content)
            if options.notes
                notes = options.notes;
                notes(notes > length(arg.content{i})) = [];
                out.content{i} = arg.content{i}(notes);
            end
            if options.t1 || options.t2
                t = zeros(length(out.content{i}),1);
                for j = 1:length(out.content{i})
                    t(j) = out.content{i}{j}.parameter.getfield('onset').value;
                end
                if options.t1
                    out.content{i}(t < options.t1) = [];
                end
                if options.t2
                    out.content{i}(t > options.t2) = [];
                end
            end
            memory = [];
            if options.metre
                pattern = initpattern;
            else
                pattern = [];
            end
            for j = 1:length(out.content{i})
                [out.concept,memory,out.content{i}{j}] = ...
                    process(concept,out.content{i}{j},memory,options,...
                            pattern);
            end
        end
    else
        if options.notes
            options.notes(options.notes > length(arg.content)) = [];
            out.content = arg.content(options.notes);
        end
        if options.t1 || options.t2
            t = zeros(length(out.content),1);
            for j = 1:length(out.content)
                t(j) = out.content{j}.parameter.getfield('onset').value;
            end
            if options.t1
                out.content(t < options.t1) = [];
            end
            if options.t2
                out.content(t > options.t2) = [];
            end
        end
        memory = [];
        if options.metre
            pattern = initpattern;
        else
            pattern = [];
        end
        for j = 1:length(out.content)
            [out.concept,memory,out.content{j}] = ...
                process(concept,out.content{j},memory,options,pattern);
        end
    end
end


function out = read(out,name,options,concept,folder)
memory = [];
ps = mus.paramstruct;

fid = fopen(name);
if fid<0
    e = sig.envelope(name);
    p = sig.peak(e,'Threshold',.5);
    out = mus.minr(p);
    return
    if ~folder
        error('incorrect file');
    end
    return
end
head = fread(fid,'uint8');
fclose(fid);
if isequal(head(1:4)',[77 84 104 100])  % MIDI format
    [nmat options.tempo] = mus.midi2nmat(name);
    if options.notes
        options.notes(options.notes > size(nmat,1)) = [];
        nmat = nmat(options.notes,:);
    end
    if options.t1
        nmat(nmat(:,6) < options.t1,:) = [];
    end
    if options.t2
        nmat(nmat(:,6) > options.t2,:) = [];
    end
    note = [];
    if folder
        out.content{end+1} = [];
        out.files{end+1} = name;
    else
        out.files = name;
    end
    if options.metre
        pattern = initpattern;
    else
        pattern = [];
    end
    for j = 1:size(nmat,1)
        param = mus.param(ps,nmat(j,4),[],[],...
                           nmat(j,6),nmat(j,6)+nmat(j,7));
        note = pat.event(out,param,note);
        note.address = j;
        out = out.integrate(note);
        if ~isempty(options)
            [concept,memory,note] = process(concept,note,memory,...
                                            options,pattern);
        end
    end
    if folder
        out.concept{end+1} = concept;
    else
        out.concept = concept;
    end
else
    %sig.operate('musi','minr',options,@init,@main,varargin);
end


function out = peaks(out,p,options)
memory = [];
ps = mus.paramstruct;
for j = 1:length(p)
end


function [concept memory note] = process(concept,note,memory,options,pattern)
address = note.address;
pitch = note.parameter.getfield('chro').value;
dia = [];
if ~isempty(concept)
    for i = 1:length(concept.modes)
        if isempty(concept.modes(i).eventscores) || ...
                ~concept.modes(i).eventscores(end)
            continue
        end
        dia = pitch2dia(concept.modes(i).origins(1));
        interdia = interpitch2interdia(pitch - concept.modes(i).origins(1),...
                                       dia.letter);
        dia.letter = dia.letter + interdia.number;
        dia.accident = dia.accident + interdia.quality;
    end
    if isempty(dia)
        dia = pitch2dia(pitch);
    end
    note.parameter = note.parameter.setfield('dia',...
                        seq.paramval(note.parameter.getfield('dia'),dia));
end

if options.mode
    found = 0;
    concept.note.activate(pitch,0,0,address);
    for j = 1:length(concept.modes)
        for k = 1:min(length(concept.modes(j).origins),1) %%%%%
            if concept.modes(j).currentscores(k) > 0
                [is loc] = ismember(mod(pitch,12),...
                                    mod(concept.modes(j).scale + ...
                                        concept.modes(j).origins(k),12));
                if is
                    %if ispivot && ismember(loc,concept.modes(j).pivot)
                    %    concept.modes(j).ispivot(address,k) = 1;
                    %    ispivot = 0;
                    %end
                    concept.modes(j).currentdegreescores(1,loc,k) = 1;
                    found = 1;
                else
                    scores = NaN(1,length(concept.modes));
                    for l = 1:length(concept.modes)
                        is2 = ismember(mod(pitch,12),...
                                       mod(concept.modes(l).scale + ...
                                           concept.modes(j).origins(k),...
                                           12));
                        if is2
                            k2 = find(concept.modes(l).origins == ...
                                      concept.modes(j).origins(k));
                            if isempty(k2)
                                scores(l) = 0;
                            else
                                scores(l) = concept.modes(l).currentscores(k2);
                            end
                        end
                    end
                    [bscore l] = max(scores);            
                    [is2 loc2] = ismember(mod(pitch,12),...
                                          mod(concept.modes(l).scale + ...
                                            concept.modes(j).origins(k),...
                                            12));
                    if 0 %is2
                        k2 = find(concept.modes(l).origins == ...
                                  concept.modes(j).origins(k));
                        if isempty(k2)
                            concept.modes(l).origins(end+1) = ...
                                concept.modes(j).origins(k);
                            k2 = length(concept.modes(l).origins);
                        end
                        if length(concept.modes(l).currentscores) < k2 || ...
                                ~concept.modes(l).currentscores(k2)
                            concept.modes(l).currentdegreescores(1,:,k2) = ...
                                concept.modes(j).currentdegreescores(1,:,k) .* ...
                                (concept.modes(l).scale == ...
                                 concept.modes(j).scale);
                            concept.modes(l).currentdegreescores(1,loc2,k2) = 1;
                            concept.modes(l).currentscores(k2) = 1;
                        end
                        concept.modes(j).currentdegreescores(1,loc2,k) = 0;
                        if all(concept.modes(l).currentdegreescores(1,:,k2) >= ...
                                concept.modes(j).currentdegreescores(1,:,k))
                            concept.modes(j).currentdegreescores(1,:,k) = ...
                                zeros(1,size(concept.modes(j).currentdegreescores,2));
                            concept.modes(j).currentscores(k) = 0;
                            concept.modes(l).eventscores(address,k2) = 1;
                        end
                        found = 1;
                    end
                end
            end
        end
    end
    
    if ~found
        best = 0;
        scal = concept.note.heights - pitch;
        for j = 1:length(concept.modes)
            modscal = concept.modes(j).scale;
            for k = 1:length(concept.modes(j).pivot)
                modscalk = modscal - modscal(concept.modes(j).pivot(k));
                scok = sum(ismember(scal,modscalk)) / length(scal);
                if scok > best
                    origin = pitch - modscal(concept.modes(j).pivot(k));
                    f = find(concept.modes(j).origins == origin,1);
                    if ~isempty(concept.modes(j).currentscores)
                        concept.modes(j).currentscores = ...
                            zeros(size(concept.timescores{j}));
                    end
                    if isempty(f)
                        no = length(concept.modes(j).origins) + 1;
                        concept.modes(j).origins(no) = origin;
                        concept.modes(j).currentscores(no) = scok;
                        concept.modes(j).eventscores(address,no)...
                            = scok;
                        concept.degreescores{j}(1,:,no) = ...
                            ismember(modscalk,scal);
                    else
                        concept.modes(j).currentscores(f) = scok;
                        if ~isempty(concept.modes(j).timescores) && ...
                                ~concept.modes(j).timescores(address-1,f)
                            concept.modes(j).eventscores(address,f) = scok;
                        end
                    end
                    best = scok;
                end
            end
        end
    end

    for j = 1:length(concept.modes)
        if ~isempty(concept.modes(j).currentscores)
            concept.modes(j).eventscores(address,...
                          1:length(concept.modes(j).currentscores)) = ...
                concept.modes(j).currentscores;
            if ~isempty(concept.degreescores{j})
                concept.modes(j).degreescores(address,...
                              1:size(concept.degreescores{j},2),...
                              1:size(concept.degreescores{j},3)) ...
                    = concept.degreescores{j};
            end
        end
    end
end

if options.reduce
    if isempty(memory)
        memory(1).pitch = pitch;
        memory(1).ioi = 0;
        memory(1).event = note;
    else
        f = find(pitch == [memory.pitch],1);
        if isempty(f)
            memory(end+1).pitch = pitch;
            memory(end).ioi = 0;
            memory(end).event = note;
        else
            meta = memory(f).event.extend(note,memory(f).event.parameter);
            meta.parameter.setfield('rhythm','off',...
                                     note.parameter.getfield('rhythm','off'));
            %memory(f) = [];
            %[concept,memory] = analyze_note(concept,meta,memory);
        end
    end
end

if options.metre
    if isempty(note.previous)
        pat.occurrence(pattern.v,[],note); % should be r
        pattern.occ0.memorize(note);
    else
        pat.syntagm(note.previous,note);
        if ~isempty(note.previous.previous)
            pat.syntagm(note.previous.previous,note);
        end
    end
end


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

    mode.key = 'Mode';
    mode.type = 'Boolean';
options.mode = mode;

    metre.key = 'Metre';
    metre.type = 'Boolean';
options.metre = metre;

    reduce.key = 'Reduce';
    reduce.type = 'Boolean';
options.reduce = reduce;


function p = initpattern
ps = mus.paramstruct;
p.root = pat.pattern([],[],ps);
p.occ0 = p.root.occurrence([],[]);

pat.pattern(p.root,ps);
p.v = p.root.children{1};
p.v.general = p.root;
p.root.specific = p.v;

%pp = ps;
%pp.fields{4} = seq.paramval(param.fields{4},1);
%pat.pattern(p.root,pp,ps);
%p.r = root.children{1};
%p.r.general = p.v;
%p.v.specific = p.r;


function c = initmode
c.modes = mus.mode('minor',[0 2 3 5 7 9 11 12],1);
c.modes(2) = mus.mode('major',[0 2 4 5 7 9 11 12],1);
c.timescores = cell(1,length(c.modes));
c.degreescores = cell(1,length(c.modes));
c.note = mus.pitch;


function dia = pitch2dia(pitch)
switch mod(pitch,12)
    case 0
        dia.letter = 0;
        dia.accident = 0;
    case 1
        dia.letter = 0;
        dia.accident = 1;
    case 2
        dia.letter = 1;
        dia.accident = 0;
    case 3
        dia.letter = 2;
        dia.accident = -1;
    case 4
        dia.letter = 2;
        dia.accident = 0;
    case 5
        dia.letter = 3;
        dia.accident = 0;
    case 6
        dia.letter = 3;
        dia.accident = 1;
    case 7
        dia.letter = 4;
        dia.accident = 0;
    case 8
        dia.letter = 5;
        dia.accident = -1;
    case 9
        dia.letter = 5;
        dia.accident = 0;
    case 10
        dia.letter = 6;
        dia.accident = -1;
    case 11
        dia.letter = 6;
        dia.accident = 0;
end
dia.octave = floor(pitch/12)-1;


function interdia = interpitch2interdia(interpitch,dia)
switch mod(interpitch,12)
    case 0
        interdia.number = 0;
        interdia.quality = 0;
    case 1
        interdia.number = 1;
        interdia.quality = -1;
    case 2
        interdia.number = 1;
        interdia.quality = 0;
    case 3
        interdia.number = 2;
        interdia.quality = -1;
    case 4
        interdia.number = 2;
        interdia.quality = 0;
    case 5
        interdia.number = 3;
        interdia.quality = 0;
    case 6
        interdia.number = 3;
        interdia.quality = 1;
    case 7
        interdia.number = 4;
        interdia.quality = 0;
    case 8
        interdia.number = 5;
        interdia.quality = -1;
    case 9
        interdia.number = 5;
        interdia.quality = 0;
    case 10
        interdia.number = 6;
        interdia.quality = -1;
    case 11
        interdia.number = 6;
        interdia.quality = 0;
end
switch interdia.number
    case 1
        if ismember(dia,[2 6])
            interdia.quality = interdia.quality + 1;
        end
    case 2
        if ismember(dia,[1 2 5 6])
            interdia.quality = interdia.quality + 1;
        end
    case 5
        if ismember(dia,[2 5 6])
            interdia.quality = interdia.quality + 1;
        end
    case 6
        if ismember(dia,[1 2 4 5 6])
            interdia.quality = interdia.quality + 1;
        end
end
interdia.interoctave = fix(interpitch/12);