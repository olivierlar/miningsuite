% MUS.OUTPUT
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function output(seq,name,ind)

disp('Compiling the output in the txt file...')

fid = fopen(name,'wt');

if nargin < 3
    notes = seq.content;
else
    notes = seq.content{ind};
end

nn = length(notes);

chr = NaN(1,nn);
t = zeros(2,nn);

for i = 1:nn
    chr(i) = notes{i}.parameter.getfield('chro').value;
    t(1,i) = notes{i}.parameter.getfield('onset').value;
    t(2,i) = notes{i}.parameter.getfield('offset').value;
end    

option.scheaf = 1;
option.minlength = 12;

pool = {};
pats = 0;
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
                    %f = length(pool);
                    %fprintf(fid,['pattern',num2str(f),'\n']);
                
                    for h = 1:length(s.closedbranches)
                        p = s.closedbranches(h);
                        if p.length < 1
                            continue
                        end
                        
                        pats = pats+1;
                        fprintf(fid,['pattern',num2str(pats),'\n']);
                        
                        occs = p.occurrences;
                        for k = 1:length(p.specific)
                            for k2 = 1:length(p.specific(k).occurrences)
                                found = 0;
                                for k3 = 1:length(occs)
                                    if isequal(occs(k3).suffix,...
                                            p.specific(k).occurrences(k2)...
                                                .suffix)
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
                            nk = occs(k).suffix.to.address;
                            occk = occs(k);
                            patk = p;
                            while ~isempty(patk.parent) && ...
                                    ~isempty(patk.parent.parent)
                                nk = [occk.suffix.to.address nk];
                                occk = occk.prefix;
                                patk = patk.parent;
                            end
                            occk = occk.suffix;
                            if isa(occk,'pat.syntagm')
                                occk = occk.to;
                            end
                            nk = [occk.address nk];
                            fprintf(fid,['occurrence',num2str(k),'\n']);
                            for l = 1:length(nk)
                                fprintf(fid,'%1.5f, %1.5f \n',...
                                    notes{nk(l)}.parameter.fields{4}.value,...
                                    notes{nk(l)}.parameter.fields{2}.value);
                            end
                            %if isempty(pool{end}.start)
                            %    pool{end}.start = N1;
                            %end                            
                        end
                    end
                    
                end
            end
        end
    end
end

fclose(fid); 


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