function pianoroll(notes,concept,h)

if nargin < 2
    concept = [];
end
if ~isempty(concept)
    mode = concept.modes;
end

if nargin < 3
    figure
else
    axes(h);
end
hold on

nn = length(notes);

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
        if ~isempty(v)
            range.let(end+1) = v.letter;
            range.acc(end+1) = v.accident;
            if ~isempty(v.octave)
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
    %df = f(i) - sdm(sd(i));
    %fill(t([1 2 2 1],i),sd(i) + [-.2 -.2 .2 .2 ],col);
    
    lw = 1; %min(1 + pitch.pivoteventscores(notes{i}.address),2);
    if isempty(notes{i}.extends)
        delta = .2;
    else
        delta = .4;
    end
    rectangle('Position',[t(1,i),chr(i)-delta,t(2,i)-t(1,i),2*delta],...
              'EdgeColor','b','LineWidth',lw);
    
    if 0 %~isempty(notes{i}.isprefix)
        list = notes{i}.extent;
        t1 = list(1).parameter.fields{2}.value(1);
        t2 = list(end).parameter.fields{2}.value(2);
        pmi = Inf;
        pma = -Inf;
        for j = 1:length(list)
            pj = list(j).parameter.fields{1}.fields(2).value;
            if isempty(pj)
                continue
            end
            %pj = scal.find(pj);
            if pj < pmi
                pmi = pj;
            end
            if pj > pma
                pma = pj;
            end
        end
        lw = 1 + pitch.pivoteventscores(notes{i}.address);
        rectangle('Position',[t1,pmi - .5,t2-t1,pma-pmi + 1],...
                  'EdgeColor','b','LineWidth',lw,'LineStyle','--');
        %line([t1 t2],p+[.45 .45],'Color','b','LineWidth',1);
    end    
end

if 0 % nargin>1 && ~isequal(scal,0)
    degrs = [scal.degree];
    set(gca,'YTick',sort(degrs));
end

if ~isempty(concept)
    for i = 1:length(mode)
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
    mi = notes{i}.parameter.getfield('metre');
    if ~isempty(mi.value)
        line([t(1,i) t(1,i)],[min(chr)-.5 max(chr)],'LineStyle',':');
        text(t(1,i),min(chr)-.5,num2str(mi.value));
    end
end

[range.chr order] = sort(range.chr);
set(gca,'YTick',range.chr,'YGrid','on');

if ~isempty(range.oct)
    range.let = range.let(order);
    range.acc = range.acc(order);
    range.oct = range.oct(order);
    labels = cell(1,length(range.chr));
    for i = 1:length(range.chr)
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
        labels{i}(end+1) = num2str(range.oct(i));
        %    line([t(1) t(end)],[range.chr(i) range.chr(i)],'LineStyle',':');
    end
    set(gca,'YTickLabel',labels);
end


pool = {};
t2s = [];
for i = 1:0 %nn
    for j = 1:length(notes{i}.occurrences)
        if 1 %isempty(notes{i}.occurrences(j).extensions)
            o = notes{i}.occurrences(j).suffix.parameter.getfield('onset');
            t2 = o.value;
            point = notes{i}.occurrences(j);
            l = 0;
            while ~isempty(point.prefix)
                point = point.prefix;
                l = l+1;
            end
            if ~l
                continue
            end
            o = point.suffix.parameter.getfield('onset');
            t1 = o.value;
            f = 0;
            if ~isempty(notes{i}.occurrences(j).cycle)
                patt = notes{i}.occurrences(j).cycle(end);
            else
                patt = notes{i}.occurrences(j).pattern;
            end
            for k = 1:length(pool)
                if isequal(patt,pool{k})
                    f = k;
                    break
                end
            end
            if ~f
                pool{end+1} = patt;
                f = length(pool);
            end
            y = 60-f;
            if isempty(notes{i}.occurrences(j).cycle)
                %line([t1 t2],[y y],'Marker','+');
                line([t2 t2],[min(chr) max(chr)],'LineStyle',':');
            elseif isempty(notes{i}.occurrences(j).cycle(1).parent.parent)
                %line([t1 t2],[y y],'LineStyle','--','Marker','+');
                line([t2 t2],[min(chr) max(chr)],'LineStyle',':');
            else
                %line([t1 t2],[y y],'LineStyle','--');
            end
            if length(t2s) >= f
                %line([t2s(f) t1],[y y],'LineStyle',':');
            end
            t2s(f) = t2;
            f
            notes{i}.occurrences(j)
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