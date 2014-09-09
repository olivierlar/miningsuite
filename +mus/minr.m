% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function out = minr(arg,varargin)

options = mus.options(initoptions,varargin);

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
    out = reads(arg,options,concept);
elseif isa(arg,'sig.design')
    design = sig.design('mus','minr',arg,'mus.Sequence',...
                        @transcribe,options,[],arg.frame,[],varargin,...
                        arg.extract,0,arg.nochunk);
    design.evaluate = 1;
    out = {design};
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
            if options.metre || options.motif
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
        if options.metre || options.motif
            pattern = initpattern;
        else
            pattern = [];
        end
        for j = 1:length(out.content)
            if j == length(out.content)
                ioi = Inf;
            else
                ioi = out.content{j+1}.parameter.getfield('onset').value ...
                    - out.content{j}.parameter.getfield('onset').value;
            end
            [out.concept,out.content{j},memory] = ...
                process(concept,out.content{j},memory,options,pattern,ioi);
        end
    end
elseif isa(arg,'sig.data')
    out = transcribe(arg);
end


function out = reads(arg,options,concept)
out = mus.Sequence;
if strcmpi(arg,'Folder')
    d = dir;
    dn = {d.name};
    for i = 1:length(dn)
        out = read(out,dn{i},options,concept,1);
    end
else
    out = read(out,arg,options,concept,0);
end


function out = read(out,name,options,concept,folder)
fid = fopen(name);
if fid<0
    if ~folder
        error('incorrect file');
    end
    return
