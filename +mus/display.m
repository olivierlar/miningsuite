% MUS.DISPLAY
%
% Copyright (C) 2014-2015 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function display(seq,h,ind)

if nargin < 3
    notes = seq.content;
else
    notes = seq.content{ind};
end

if nargin < 2
    concept = [];
elseif nargin > 2
    concept = seq.concept{ind};
else
    concept = seq.concept;
end
if ~isempty(concept)
    mode = concept.modes;
end

nn = length(notes);
if ~nn
    warning('Warning in MUS.SCORE: The score is empty.')
    return
end

if nargin < 3 || isempty(h)
    figure
else
    axes(h);
end
hold on

range.chr = [];
range.let = [];
range.acc = [];
range.oct = [];

chr = NaN(1,nn);
f = zeros(1,nn);
t = zeros(2,nn);
%for i = 1:length(scal.list)
%    sdd{i} = [];
%    sdf{i} = [];
%end
for i = 1:nn
    chr(i) = notes{i}.parameter.getfield('chro').value;
    
    if ~ismember(chr(i),range.chr)
        range.chr(end+1) = chr(i);
        v = notes{i}.parameter.getfield('dia').value;
        if isempty(v) || ~isfield(v,'letter')
            range.let(end+1) = NaN;
            range.acc(end+1) = NaN;
            range.oct(end+1) = NaN;
        else
            range.let(end+1) = v.letter;
            if isempty(v.accident)
                range.acc(end+1) = NaN;
            else
                range.acc(end+1) = v.accident;
            end
            if isempty(v.octave)
                range.oct(end+1) = NaN;
            else
                range.oct(end+1) = v.octave;
            end
        end
    end
    %if isempty(p)
    %    continue
    %end
    %sd(i) = scal.find(p);
    freq = notes{i}.parameter.getfield('freq');
    if ~isempty(freq)
        f(i) = fr.value;
    end
    t(1,i) = notes{i}.parameter.getfield('onset').value;
    t(2,i) = notes{i}.parameter.getfield('offset').value;
    %sdd{sd(i)}(end+1) = diff(t(:,i));
    %sdf{sd(i)}(end+1) = f(i);
end

%sdm = zeros(1,length(sdd));
%for i = 1:length(sdd)
%    sdm(i) = sum(sdf{i}.*sdd{i})/sum(sdd{i});
%end

if 0 %~isempty(concept)
    ds = diff( [zeros(1,size(pitch.timescores,2)) ; pitch.timescores] );
    for i = 1:length(pitch.heights)
        tr = [find(ds(:,i)); nn];
        for j = 1:length(tr)-1
            plot(t(1,[tr(j),tr(j+1)]),[pitch.heights(i),pitch.heights(i)],...
                 'Color',ones(3,1)*(1-pitch.timescores(tr(j),i)))
        end
    end
end

for i = 1:nn
    for j = 1:length(notes{i}.to)
        if ~isempty(notes{i}.to(j).passing)
            lw = 2;
        else
            lw = .5;
        end
        t0 = notes{i}.to(j).from.parameter.getfield('onset').value;
        c0 = notes{i}.to(j).from.parameter.getfield('chro').value;
        plot([t0,t(1,i)],[c0,chr(i)],'Color',[1,.85,0],'LineWidth',lw);
    end
end

