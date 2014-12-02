function [memo,mode] = group(from,ioi1,ioi0,options,note,p1,memo,chan,...
                             mode,pattern)

tolerance = .2;

prefix = from;
groups = from.issuffix;
longestclosure = 0;
for i = 1:length(groups)
    % Groups are ordered from smallest to longest.
    if isempty(groups(i).property)
        continue
    end
    ioi2 = groups(i).property;
        % Max inter-onset interval in the group
    if log(ioi1/ioi2) < tolerance
        % This groups and all the remaining ones are similar to or larger
        % than the new IOI.
        break
    end
    % Longer IOI closes this group.
    prefix = groups(i);
    longestclosure = i;
end
if ~isempty(i) && abs(log(ioi1/ioi2)) < tolerance
    % The new IOI fits with this group's IOI
    % The group is extended with the new note.
    segm = groups(i).extend(note,note.parameter);
    segm.property = groups(i).property;
    segm.parameter = segm.parameter.setfield('offset',...
                                note.parameter.getfield('onset'));
    for j = i+1:length(groups)
        % In the remaining (larger) groups, the last element is simply
        % replaced by this extended group.
        if isempty(groups(j).property)
            continue
        end
        from.issuffix(j).suffix = segm;
        from.issuffix(j).parameter = ...
            from.issuffix(j).parameter.setfield('offset',...
                                note.parameter.getfield('onset'));
        from.issuffix(j).parameter = ...
            from.issuffix(j).parameter.setfield('chro',...
                                note.parameter.getfield('chro'));
        note.issuffix = [note.issuffix from.issuffix(j)];
        segm = from.issuffix(j);
    end
else
    % The new IOI is smaller than this group's IOI.
    % A new group is created.
    first = prefix;
    prefix = pat.event(prefix.sequence,prefix.parameter,[],prefix);
    first.isprefix = prefix;
    segm = prefix.extend(note,note.parameter);
    segm.property = ioi1;
    segm.parameter = segm.parameter.setfield('offset',...
                                note.parameter.getfield('onset'));
    for j = longestclosure+1:length(groups)
        % For the current and remaining (larger) groups, the last element 
        % is simply replaced by this new group.
        if isempty(groups(j).property)
            continue
        end
        from.issuffix(j).suffix = segm;
        from.issuffix(j).parameter = ...
            from.issuffix(j).parameter.setfield('offset',...
                                note.parameter.getfield('onset'));
        from.issuffix(j).parameter = ...
            from.issuffix(j).parameter.setfield('chro',...
                                note.parameter.getfield('chro'));
        if from.issuffix(j).property > note.issuffix(end).property
            note.issuffix = [note.issuffix from.issuffix(j)];
        else
            note.issuffix = [from.issuffix(j) note.issuffix];
        end
        segm = from.issuffix(j);
    end
end