end
head = fread(fid,'uint8');
fclose(fid);
if 0
    %nmat = [(0:5)',ones(6,2),[60;62;60;64;60;65],ones(6,1),(0:5)',ones(6,2)];
    %p = [60;62;64;65];
    %notes = struct('chro',num2cell([p;p;p;67;p;67;p;p]),...
    %    'ons',num2cell([0 2 4 6 10 12 14 16 20 21 23 25 27 30 32 33 35 37 40 42 44 45 50 52 54 56]'),...
    %    'dur',num2cell(ones(4*6+2,1)),'chan',num2cell(ones(4*6+2,1)));
elseif isequal(head(1:4)',[77 84 104 100])  % MIDI format
    nmat = mus.midi2nmat(name);
    notes = struct('chro',num2cell(nmat(:,4)),'ons',num2cell(nmat(:,6)),...
                   'dur',num2cell(nmat(:,7)),'chan',num2cell(nmat(:,3)));
    out = process_notes(notes,out,name,options,concept,folder);
elseif 1
    fid = fopen(name,'rt');
    if 0 % mathieu
        C = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %s \n');
        notes = struct('chro',num2cell(C{1}),'ons',num2cell(C{8}),...
                       'dur',num2cell(C{9}),'chan',num2cell(C{11}),...
                       'harm',C{12});
    elseif 0 % jakob
        C = textscan(fid,'%f,%f,%f,%f\n');
        notes = struct('chro',num2cell(C{1}),...
                       'ons',num2cell(C{2}),...
                       'dur',num2cell(C{3}-C{2}));
        while ~feof(fid)
            C = textscan(fid,'%f,%f,%f,%f\n');
            if ~isempty(C{1})
                notes(end+1) = struct('chro',num2cell(C{1}),...
                                      'ons',num2cell(C{2}),...
                                      'dur',num2cell(C{3}-C{2}));
            end
        end
    elseif 1 % tom
        C = textscan(fid,'(%s %f %f %s %f)\n');
        C{1} = divscan(C{1});
        C{4} = divscan(C{4});
        notes = struct('chro',num2cell(C{2}),...
                       'ons',num2cell(C{1}),...
                       'dur',num2cell(C{4}),...
                       'chan',0,...num2cell(C{5}),...
                       'dia',num2cell(C{3}));
    end
    out = process_notes(notes,out,name,options,concept,folder);
else
    if options.t1 || options.t2
        if isempty(options.t1)
            options.t1 = 0;
        end
        if isempty(options.t2)
            options.t2 = Inf;
        end
        a = miraudio('Design','Extract',options.t1,options.t2);
    else
        a = miraudio('Design');
    end
    if 1
        p = mirpitch(a,'Frame','Enhanced',0,'Segment',...
                       'SegPitchGap',45,'SegMinLength',2,'NoFilterBank');
        p = mireval(p,name);
        p = p{1};
    else
        e = sig.envelope(name);
        p = sig.peak(e,'Threshold',.5);
        p = p.eval;
        p = p{1};
    end
    out = transcribe(out,p,options,concept);
end


function y = divscan(x)
y = zeros(size(x));
for i = 1:size(x,1);
    xi = textscan(x{i},'%f/%f');
    if isempty(xi{2})
        y(i) = xi{1};
    else
        y(i) = xi{1}/xi{2};
    end
end

        
function out = process_notes(notes,out,name,options,concept,folder)
if options.t1
    notes([notes.ons] < options.t1) = [];
end
if options.t2
    notes([notes.ons] > options.t2) = [];
end
if ~isempty(options.chan)
    notes(~ismember([notes.chan],options.chan)) = [];
end
if options.notes
    options.notes(options.notes > length(notes)) = [];
    notes = notes(options.notes);
end
note = [];
if folder
    out.content{end+1} = [];
    out.files{end+1} = name;
else
    out.files = name;
end
if options.metre || options.motif
    pattern = initpattern(options);
else
    pattern = [];
end
if options.mode
    mode = mus.scale([]);
else
    mode = [];
end
memo = [];
ps = mus.paramstruct(options);
for j = 1:length(notes)
    %j
    if isfield(notes,'dia')
        letter = notes(j).dia;
    else
        letter = [];
    end
    if isfield(notes,'harm')
        harm = notes(j).harm;
    else
        harm = [];
    end
    if isfield(notes,'chan')
        chan = notes(j).chan;
    else
        chan = 0;
    end
    param = mus.param(ps,notes(j).chro,letter,[],...
                         notes(j).ons,notes(j).ons+notes(j).dur,...
                         chan,harm);
    note = pat.event(out,param,note);
    note.address = j;
    out = out.integrate(note);
    if j == length(notes)
        ioi = Inf;
    else
        ioi = notes(j+1).ons - notes(j).ons;
    end
    if ~isempty(options)
        [concept,note,memo] = process(concept,note,memo,options,...
                                      pattern,mode,ioi);
    end
end
if 0 %options.group
    for i = 1:length(memo)
        if ~isempty(memo{i}(1))
            mus.group(memo{i}(1),Inf,options);
        end
    end
end
%process(concept,[],memo,options,pattern,mode,ioi);
if folder
    out.concept{end+1} = concept;
else
    out.concept = concept;
end


function out = transcribe(out,in,options,concept)
ps = mus.paramstruct;
if isa(in,'sig.envelope')
    p = in{1}.sdata(in{1}.peak.content{1});
    memory = [];
    note = [];
    for i = 1:length(p)
        param = mus.param(ps,0,NaN,NaN,p(i),p(i)+.01);
        note = pat.event(out,param,note);
        note.address = i;
        out = out.integrate(note);
        if ~isempty(options)
            [out.concept,memory] = process(out.concept,note,memory,options);
        end
    end
elseif isa(in,'mirpitch')
    reso = 100;    
    d = get(in,'Mean');
    st = get(in,'Start');
    en = get(in,'End');
    stb = get(in,'Stable');
    fp = get(in,'FramePos');
    
    for i = 1:length(d)
        scal = [];
        memory = [];
        note = [];
        for j = 1:length(d{i}{1}{1})
            freq = d{i}{1}{1}(j);
            [scal,degr] = integrate(scal,freq,reso);
            ons = fp{i}{1}(1,st{i}{1}{1}(j));
            off = fp{i}{1}(2,en{i}{1}{1}(j));
            param = mus.param(ps,degr,NaN,NaN,ons,off);
            note = pat.event(out,param,note);
            note.address = j;
            out = out.integrate(note);
            if ~isempty(options)
                [out.concept,memory] = process(concept,note,memory,options);
            end
        end
    end
end


function [concept,note,memo] = process(concept,note,memo,options,...
                                       pattern,mode,ioi)
address = note.address;
pitch = note.parameter.getfield('chro').value;
%channel = note.parameter.getfield('channel');
%chan = channel.value;
if 1 %isempty(chan)
    chan = 0;
end
%channel.value = [];
%note.parameter = note.parameter.setfield('channel',channel);

dia = [];
if ~isempty(concept)
    for i = 1:length(concept.modes)
        %if isempty(concept.modes(i).eventscores) || ...
        %        ~concept.modes(i).eventscores(end)
            continue
        %end
        dia = pitch2dia(concept.modes(i).origins(1));
        interdia = interpitch2interdia(pitch - concept.modes(i).origins(1),...
                                       dia.letter);
        if isempty(interdia)
            dia = [];
        else
            dia.letter = dia.letter + interdia.number;
            dia.accident = dia.accident + interdia.quality;
        end
    end
    if isempty(dia)
        dia = pitch2dia(pitch);
    end
    note.parameter = note.parameter.setfield('dia',...
                        seq.paramval(note.parameter.getfield('dia').type,dia));
end

if options.metre
    pos = round(note.parameter.getfield('onset').value/.15152);
    metre = note.parameter.getfield('metre');
    barpos = pos/6+1;
    metre.value.bar = round(barpos);
    metre.value.inbar = round(rem(barpos,1)*6);
    note.parameter = note.parameter.setfield('metre',metre);
end

note.parameter

if length(memo) < chan+1 
    memo{chan+1} = [];
end
k = 1;
while k <= length(memo{chan+1})
    if k > 1
        break
    end
    if ~isempty(pattern)
        sk = pat.syntagm(memo{chan+1}(k),note,pattern.root);
    else
        sk = seq.syntagm(memo{chan+1}(k),note);
    end
    sks = sk;

    if options.group && k == 1
        ioi1 = sk.parameter.getfield('onset').inter.value;
            % New inter-onset interval
        [memo,mode] = mus.group(sk.from,ioi1,ioi,options,...
                                note,pitch,memo,chan,mode,pattern);
    end

    if options.reduce
        t = note.parameter.getfield('onset').value;
        p1 = sk.from.parameter.getfield('chro').value;
        if 0 %p1 == pitch
            meta = sk.from.extend(note,sk.from.parameter);
            meta.parameter = meta.parameter.setfield('offset',...
                                        note.parameter.getfield('offset'));
            concept = process(concept,meta,[],options,pattern);
        elseif abs(pitch - p1) < 3
            t1 = sk.from.parameter.getfield('onset').value;
            for j = 1:length(sk.from.to)
                p2 = sk.from.to(j).from.parameter.getfield('chro').value;
                t2 = sk.from.to(j).from.parameter.getfield('onset').value;
                if sign(p2 - p1) == sign(p1 - pitch) && ...
                        abs(p1 - p2) < 3 && ...
                        abs(log( (t-t1) / (t1-t2) )) < .1
                    sk.from.to(j).passing = 1;
                    sk.passing = 1;
                    sk.from.passing = [sk.from.to(j) sk];
                end
            end
        end
    end
    
    if 0 %1 %options.metre || options.motif
        sk.memorize;
    end
    
    k = k + 1;
end
%if k == 1 % First note
%    lvl = seq.paramval(note.parameter.getfield('level'),1);
%    note.parameter = note.parameter.setfield('level',lvl);
%end

if (options.metre || options.motif) %&& isempty(note.occurrences)
    pat.occurrence(pattern.v,[],note); % should be r
    pattern.occ0.memorize(note,pattern.root);
end

if options.mode
    concept = mus.modal(mode,pitch,ioi,address,concept);
end

if length(memo) < chan+1
    memo{chan+1} = note;
else
    memo{chan+1} = [note,memo{chan+1}];
end

%channel.value = chan;
%note.parameter = note.parameter.setfield('channel',channel);


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

    group.key = 'Group';
    group.type = 'Boolean';
options.group = group;

    metre.key = 'Metre';
    metre.type = 'Boolean';
options.metre = metre;

    reduce.key = 'Reduce';
    reduce.type = 'Boolean';
options.reduce = reduce;

    motif.key = 'Motif';
    motif.type = 'Boolean';
options.motif = motif;

    contour.key = 'Contour';
    contour.type = 'Boolean';
options.contour = contour;


function p = initpattern(options)
ps = mus.paramstruct(options);
p.root = pat.pattern([],[],[],ps);
p.occ0 = p.root.occurrence([],[]);%,[]);

pat.pattern([],p.root,ps);
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
c.modes(end+1) = mus.mode('major',[0 2 4 5 7 9 11 12],1);

mhayyer = mus.mode('Mhayyer Sika',[-5 0 2 3 5 7 8 10 12],[]);
c.modes(end+1) = mhayyer;
c.modes(end+1) = mus.mode('Mhayyer Sika',[0 2 3 5 7],[1 5]);
c.modes(end).connect(mhayyer,2);
c.modes(end+1) = mus.mode('Mazmoun',[0 2 4 5 7],[1 5]);
c.modes(end).connect(mhayyer,4);
c.modes(end+1) = mus.mode('Busalik',[0 2 3 5 7],[1 5]);
c.modes(end).connect(mhayyer,5);
c.modes(end+1) = mus.mode('Kurdi',[0 1 3 5],[1 4]);
c.modes(end).connect(mhayyer,6);
c.modes(end+1) = mus.mode('Basse',[0 5],2);
c.modes(end).connect(mhayyer,1);
c.modes(end+1) = mus.mode('Rast Dhil',[0 2 3 6 7],[1 5]);
c.modes(end+1) = mus.mode('Isba''in',[0 1 4 5 7],[1 5]);

c.modes(end+1) = mus.mode('Bayati',[0 1.5 3 5],[1 4]);

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
    otherwise
        interdia = [];
        return
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


%%
function [scal degr] = integrate(scal,freq,reso)
if isempty(scal)
    scal.freq = freq;
    scal.degree = 0;
    degr = 0;
    return
end
[df best] = min(abs([scal.freq]-freq));
if df < reso
    best = best(1);
    degr = scal(best).degree;
    return
end
f = find(freq < [scal.freq],1);
if isempty(f)
    f = length(scal)+1;
end

df = Inf;
for i = 1:length(scal)
    rem = mod(scal(i).freq - freq,1200);
    rem = min(rem,1200-rem);
    if rem < df
        df = rem;
        best = i;
    end
end
if df < reso
    degr = scal(best).degree + round((freq - scal(best).freq)/1200)*12;
else
    ref = mean([scal.freq] - [scal.degree]*100);
    degr = round((freq - ref) / reso) * reso / 100;
end
newdegree.freq = freq;
newdegree.degree = degr;
scal = [scal(1:f-1) newdegree scal(f:end)];