oldomod = [];
if 0 %~isempty(concept)
    for i = 1:2 %length(concept.dominantmodes)
        if length(concept.dominantmodes{i}) ~= 1
            continue
        end
        domod = concept.dominantmodes{i}{1}{1};
        scale = domod.scale;
        origin = concept.dominantmodes{i}{1}{2};
        t1 = t(1,i);
        if i == length(concept.dominantmodes)
            t2 = t(2,i);
        else
            t2 = t(1,i+1);
        end
        t2 = t(end);
        for j = 1:length(scale)
            plot([t1 t2],[origin+scale(j),origin+scale(j)],'c');
        end
        score = domod.timescore;
        for j = 1:size(score(i,:,:),2)
            k = find(domod.origins == origin,1);
            if score(i,j,k)
                sm = domod.submode(j);
                scale2 = origin + scale(sm.degree) + sm.mode.scale;
                for l = 1:length(scale2)
                    if ismember(l,sm.mode.pivot)
                        lw = 5;
                    else
                        lw = 2;
                    end
                    plot([t1 t2],[scale2(l),scale2(l)],'g','LineWidth',lw);
                end
            end
        end
        if ~isequal(domod,oldomod)
            text(t1,origin+.4,domod.name,'Color',[0 .5 .5]);
            oldomod = domod;
        end
    end
    
    for i = 1:0 %length(mode)
        s = mode(i).eventscores;
        o = find(max(s,[],1));
        for j = 1:length(o)
            oj = mode(i).origins(o(j));
            tj = find(s(:,o(j)));
            if isempty(tj)
                continue
            end
            sdj = oj;% mode(i).scale + oj;
            for k = 1:length(sdj)
                plot([t(1,tj(1)) t(2,tj(end))],[sdj(k) sdj(k)],...
                     'Color',num2col(i));
                %plot(t(1,tj),repmat(sdj(k),[1 length(tj)]),...
                %     '*','Color',num2col(i));
            end
            pos = max(sdj)+1/2;
            col = .5+num2col(i)/2;
            %for k = 1:length(tj)
            %    tk = tj(k);
            %    sk = s(tk,o(j));
            %    while sk > .25 && tk < nn
            %        tw = find(s(tk:end,o(j)) < sk,1);
            %        if isempty(tw)
            %            tend = nn;
            %        else
            %            tend = tk + tw - 1;
            %        end
            %        plot(t(1,[tk tend]),[pos pos],'Color',col,'LineWidth',sk*2);
            %        tk = tend;
            %        sk = s(tk,o(j));
            %    end
            %end
            text(t(1,tj(1)),pos,mode(i).name,'Color','k','BackgroundColor',col);
            %f = find(mode(i).ispivot(:,o(j)));
            %for k = 1:length(f)
            %    fill(t([1 2 2 1],f(k)),sd(f(k)) + [-.2 -.2 .2 .2 ],col);
            %end
        end
    end
end

