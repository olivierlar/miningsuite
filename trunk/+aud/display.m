function score(seq,h,ind)

if nargin < 3
    events = seq.content;
else
    events = seq.content{ind};
end

ne = length(events);
if ~ne
    warning('Warning in AUD.SCORE: The score is empty.')
    return
end

if nargin < 3 || isempty(h)
    figure
else
    axes(h);
end
hold on

chr = NaN(1,ne);
t = zeros(2,ne);

for i = 1:ne
    t(1,i) = events{i}.parameter.getfield('onset').value;
    t(2,i) = events{i}.parameter.getfield('offset').value;
    if ~isempty(events{i}.passing)
        col = [.5 .5 .5];
    else
        col = 'k';
    end
    plot(t(:,i)',[0,0],'Color',col,'LineWidth',1.5);
    plot(t(1,i),0,'dk',...
         'MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',7);

    k = 1;
    for j = 1:length(events{i}.isprefix)
        t1 = events{i}.parameter.getfield('onset').value;
        sf = events{i}.isprefix(j);
        pma = pmi;
        while 1
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
                rectangle('Position',[t1-dx,-dy,t2e-t1+2*dx,2*dy],...
                          'EdgeColor',ec,'LineWidth',lw,'LineStyle',ls);
                if ~isempty(sf.property)
                    rectangle('Position',[t2-.02,-.2,.04,.4],...
                            'EdgeColor','r','LineWidth',2,'Curvature',1);
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
end