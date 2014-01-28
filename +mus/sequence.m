function [out scal concept] = sequence(in,reso)

if nargin < 2
    reso = 50;
end

concept = cult.init; %initconcepts(option);
memory = [];
scal = [];

if isnumeric(in)
    nmat = in;
    ps = mus.paramstruct('chro','rhythm');
    chans = unique(nmat(:,3));
    nchans = length(chans);
    out = cell(1,nchans);
    for i = 1:nchans
        out{i} = seq.sequence;
        chan = nmat(nmat(:,3)==chans(i),:);
        note = [];
        for j = 1:size(chan,1)
            param = mus.param(ps,chan(j,4),[],[],chan(j,1),chan(j,2));
            note = seq.event(out{i},param,note);
        end
    end

elseif isa(in,'mirpitch')
    ps = mus.paramstruct('freq','dia','rhythm');
    
    d = get(in,'Mean');
    st = get(in,'Start');
    en = get(in,'End');
    stb = get(in,'Stable');
    fp = get(in,'FramePos');
    
    out = cell(1,length(d));
    for i = 1:length(d)
        out{i} = seq.sequence;
        note = [];
        for j = 1:length(d{i}{1}{1})
            param = ps;
            
            freq = d{i}{1}{1}(j);
            param.fields{1}.fields = ...
                                seq.paramval(ps.fields{1}.fields(1),freq);
            
            [scal degr] = integrate(scal,freq,reso);
            
            param.fields{1}.fields(2) = ...
                                seq.paramval(ps.fields{1}.fields(2),degr);
                        
            t = [fp{i}{1}(1,st{i}{1}{1}(j)),fp{i}{1}(2,en{i}{1}{1}(j))];
            param.fields{2} = seq.paramval(ps.fields{2},t);
                        
            note = seq.event(out{i},param,note);
            if j > 1
                previous = note.previous;
                while ~isempty(previous)
                    syntagm = seq.syntagm(previous,note);
                    [concept memory] = analyze_interval(concept,memory,...
                                                        syntagm,scal);
                    previous = previous.issuffix;
                end
            end
            [concept,memory] = analyze_note(concept,note,memory);
        end
    end
end


%%
function [concept,memory] = analyze_note(concept,note,memory)
address = note.address;
current = note.parameter;
pitch = current.fields{1}.fields(end).value;
best = 0;
for j = 1:length(concept.modes)
    for k = 1:length(concept.modes(j).origins)
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
                if is2
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
                end
            end
        end
    end
end

for j = 1:length(concept.modes)
    if ~isempty(concept.modes(j).currentscores)
        concept.modes(j).eventscores(address,...
                      1:length(concept.modes(j).currentscores)) = ...
            concept.modes(j).currentscores;
        concept.modes(j).degreescores(address,...
                      1:size(concept.modes(j).currentdegreescores,2),...
                      1:size(concept.modes(j).currentdegreescores,3)) ...
            = concept.modes(j).currentdegreescores;
    end
end

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
        meta.parameter.fields{2}.value(2) = ...
            note.parameter.fields{2}.value(2);
        %memory(f) = [];
        %[concept,memory] = analyze_note(concept,meta,memory);
    end
end


%%
function [concept memory] = analyze_interval(concept,memory,syntagm,scal)

pitch = syntagm.from.parameter.fields{1}.fields(end).value;
ioi = syntagm.parameter.fields{2}.inter.value(1);
o2 = syntagm.to.parameter.fields{2}.value(1);
address = syntagm.from.address;

f = find([memory.pitch] == pitch,1);
if isempty(f)
    return
end
memory(f).ioi = ioi;
j = 0;
while j < length(memory)
    j = j+1;
    if ioi * .8 > memory(j).ioi || ...
            o2 - memory(j).event.parameter.fields{2}.value(2) > 1
        memory(j) = [];
    end
end

if ioi < .5 %%|| pitch < 80 || pitch > 100
    return
end
for j = 1:length(concept.modes)
    if find(concept.modes(j).currentscores)
       %size(concept.modes(j).eventscores,1) >= previous.address && ...
       %     find(concept.modes(j).eventscores(previous.address,:))
        return
    end
end
scal = [scal.degree] - pitch;
best = 0;
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
                    zeros(size(concept.modes(j).currentscores));
            end
            if isempty(f)
                no = length(concept.modes(j).origins) + 1;
                concept.modes(j).origins(no) = origin;
                concept.modes(j).currentscores(no) = scok;
                concept.modes(j).ispivot(address,no) = 1;
                concept.modes(j).eventscores(address,no) = scok;
                concept.modes(j).currentdegreescores(1,:,no) = ...
                    ismember(modscalk,scal);
            else
                concept.modes(j).currentscores(f) = scok;
                concept.modes(j).ispivot(address,f) = 1;
                if size(concept.modes(j).eventscores,1) < address-1 || ...
                        ~concept.modes(j).eventscores(address-1,f)
                    concept.modes(j).eventscores(address,f) = scok;
                end
            end
            best = scok;
        end
    end
end


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


function [scal degr] = octavintegrate(scal,freq,reso)
modfreq = mod(freq,1200);
if isempty(scal)
    scal.freq = modfreq;
    scal.degree = 0;
    degr = round((freq - modfreq)/1200)*12;
    return
end
df = Inf;
for i = 1:length(scal)
    mi = min(modfreq,scal(i).freq);
    ma = max(modfreq,scal(i).freq);
    mima = min(ma-mi,mi-ma+1200);
    if mima < df
        df = mima;
        best = i;
    end
end
if df < reso
    best = best(1);
    degr = scal(best).degree + round((freq - scal(best).freq)/1200)*12;
    return
end
f = find(modfreq < [scal.freq],1);
if isempty(f)
    f = length(scal)+1;
end
ref = mean([scal.freq] - [scal.degree]*100);
degr = mod(round((modfreq - ref) / reso) * reso / 100, 12);
newdegree.freq = modfreq;
newdegree.degree = degr;
scal = [scal(1:f-1) newdegree scal(f:end)];
degr = floor((freq - scal(1).freq) / 1200) * 12 + degr;
%degr = degr + round((freq - modfreq)/1200)*12;