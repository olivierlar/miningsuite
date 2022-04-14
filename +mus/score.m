% MUS.SCORE
%
% Copyright (C) 2014-2015, 2017-2019 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = score(arg,varargin)

options = seq.options(mus.score.initoptions,varargin);

if options.mode
    concept = initmode;
else
    concept = [];
end

if ischar(arg) || iscell(arg)
    out = reads(arg,options,concept);
    return
elseif isnumeric(arg)
    notes = struct('chro',num2cell(arg),'ons',num2cell(arg),...
                   'dur',.1,'chan',num2cell(arg));
    out = process_notes(notes,mus.Sequence,'',options,concept,0,[]);
    return
end

if isa(arg,'mus.Sequence')
    out = arg;
else
    out = mus.Sequence;
end

if isa(arg,'sig.design')
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
                pattern = initpattern(options);
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
            pattern = initpattern(options);
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
    pattern = [];
    for i = 1:length(dn)
        [out, pattern] = read(out,dn{i},options,concept,1,pattern);
    end
elseif iscell(arg)
    pattern = [];
    for i = 1:length(arg)
        [out, pattern] = read(out,arg{i},options,concept,1,pattern);
    end
else
    out = read(out,arg,options,concept,0,[]);
end


function [out, pattern] = read(out,name,options,concept,folder,pattern)
try
    audioinfo(name);
    
    type = 'audio';
catch
    type = 'symbolic';
end

if strcmp(type,'audio')
    
    % Audio input
    
%     if options.t1 || options.t2
%         if isempty(options.t1)
%             options.t1 = 0;
%         end
%         if isempty(options.t2)
%             options.t2 = Inf;
%         end
%         a = miraudio('Design','Extract',options.t1,options.t2);
%     else
%         a = miraudio('Design');
%     end
    if 0
        p = mirpitch(a,'Frame','Enhanced',0,'Segment',...
                       'SegPitchGap',45,'SegMinLength',2,'NoFilterBank');
        p = mireval(p,name);
        p = p{1};
    else
        t = aud.events(name,'Attacks','Mix');
        t = t.eval;
        t = t{1};
        s = sig.segment(name,t);
        
        p = aud.pitch(s,'Total',1);
        p = p.getdata;
        pp = zeros(1,length(p));
        for i = 1:length(p)
            pp(i) = p{i}{1};
        end
    end
    out = transcribe(out,{t,pp},options,concept);
else
    % Symbolic input
    fid = fopen(name);
    if fid<0
        if ~folder
            error('Unable to load the file');
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
        [out, pattern] = process_notes(notes,out,name,options,concept,folder,pattern);
    elseif 1
        fid = fopen(name,'rt');
        if 0 % mathieu
            C = textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %s \n');
            notes = struct('chro',num2cell(C{1}),'ons',num2cell(C{8}),...
                           'dur',num2cell(C{9}),'chan',num2cell(C{11}),...
                           'harm',C{12});
        elseif 0 % fran?ois
            C = textscan(fid,'%f,%f,%f\n');
            notes = struct('chro',num2cell(C{1}),...
                           'ons',num2cell(C{2}),...
                           'dur',num2cell(C{3}));
            while ~feof(fid)
                C = textscan(fid,'%f,%f,%f\n');
                if ~isempty(C{1})
                    notes(end+1) = struct('chro',num2cell(C{1}),...
                                          'ons',num2cell(C{2}),...
                                          'dur',num2cell(C{3}));
                end
            end
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
        [out, pattern] = process_notes(notes,out,name,options,concept,folder,pattern);
    end
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

        
function [out, pattern] = process_notes(notes,out,name,options,concept,folder,pattern)
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
% for i = 1:length(notes)-1
%     notes(i).dur = notes(i+1).ons - notes(i).ons;
% end
note = [];
if folder
    out.content{end+1} = [];
    out.files{end+1} = name;
else
    out.files = name;
end
ps = mus.paramstruct(options);
if isempty(pattern) && (options.metre || options.motif || options.passing)
    pattern = initpattern(ps,options);
end
if options.mode
    mode = mus.scale([]);
else
    mode = [];
end
memo = [];
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

%process(concept,[],memo,options,pattern,mode,ioi);
if folder
    out.concept{end+1} = concept;
else
    out.concept = concept;
end