groups = note.issuffix;
for i = 1:length(groups)
    ioi1 = groups(i).property;
        % Max inter-onset interval in the segment
    if isempty(ioi1)
        continue
    end
    
    if log(ioi0/ioi1) < tolerance
        % This groups and all the remaining ones are similar to or larger
        % than the new IOI.
        break
    end
    
    % Longer IOI closes this group.
    
    prefix = groups(i);
    prefix.closing = 1;

    if options.broderie
        lowprefix = prefix;
        recurs_extend(lowprefix,p1);
        while isempty(lowprefix.suffix.address)
            lowprefix = lowprefix.suffix;
            recurs_extend(lowprefix,p1);
        end
    end
        
    %return
    
    % Construction of the syntagmatic network.
    ends = [note findstartmetanote(note)];
    % Finding the starting point of the group
    start = groups(i);
    newnote = start;
    while isempty(newnote.address)
        newnote = newnote.suffix;
    end
    if options.contour
        newcont = newnote.to(1).parameter.fields{2}.inter.general.value;
    end
    multi = 0;
    while ~isempty(start.extends)
        %justfound = 0;
        %while ~isempty(start.extends)
            start = start.extends;
        %end
        %start = start.suffix;
        oldnote = start.suffix;
        while isempty(oldnote.address)
            oldnote = oldnote.suffix;
            start = start.suffix;
        end
        if options.contour
            if ~isempty(oldnote.to)
                oldcont = oldnote.to(1).parameter.fields{2}.inter.general.value;
                if oldcont * newcont == -1
                    if multi
                        if isempty(pattern)
                            seq.syntagm(oldnote,note);
                        else
                            pat.syntagm(oldnote,note,pattern.root,0);
                        end
                        %justfound = 1;
                    end
                    newcont = 0;
                end
            end
        end
        multi = 1;
    end
    
    if 0 %~justfound 
        if isempty(pattern)
            seq.syntagm(oldnote,note);
        else
            pat.syntagm(oldnote,note,pattern.root,0);
        end
    end
    
    % Finding the previous note
    for k = 1:length(oldnote.to)
        if k > 1
            continue
        end
        prev = oldnote.to(k).from;
        while ~isempty(prev.passing) && ...
                isequal(prev.passing(2),oldnote.to(k))
            prev = prev.passing(1).from;
        end
        for l = 1:length(ends)
            dt = ends(l).parameter.fields{4}.value - ...
                 prev.parameter.fields{4}.value;
            if dt > 0 && dt < 10
                if isempty(pattern)
                    seq.syntagm(prev,ends(l));
                else
                    pat.syntagm(prev,ends(l),pattern.root,0);
                end
            end
        end
        prev = findstartmetanote(prev);
        for l1 = 1:length(prev)
            for l2 = 1:length(ends)
                dt = ends(l2).parameter.fields{4}.value - ...
                     prev(l1).parameter.fields{4}.value;
                if dt > 0 && dt < 10
                    if isempty(pattern)
                        seq.syntagm(prev(l1),ends(l2));
                    else
                        pat.syntagm(prev(l1),ends(l2),pattern.root,0);
                    end
                end
            end
        end
    end

    if 0 %~isempty(i) && abs(log(ioi1/ioi2)) > tolerance %% RECHECK ALL THIS
        if options.mode
            currentpitches = [p1 p2];
            for j = i-1:-1:1
                gj = groups(j).extends;
                while ~isempty(gj)
                    pj = gj.suffix.parameter.getfield('chro').value;
                    if ~ismember(pj,currentpitches)
                        currentpitches(end+1) = pj;
                    end
                    gj = gj.extends;
                end
            end
        end

        s = prefix.extends;
        while ~isempty(s)
            %p2 = s;
            %memo{chan+1}(ismember(memo{chan+1},p2)) = [];

            if options.mode % && length(currentpitches) > 2
                %pp = p.suffix.parameter.getfield('chro').value;
                for j = 1:length(mode.superscales)
                    if ~(mode.superscales(j).length > 1 || ...
                            ismember(mode.superscales(j).pitches,...
                                currentpitches))
                        %for k = 1:length(mode.superscales(j).superscales)
                        %    idx = ismember(mode.superscales(j).superscales(k).subscales,mode.superscales(j));
                        %    mode.superscales(j).superscales(k).subscales(idx) = [];
                        %end
                        mode.superscales(j).active = 0;% = []
                    end
                end
            end

            s = s.extends;
        end
    end
end


function e = recurs_extend(prefix,p2)
if isempty(prefix)
    e = [];
    return
end
p1 = prefix.parameter.getfield('chro').value;
e = recurs_extend(prefix.extends,p2);
if p1 == p2
    if isempty(e)
        e = prefix;
        while ~isempty(e.suffix)
            e = e.suffix;
        end
    else
        suffix = prefix.suffix;
        while ~isempty(suffix.suffix)
            suffix = suffix.suffix;
        end
        if isempty(e.suffix)
            first = e;
            e = pat.event(e.sequence,e.parameter,[],e);
            if isempty(first.isprefix)
                first.isprefix = e;
            else
                first.isprefix(end+1) = e;
            end
        end
        e = e.extend(suffix,suffix.parameter);
        e.property = [];
    end
end