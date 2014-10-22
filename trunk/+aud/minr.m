% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function out = minr(arg,varargin)

options = seq.options(initoptions,varargin);

if isa(arg,'aud.Sequence')
    out = arg;
else
    out = aud.Sequence;
end

if ischar(arg)
    out = reads(arg,options);
elseif isa(arg,'sig.design')
    design = sig.design('aud','minr',arg,'aud.Sequence',...
                        @transcribe,options,[],arg.frame,[],varargin,...
                        arg.extract,0,arg.nochunk);
    design.evaluate = 1;
    out = {design};
elseif isa(arg,'aud.Sequence')
    out = arg;
    if iscell(arg.files)
        for i = 1:length(arg.content)
            if options.events
                events = options.events;
                events(events > length(arg.content{i})) = [];
                out.content{i} = arg.content{i}(events);
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
            for j = 1:length(out.content{i})
                [memory,out.content{i}{j}] = ...
                    process(out.content{i}{j},memory,options);
            end
        end
    else
        if options.events
            options.events(options.events > length(arg.content)) = [];
            out.content = arg.content(options.events);
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
        for j = 1:length(out.content)
            if j == length(out.content)
                ioi = Inf;
            else
                ioi = out.content{j+1}.parameter.getfield('onset').value ...
                    - out.content{j}.parameter.getfield('onset').value;
            end
            [out.content{j},memory] = ...
                process(out.content{j},memory,ioi);
        end
    end
elseif isa(arg,'sig.data')
    out = transcribe(arg);
end


function out = reads(arg,options)
out = aud.Sequence;
if strcmpi(arg,'Folder')
    d = dir;
    dn = {d.name};
    for i = 1:length(dn)
        out = read(out,dn{i},options,1);
    end
else
    out = read(out,arg,options,0);
end


function out = read(out,name,options,concept,folder)
try
    info = audioinfo(name);
    
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
    e = sig.envelope(name);
    p = sig.peaks(e,'Threshold',.5);
    p = p.eval;
    p = p{1};
    out = transcribe(out,p,options);
else
    % Symbolic input
end


function out = transcribe(out,in,options)
ps = aud.paramstruct;
if isa(in,'sig.Envelope')
    p = sort(in.peakpos.content{1});
    memory = [];
    event = [];
    for i = 1:length(p)
        param = aud.param(ps,p(i),p(i)+.01);
        event = seq.event(out,param,event);
        event.address = i;
        out = out.integrate(event);
        if ~isempty(options)
            [event,memory] = process(event,memory,options);
        end
    end
end


function [event,memo] = process(event,memo,options,ioi)
if 1 %isempty(chan)
    chan = 0;
end

event.parameter

if length(memo) < chan+1 
    memo{chan+1} = [];
end
k = 1;
while k <= length(memo{chan+1})
    if k > 1 %&& ...
            %memo{chan+1}(k).parameter.getfield('chro').value ~= ...
            %    note.parameter.getfield('chro').value
        break
    end
    prev = memo{chan+1}(k);
    sk = seq.syntagm(prev,event);
    
    for i = length(prev.issuffix):-1:1
        if prev.issuffix(i).closing
            suffix = prev.issuffix(i);
            while ~isempty(suffix.extends)
                while ~isempty(suffix.extends)
                    suffix = suffix.extends;
                end
                if ~isempty(suffix.suffix)
                    suffix = suffix.suffix;
                end
            end
            if event.parameter.fields{1}.value - ...
                    suffix.parameter.fields{1}.value < 10
                seq.syntagm(suffix,event);
            end
            break
        end
    end
    
    if options.group && k == 1
        ioi1 = sk.parameter.getfield('onset').inter.value;
            % New inter-onset interval
        [memo] = mus.group(sk.from,ioi1,ioi,options,event,memo,chan);
    end
    k = k + 1;
end

if length(memo) < chan+1
    memo{chan+1} = event;
else
    memo{chan+1} = [event,memo{chan+1}];
end


function options = initoptions
    events.key = 'Events';
    events.type = 'Numeric';
options.events = events;

    t1.key = 'StartTime';
    t1.type = 'Numeric';
options.t1 = t1;

    t2.key = 'EndTime';
    t2.type = 'Numeric';
options.t2 = t2;

    chan.key = 'Channel';
    chan.type = 'Numeric';
    chan.default = [];
options.chan = chan;

    group.key = 'Group';
    group.type = 'Boolean';
options.group = group;