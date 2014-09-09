function concept = modal(mode,pitch,ioi,address,concept)

% First, simply linking the current pitch with the elementary scale
% consisting of simply that pitch.
found = 0;
for i = 1:length(mode.superscales)
    if mode.superscales(i).pitches == pitch
        found = i;
        break
    end
end
if found
    scale = mode.superscales(found);
    scale.active = 1;
    scale.timescore(address,1) = max(scale.timescore(end),ioi);
else
    scale = mus.scale(pitch);
    scale.tonic = {pitch};
    scale.timescore(address,1) = ioi;
    mode.connect(scale);
end
% Then, extending all previous scales with the new elementary scale.
if address == 1
    predominant = [];
else
    predominant = concept.dominantmodes{address-1};
end
call = mode.lastcall + 1;
mode.lastcall = call;
[dominant,newdominant] = ...
            integrate_pitch_mode(mode,pitch,scale,...
                                 ioi,address,concept.modes,...
                                 predominant,[],[],...
                                 call,0);
if isempty(dominant)
    dominant = newdominant;
end
concept.dominantmodes{address} = dominant;


function [dominant,newdominant] = ...
    integrate_pitch_mode(subscale,pitch,pitchscale,ioi,address,modes,...
                         predominant,dominant,newdominant,call,lvl)
for h = 1:length(subscale.superscales)
    scale = subscale.superscales(h);
    if scale.lastcall == call
        continue
    else
        scale.lastcall = call;
    end
    if ~scale.active
        continue
    end
    if ismember(pitch,scale.pitches)
        %if ioi > scale.timescore(end)
            f = 1; %[];
            %for i = 1:length(scale.tonic)
            %    if scale.tonic{i} == pitch
            %        f = i;
            %        break
            %    end
            %end
            %if isempty(f)
            %    scale.tonic{end+1} = pitch;
            %    scale.timescore(address,end+1) = ioi;
            %else%
            if size(scale.timescore,1) < address || ...
                    ioi > scale.timescore(address,f)
                scale.timescore(address,f) = ioi;
            end
            if scale.length > 1
                [modes,dominant,newdominant] = scale.assign(modes,address,...
                                            predominant,dominant,newdominant);
            end
            %for i = 1:length(scale.subscales)
            %    scale.subscales(i).timescore(address,:) = 0;
            %end

        %end
    else%if scale.timescore(end)
        found = 0;
        for i = 1:length(scale.superscales)
            if scale.superscales(i).length - scale.length == 1 && ...
                    ismember(pitch,scale.superscales(i).pitches)
                new = scale.superscales(i);
                found = 1;
                break
            end
        end
        if ~found
            new = mus.scale(sort([scale.pitches pitch]));
        end

        % The following should segregate scale.
        if ioi > scale.timescore(end)
            new.tonic = {pitch};
            new.timescore(address,1) = ioi;
            scale.timescore(address,1) = 0;
        else
            new.tonic = scale.tonic;
            new.timescore(address,:) = scale.timescore(end,:);
        end

        %if ~found
        %    new.display;
        %end
        [modes,dominant,newdominant] = new.assign(modes,address,...
                                            predominant,dominant,newdominant);
        if ~found
            [new,scale] = recurs_integrate0(pitch,new,scale,call,lvl,h,[]);
            for i = 1:length(scale.subscales)
                if isempty(scale.subscales(i).pitches)
                    continue
                end
                scale.subscales(i).lastcall2 = [call lvl h 1];
                [new,scale.subscales(i)] = ...
                    recurs_integrate(new,scale.subscales(i),call,lvl,h);
            end
            scale.connect(new);
            if new.length < 3
                pitchscale.connect(new);
            end
        end
    end
    [dominant,newdominant] = ...
        integrate_pitch_mode(scale,pitch,pitchscale,ioi,address,modes,...
                             predominant,dominant,newdominant,call,lvl+1);
end


function [new,scale] = recurs_integrate0(pitch,new,scale,call,call2,call3,firstscale)
for i = 1:length(scale.superscales)
    if isempty(firstscale)
        firstscalei = 0;
    elseif 1 %isequal(firstscale,0)
        firstscalei = scale.superscales(i);
    else
        firstscalei = firstscale;
    end
    if isequal(scale.superscales(i).lastcall2,[call,call2,call3,0])
        continue
    else
        scale.superscales(i).lastcall2 = [call,call2,call3,0];
    end
    if ~isnumeric(firstscalei) && ...
            ismember(pitch,scale.superscales(i).pitches) ...
            && ~ismember(firstscalei,new.superscales)
        if isempty(new.superscales)
            new.superscales = firstscalei;
        else
            new.superscales(end+1) = firstscalei;
        end
        firstscalei.subscales(end+1) = new;
    end
    [new,scale.superscales(i)] = ...
        recurs_integrate0(pitch,new,scale.superscales(i),call,call2,call3,firstscalei);
end
            
            
function [new,scale] = recurs_integrate(new,scale,call,call2,call3)
for i = 1:length(scale.superscales)
    if isequal(scale.superscales(i).lastcall2,[call,call2,call3,1])
        continue
    else
        scale.superscales(i).lastcall2 = [call,call2,call3,1];
    end
    if isequal(new,scale.superscales(i))
        continue
    end
    if ismember(new,scale.superscales(i).superscales)
        continue
    end
    for k = 1:length(scale.superscales(i).pitches)
        found = 0;
        if ~ismember(scale.superscales(i).pitches(k),new.pitches)
            found = 1;
            break
        end
    end
    if found
        continue
    end
    if ismember(scale.superscales(i),new.subscales)
        continue
    end
    if isempty(new.subscales)
        new.subscales = scale.superscales(i);
    else
        new.subscales(end+1) = scale.superscales(i);
    end
    if isempty(scale.superscales(i).superscales)
        scale.superscales(i).superscales = new;
    else
        scale.superscales(i).superscales(end+1) = new;
    end
    [new,scale.superscales(i)] = ...
        recurs_integrate(new,scale.superscales(i),call,call2,call3);
end