function out = transcribe(out,in,options,concept)
ps = mus.paramstruct(options);
if iscell(in)
    t = sort(in{1}.sdata(in{1}.attacks.content{1}));
    p = in{2};
    memory = [];
    note = [];
    for i = 1:length(t)
        param = mus.param(ps,p(i),NaN,NaN,t(i),t(i)+.01);
        note = pat.event(out,param,note);
        note.address = i;
        out = out.integrate(note);
        if ~isempty(options)
            [out.concept,note,memory] = process(out.concept,note,memory,options);
        end
    end
elseif isa(in,'sig.Envelope')
    t = sort(in.sdata(in.attacks.content{1}));
    memory = [];
    note = [];
    for i = 1:length(t)
        param = mus.param(ps,0,NaN,NaN,t(i),t(i)+.01);
        note = pat.event(out,param,note);
        note.address = i;
        out = out.integrate(note);
        if ~isempty(options)
            [out.concept,note,memory] = process(out.concept,note,memory,options);
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
if nargin < 5
   pattern = [];
end
if nargin < 6
    mode = [];
end
if nargin < 7
    ioi = [];
end
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
    note.parameter = note.parameter.setfield('dia',...
                    seq.paramval(note.parameter.getfield('dia').type,dia));
elseif options.spell
    dia = pitch2dia(pitch);
    note.parameter = note.parameter.setfield('dia',...
                    seq.paramval(note.parameter.getfield('dia').type,dia));
end

if options.metre
    pos = round(note.parameter.getfield('onset').value/    (3/14)    ) %.15152)
    metre = note.parameter.getfield('metre');
    barpos = pos/8+1;
    metre.value.bar = round(barpos);
    metre.value.inbar = round(rem(barpos,1)*8);
    note.parameter = note.parameter.setfield('metre',metre);
end

note.parameter

if length(memo) < chan+1 
    memo{chan+1} = [];
end

k = 1;
while k <= length(memo{chan+1})
    prev = memo{chan+1}(k);
    del = 0;
    if ~isempty(pattern)
        [sk del] = prev.syntagm(note,pattern.root,1,options);
        if del == 1 || (del == 2 && k > 1)
            memo{chan+1}(k) = [];
            break
        end
    else
        sk = seq.syntagm(prev,note);
    end
    
    if k == 1
        prev1 = prev;
        sk1 = sk;
    else
        k = k+1;
        continue
    end
            
    if ~isnan(options.metricanchor) && ...
            mod(sk.parameter.getfield('onset').value,...
                options.metricanchor) == 1
            1
    end

    p1 = sk.from.parameter.getfield('chro').value;
     
    if options.passing 
        if abs(pitch - p1) < 3
            t = note.parameter.getfield('onset').value;
            t1 = sk.from.parameter.getfield('onset').value;
            for j = 1:length(sk.from.to)
                p2 = sk.from.to(j).from.parameter.getfield('chro').value;
                t2 = sk.from.to(j).from.parameter.getfield('onset').value;
                if sign(p2 - p1) == sign(p1 - pitch) && ...
                        abs(p1 - p2) < 3 && ...
                        abs(log( (t-t1) / (t1-t2) )) < .1
                    if isempty(sk.from.to(j).passing)
                        sk.from.to(j).passing = sk.from.to(j).from;
                    end
                    sk.passing = sk.from.to(j).passing;
                    sk.from.passing = [sk.from.to(j) sk];
                    sk.passing.syntagm(note,pattern.root,1,options);
                end
            end
        end
    end
    if options.retention
        k = k+1;
    else
        break
    end
end

if (options.group || options.broderie) && ~isempty(memo{chan+1})
    ioi1 = sk1.parameter.getfield('onset').inter.value;
        % New inter-onset interval
    [memo{chan+1},mode] = mus.group(prev1,ioi1,ioi,options,...
                            note,pitch,memo{chan+1},chan,mode,pattern);
end

if (options.metre || options.motif) %&& isempty(note.occurrences)
    pat.occurrence(pattern.v,[],note); % should be r
    pattern.occ0.memorize(note,pattern.root,options,[],1);
end

if 0 %options.mode
    concept = mus.modal(mode,pitch,ioi,address,concept);
end

if length(memo) < chan+1
    memo{chan+1} = note;
else
    memo{chan+1} = [note,memo{chan+1}];
end

%channel.value = chan;
%note.parameter = note.parameter.setfield('channel',channel);


function p = initpattern(ps,options)
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

if 0
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
end

c.timescores = cell(1,length(c.modes));
c.degreescores = cell(1,length(c.modes));
c.note = mus.Pitch;


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