for i = 1:nn
    if ~isempty(notes{i}.passing)
        col = [.5 .5 .5];
    else
        col = 'k';
    end
    plot(t(:,i)',[chr(i),chr(i)],'Color',col,'LineWidth',1.5);
    plot(t(1,i),chr(i),'dk',...
         'MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',7);
    %text(t(1,i),chr(i),num2str(i),'Color',[.5,.5,.5],...
    %     'FontSize',10,'VerticalAlignment','Bottom');

    k = 1;
    for j = 1:length(notes{i}.isprefix)
        t1 = notes{i}.parameter.getfield('onset').value;
        sf = notes{i}.isprefix(j);
        pmi = notes{i}.parameter.getfield('chro').value;
        pma = pmi;
        while 1
            [pmi,pma,sf] = pitchrange(sf,pmi,pma,isempty(sf.property));
            t2 = sf.parameter.getfield('offset').value;
            if isempty(sf.property)
                ls = '-';
                ec = 'r';
                lw = 1;
                dx = 0;
                dy = .2;
                t2e = t2;
            else
                ls = '-';%':';
                ec = 'b';
                lw = tanh(sf.property)*2;
                dx = .01 * k;
                dy = sf.property; %k*.2; %
                t2e = t2 + sf.property;
            end
            if t2e > t1
                rectangle('Position',[t1-dx,pmi-dy,t2e-t1+2*dx,pma-pmi+2*dy],...
                          'EdgeColor',ec,'LineWidth',lw,'LineStyle',ls);
                if ~isempty(sf.property)
                    pk = sf.parameter.getfield('chro').value;
                    plot([t2,t2e-dx],[pk,pk],'r','LineWidth',5);
                    %rectangle('Position',[t2-.02,pk-.2,.04,.4],...
                    %        'EdgeColor','r','LineWidth',2,'Curvature',1);
                end
            end
            if isempty(sf.isprefix)
                break
            else
                sf = sf.isprefix(1);
                k = k+1;
            end
        end
    end
    %harm = notes{i}.parameter.getfield('harmony').value;
    %if ~isempty(harm) && ~strcmp(harm,'-')
    %    text(t(1,i),chr(i),harm,'Color','r','FontSize',20,...
    %         'HorizontalAlignment','center','VerticalAlignment','bottom');
    %end
end

if 0 % nargin>1 && ~isequal(scal,0)
    degrs = [scal.degree];
    set(gca,'YTick',sort(degrs));
end

for i = 1:0 %nn
    mi = notes{i}.parameter.getfield('metre');
    if ~isempty(mi.value) && ~mi.value.inbar
        line([t(1,i) t(1,i)],[min(chr)-.5 max(chr)],'LineStyle',':');
        text(t(1,i),min(chr)-.5,num2str(mi.value.bar));
    end
end

[range.chr order] = sort(range.chr);
set(gca,'YTick',range.chr,'YGrid','on');

if ~isempty(range.oct)
    range.let = mod(range.let(order),7);
    range.acc = range.acc(order);
    range.oct = range.oct(order);
    labels = cell(1,length(range.chr));
    for i = 1:length(range.chr)
        if isnan(range.let(i))
            continue
        end
        if range.let(i) < 5
            labels{i} = char(67 + range.let(i));
        else
            labels{i} = char(60 + range.let(i));
        end
        if range.acc(i) == 1
            labels{i}(end+1) = '#';
        elseif range.acc(i) == -1
            labels{i}(end+1) = 'b';
        end
        if ~isnan(range.oct(i))
            octstr = num2str(range.oct(i));
            labels{i}(end+1:end+length(octstr)) = octstr;
        end
        %    line([t(1) t(end)],[range.chr(i) range.chr(i)],'LineStyle',':');
    end
    found = 0;
    for i = 1:length(labels)
        if ~isempty(labels{i})
            found = 1;
            break
        end
    end
    if found
        set(gca,'YTickLabel',labels);
    end
end

%%
option.scheaf = 1;
option.minlength = 3;

pool = {};
t2s = [];
y = range.chr(1)-1;
for i = 1:nn
    for j = 1:length(notes{i}.occurrences)
        if isempty(notes{i}.occurrences(j).extensions) && ...
                notes{i}.occurrences(j).pattern.length > option.minlength...
                && isempty(notes{i}.occurrences(j).cycle)
            
            f = 0;
            patt = notes{i}.occurrences(j).pattern;
            for k = 1:length(pool)
                if ismember(patt,pool{k}.pat)
                    f = k;
                    break
                end
            end
            
            if ~f
                if option.scheaf
                    s = scheaf(patt,option.minlength);
                else
                    s.branches = patt;
                end
                if s.length > option.minlength
                    coord = zeros(0,2);
                    pool{end+1}.pat = s.branches;
                    pool{end}.start = [];
                    f = length(pool);
                    fprintf(['== ',num2str(f),'\n']);
                    if f > 1
                        y = y - .5;
                        line([0 10],[y y],'Color','k','LineWidth',2);
                        y = y - .5;
                    end
                    text(0,y+.3,num2str(f),'Color','k','VerticalAlignment','Top');
                
                    for h = 1:length(s.closedbranches)
                        p = s.closedbranches(h);
                        if p.length < 4
                            continue
                        end
                        y = y-.4;
                        desc = p.display; %(0);
                        %fprintf([desc,'\n']);
                        
                        occs = p.occurrences;
                        for k = 1:length(p.specific)
                            for k2 = 1:length(p.specific(k).occurrences)
                                found = 0;
                                for k3 = 1:length(occs)
                                    if isequal(occs(k3).suffix,...
                                           p.specific(k).occurrences(k2))
                                       found = 1;
                                    end
                                end
                                if ~found
                                    if isempty(occs)
                                        occs = p.specific(k)...
                                                        .occurrences(k2);
                                    else
                                        occs(end+1) = p.specific(k)...
                                                        .occurrences(k2);
                                    end
                                end
                            end
                        end
                        
                        for k = 1:length(occs)
                            %chan = p.occurrences(k).suffix.parameter...
                            %                .getfield('channel').value;
                            %if isempty(chan)
                                chan = 0;
                            %end
                            %switch chan
                            %    case 0
                            %        v = 'S ';
                            %        col = 'r';
                            %    case 1
                            %        v = 'A ';
                            %        col = 'b';
                            %    otherwise
                            %        v = 'ERROR ';
                            %end
                            %fprintf(v);
                            
                            %y = range.chr(1)-1-f-chan*.2;

                            %pl = p.occurrences(k).list;
                            %for l = 1:length(pl)
                            %    ml = pl(l).suffix.parameter.getfield('metre').value;
                            %    if isempty(ml)
                            %        continue
                            %    end
                            %    fprintf(num2str(ml.bar + ml.inbar/6));
                            %    if l < length(pl)
                            %        fprintf(',');
                            %    end
                            %end
                            %fprintf('\n');

                            N2 = occs(k).suffix.to.address;
                            nk = N2;
                            
                            if isempty(N2)
                                continue
                            end
                            
                            o = occs(k).suffix.parameter.getfield('onset');
                            t2 = o.value;
                            occk = occs(k);
                            patk = p;
                            while ~isempty(patk.parent) && ...
                                    ~isempty(patk.parent.parent)
                                nk = [occk.suffix.to.address nk];
                                occk = occk.prefix;
                                patk = patk.parent;
                            end
                            N1 = occk.suffix;
                            if isa(N1,'pat.syntagm')
                                N1 = N1.to;
                            end
                            N1 = N1.address;
                            if isempty(pool{end}.start)
                                pool{end}.start = N1;
                            end
                            
                            if isempty(N1)
                                continue
                            end
                            
                            found = 0;
                            for l = 1:size(coord,1)
                                if N1 < coord(l,2) && N2 > coord(l,1)
                                    found = 1;
                                    N1 = min(N1,coord(l,1));
                                    N2 = max(N2,coord(l,2));
                                    break
                                end
                            end
                            if ~found
                                coord(end+1,:) = [N1,N2];
                            end
                            
                            o = occk.suffix.parameter.getfield('onset');
                            t1 = o.value;
                            
                            if t1 > t2
                                warning('Occurrence error');
                                break
                            end

                            col = 'r';
                            if occs(k) == p.revelation
                                lw = 2;
                            else
                                lw = .5;
                            end
                            if 1 %isempty(p.occurrences(k).cycle)
                                line([t1 t2],[y y],'Marker','+','Color',col,...
                                     'LineWidth',lw,'MarkerSize',6);
                                %line([t2 t2],[min(chr) max(chr)],'LineStyle',':');
                            elseif isempty(p.occurrences(k).cycle(1).parent.parent)
                                line([t1 t2],[y y],'LineStyle','--','Marker','+',...
                                     'Color',col);
                                %line([t2 t2],[min(chr) max(chr)],'LineStyle',':');
                            else
                                line([t1 t2],[y y],'LineStyle','--','Color',col);
                            end
                            if length(t2s) >= f
                                %line([t2s(f) t1],[y y],'LineStyle',':','Color',col);
                            end
                            if 0 %k == 1
                                text(t1,y,desc,'Color','k','VerticalAlignment','Bottom');
                            end
                            t2s(f) = t2;
                            %N1 = max(1,N1-10);
                            %N2 = min(length(notes),N2+10);
                            %drawnow
                            %seq.play(N1,N2)
                            %pause
                        end
                    end
                    
                    if 0
                        cf = gcf;

                        content2 = {};
                        onm.value = -2;
                        for l = 1:size(coord,1)
                            ol = notes{coord(l,1)}.parameter...
                                            .getfield('onset').value...
                                  - onm.value - 5;
                            for m = coord(l,1):coord(l,2);
                                content2{end+1} = pat.event([],notes{m}.parameter);
                                onm = content2{end}.parameter.getfield('onset');
                                onm.value = onm.value - ol;
                                content2{end}.parameter = ...
                                    content2{end}.parameter.setfield('onset',onm);
                                offm = content2{end}.parameter.getfield('offset');
                                offm.value = offm.value - ol;
                                content2{end}.parameter = ...
                                    content2{end}.parameter.setfield('offset',offm);                                
                            end
                        end

                        seq2.content = content2;
                        seq2.concept = [];
                        mus.score(seq2);

                        figure(cf)
                    end
                end
            end
        end
    end
end

%axis tight
%grid on


function col = num2col(k)
switch k
    case 1 
        col = [0 0 1];
    case 2 
        col = [1 0 0];
    case 3 
        col = [0 1 0];
    case 4
        col = [1 0 1];
    case 5 
        col = [1 1 0];
    case 6 
        col = [0 1 1];
    case 7
        col = [1 0 .5];
    case 8
        col = [.5 1 0];
    case 9
        col = [0 .5 1];
    case 10
        col = [1 .5 0];
    case 11
        col = [.5 0 1];
    case 12
        col = [0 1 .5];
    otherwise
        col = [rand rand rand];
end   


function s = scheaf(p,minl)

s.branches = p;
if p.closed
    s.closedbranches = p;
else
    s.closedbranches = [];
end
s.general = p;
s.length = p.length;
s = recurs(s,p,minl);

function s = recurs(s,p,minl)
l = length(p.list);
if l < minl
    return
end
for g = p.isogeneral
    s.branches(end+1) = g;
    if g.closed && isempty(g.abstract)
        if isempty(s.closedbranches)
            s.closedbranches = g;
        else
            s.closedbranches(end+1) = g;
        end
    end
    if ismember(g,s.general(end).general)
        s.general(end) = g;
    end
end
s = recurschild(s,s.general(end));
for g = s.general(end).isospecific
    if ~ismember(g,s.branches)
        s.branches(end+1) = g;
        if g.closed && isempty(g.abstract)
            if isempty(s.closedbranches)
                s.closedbranches = g;
            else
                s.closedbranches(end+1) = g;
            end
        end
    end
    s = recurschild(s,g);
end
if ~isempty(p.parent)
    s.general(end+1) = s.general(end).parent;
    s = recurs(s,p.parent,minl);
end

function s = recurschild(s,p)
if ~ismember(p,s.branches)
    s.branches(end+1) = p;
    if p.closed && isempty(p.abstract)
        if isempty(s.closedbranches)
            s.closedbranches = p;
        else
            s.closedbranches(end+1) = p;
        end
    end
    if p.length > s.length
        s.length = p.length;
    end
    for g = p.isogeneral
        if ~ismember(g,s.branches)
            s.branches(end+1) = g;
            if g.closed && isempty(g.abstract)
                if isempty(s.closedbranches)
                    s.closedbranches = g;
                else
                    s.closedbranches(end+1) = g;
                end
            end
        end
    end
end
for c = 1:length(p.children)
    if ~ismember(p.children{c},s.branches)
        s = recurschild(s,p.children{c});
    end
end


function [pmi,pma,sf] = pitchrange(sf,pmi,pma,meta,sub) % meta unused currently, because always equal to 1 (bug)
if nargin < 5
    sub = 0;
end
IncludeAllNotesInDisplay = 1;
if IncludeAllNotesInDisplay && ~isempty(sf.suffix.suffix)
    [pmi,pma] = pitchrange(sf.suffix,pmi,pma,meta,1);
end
pk = sf.suffix.parameter.getfield('chro').value;
if ~isempty(pk)
    if pk < pmi
        pmi = pk;
    end
    if pk > pma
        pma = pk;
    end
end
if sub
    if ~isempty(sf.extends)
        [pmi,pma] = pitchrange(sf.extends,pmi,pma,meta,sub);
    end
elseif ~isempty(sf.extension)% && ...
        %(meta || sf.property == sf.extension(1).property)
    sf = sf.extension(1);
    [pmi,pma,sf] = pitchrange(sf,pmi,pma,meta);
end