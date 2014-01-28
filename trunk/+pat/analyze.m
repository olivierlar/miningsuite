function symb = analyze(arg,metre,nbnotes)

if nargin < 2
    metre = 0;
end
if nargin < 3
    nbnotes = Inf;
end

param = seq.paramstruct;
param.fields{1} = seq.paramtype('time');
param.fields{1}.inter = seq.paraminter(@diff);
param.fields{2} = seq.paramtype('rhythm');
param.fields{3} = seq.paramtype('pitch');
param.fields{4} = seq.paramtype('real');

root = pat.pattern([],[],param);
occ0 = root.occurrence([],[]);

pat.pattern(root,param);
v = root.children{1};
v.general = root;
root.specific = v;

pp = param;
pp.fields{1} = param.fields{1}; %seq.paramval(param.fields{1},[]);
pp.fields{2} = param.fields{2};
pp.fields{3} = param.fields{3};
pp.fields{4} = seq.paramval(param.fields{4},1);
pat.pattern(root,pp,param);
r = root.children{1};
r.general = v;
v.specific = r;

if 0 %length(arg)>4 && strcmpi(arg(end-3:end),'.txt')
    fid = fopen(arg);
    s = textscan(fid,'%c');
    s = s{1};
    s(s<'A'|s>'z') = '';
else
    s = arg;
end

p = param;
for i = 1:size(s,2)
    p(i).fields{1} = seq.paramval(pp.fields{1},s(1,i));
    p(i).fields{2} = seq.paramval(pp.fields{2},[]);
    p(i).fields{3} = seq.paramval(pp.fields{3},s(2,i));
    p(i).fields{4} = seq.paramval(pp.fields{4},1);
end
           
disp(' ');
disp(['> Symbol #1: ',display(p(1),1)]);

new = pat.event([],p(1));
pat.occurrence(r,[],new);
%root.memory.learn(new.parameter,[],new,root,[]);
occ0.memorize(new);

symb = new;
for i = 2:min(length(p),nbnotes)
    disp(' ');
    display(['> Symbol #' num2str(i),': ',display(p(i),1)]);
    
    old = new;
    new = pat.event([],p(i));
    symb(i) = new;
    pat.syntagm(old,new);

    real = 0;
    for j = 1:length(new.occurrences)
        if ~isa(new.occurrences(j).parameter.fields{4},'seq.paramtype') && ...
                new.occurrences(j).parameter.fields{4}.value == 1
            real = 1;
        end
    end
    if ~real
        pat.occurrence(r,[],new);
    end
   
    if ~metre
        continue
    end
    
    p0 = p(i);
    val = Inf;
    for j = 1:length(new.occurrences)
        if isempty(new.occurrences(j).pattern.memory.fields{1}.inter)
            continue
        end
        valj = new.occurrences(j).pattern.memory.fields{1}.inter.content.values;
        if valj < val
            val = valj;
        end
    end
    while i == length(p) || ...
            p(i+1).fields{1}.value - p0.fields{1}.value > val + .01
        p0.fields{1}.value = p0.fields{1}.value + val;
        p0.fields{2}.value = NaN;
        p0.fields{3}.value = 0;
        
        disp(' ');
        display(['> Expecting: ',display(p0,1)]);
    
        old = new;
        new = pat.event(p0);
        pat.syntagm(old,new);
        
        val = Inf;
        for j = 1:length(new.occurrences)
            if ~isempty(new.occurrences(j).pattern.children)
                val0 = new.occurrences(j).pattern.children{1}.parameter.fields{1}.inter.value;
                if val0 < val
                    val = val0;
                end
            end
            for k = 1:length(new.occurrences(j).pattern.specific)
                if ~isempty(new.occurrences(j).pattern.specific(k).children)
                    val0 = new.occurrences(j).pattern.specific(k).children{1}.parameter.fields{1}.inter.value;
                    if val0 < val
                        val = val0;
                    end
                end
            end
        end
        if isinf(val)
            for j = 1:length(new.occurrences)
                val = new.occurrences(j).pattern.memory.fields{1}.inter.content.values;
            end
        end
    end
end

disp(' ');
disp('List of patterns:');
root.displaytree;


function z = diff(x,y)
if isnumeric(x)
    z = x - y;
else
    z = [];
end