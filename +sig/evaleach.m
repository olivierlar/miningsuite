% SIG.EVALEACH performs the top-down traversal of the design flowchart, at 
% the beginning of the evaluation phase.
% This is during that traversal that we check whether a chunk decomposition
% needs to be performed or not, and carry out that chunk decomposition.
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function y = evaleach(design,filename,window,sr,nargout,frame,chunking,nbsamples) %,single,name
% The last three arguments are not used when sig.evaleach is called for the
% first time, by sig.design.eval.
if nargin<6
    frame = [];
end
if nargin<7
    chunking = 0;
end
if nargin<8 && length(window) > 1
    nbsamples = window(2)-window(1)+1;
end

if iscell(design)
    design = design{1};
end

%chan = d.channel;

%sg = d.segment;
%if ischar(sg)
%    error('ERROR in MIREVAL: mirsegment of design object accepts only array of numbers as second argument.');
%end
if 0 %not(isempty(sg))
    if ~isnumeric(sg)
        sg = sort(mirgetdata(sg));
        sg = [0 sg';sg' len];
    end
    over = find(sg(2,:) > len);
    if not(isempty(over))
        sg = sg(:,1:over-1);
    end
end

%specif = d.specif;
if 0 %isaverage(specif)
    specif.eachchunk = 'Normal';
end

if isempty(design.main)
    % The top-down traversal of the design flowchart now reaches the lowest
    % layer, i.e., file loading.
    % Now the actual evaluation will be carried out bottom-up.
    
    if isempty(sr)
        y = mus.score(filename);
    else
        data = sig.read(filename,window);
        
        if design.options.mix %strcmpi(design.options.mix,'Pre')
            data = data.mean('channel');
        end
        
        %if frame.inner
        %    warning('Inner frame has not been executed.');
        %end
        
        if ~isempty(frame) && frame.toggle
            frate = sig.compute(@sig.getfrate,sr,frame);
            if strcmpi(frame.size.unit,'s')
                fl = frame.size.value;
            elseif strcmpi(frame.size.unit,'sp')
                fl = frame.size.value/sr;
            end
            data = data.frame(frame,sr);
            y = {sig.Signal(data,'Xsampling',1/sr,'Name','waveform',...
                'Sstart',(window(1)-1)/sr,'Srate',sr,...
                'Ssize',data.size('sample'),...
                'Frate',frate,'Flength',fl)};
        else
            y = {sig.Signal(data,'Name','waveform',...
                'Sstart',(window(1)-1)/sr,'Srate',sr,...
                'Ssize',data.size('sample'))};
        end
        
        %y = set(y,'AcrossChunks',get(d,'AcrossChunks'));
    end
    
else
    if isempty(frame) || ~frame.toggle
        % Not already in a frame decomposition process
        frame = design.frame;
    end
    if chunking % Already in a chunk decomposition process
        input = design.input;
        if iscell(input)
            input = input{1};
        end
        y = sig.evaleach(input,filename,window,sr,1,frame,chunking);
        main = design.main;
        if iscell(main)
            main = main{1};
        end
        y = main(y,design.options);
        if chunking == 1
            y = design.after(y,design.options);
        end
    elseif isempty(sr)
        input = design.input;
        if iscell(input)
            input = input{end};
        end
        y = sig.evaleach(input,filename,window,sr,1,[],chunking);
        if ~isfield(design.options,'frame')
            design.options.frame = frame;
        end
        y = design.main(y,design.options);
        y = design.after(y,design.options);
    elseif design.nochunk || strcmpi(design.combine,'no')
        if length(design.input) == 1
            input = design.input;
            if iscell(input)
                input = input{1};
            end
            y = sig.evaleach(input,filename,window,sr,1,frame,chunking);
        else
            y = [sig.evaleach(design.input{1},filename,window,sr,1,frame,chunking),...
                 sig.evaleach(design.input{2},filename,window,sr,1,frame,chunking)];
        end
        main = design.main;
        if iscell(main)
            main = main{1};
        end
        y = main(y,design.options);
        y = design.after(y,design.options);
    else
        %frnochunk = isfield(d.frame,'dontchunk');
        %frchunkbefore = isfield(d.frame,'chunkbefore');
        if ~isempty(frame) && frame.toggle % && ~frame.inner
            chunks = compute_frames(frame,sr,window,nbsamples,sig.chunklim,design.overlap);
        else
            if nbsamples > sig.chunklim
                % The required memory exceed the max memory threshold.
                nch = ceil(nbsamples/sig.chunklim);
                chunks = max(0,nbsamples-sig.chunklim*(nch:-1:1))+window(1);
                chunks(2,:) = nbsamples-max( sig.chunklim*(nch-1:-1:0)-design.overlap(1) , 0)+window(1)-1;
            else
                chunks = [];
            end
        end
        
        if not(isempty(chunks))
            % The chunk decomposition is performed.
            nch = size(chunks,2);
            %d = callbeforechunk(d,d,w,lsz); % Some optional initialisation
            %tmp = [];
            if 1%mirwaitbar
                h = waitbar(0,['Computing ' design.name]);
            else
                h = [];
            end
            
            %afterpostoption = d.postoption; % Used only when:
            % - eachchunk is set to 'Normal',
            % - combinechunk is not set to 'Average', and
            % - no afterchunk field has been specified.
            % afterpostoption will be used for the final call
            % to the method after the chunk decomposition.
            %                 main = design.main;
            %                 if 0 %~isfield(specif,'eachchunk')
            %                     specif.eachchunk = 'Normal';
            %                 end
            %                 if 1 %ischar(specif.eachchunk) && strcmpi(specif.eachchunk,'Normal')
            %                     if 0 %not(isempty(d.postoption))
            %                         pof = fieldnames(d.postoption);
            %                         for o = 1:length(pof)
            %                             if isfield(specif.option.(pof{o}),'chunkcombine')
            %                                 afterpostoption = rmfield(afterpostoption,pof{o});
            %                             else
            %                                 d.postoption = rmfield(d.postoption,pof{o});
            %                             end
            %                         end
            %                     end
            %                 else
            %                     main = specif.eachchunk;
            %                 end
            
            y = {};
            options = design.options;
            options.tmp = [];
            options.missing = 0;
            diffchunks = diff(chunks);
            for i = 1:size(chunks,2)
                disp(['Chunk ',num2str(i),'/',num2str(nch),'...'])
                window = [chunks(1,i) chunks(2,i) (i == size(chunks,2))];
                if isempty(frame) || ~frame.toggle
                    options.missing = max(diffchunks) - diffchunks(i);
                end
                chunking = 1;
                ss = sig.evaleach(design.input,filename,window,sr,1,...
                    frame,chunking,nbsamples);
                
                main = design.main;
                if iscell(main)
                    main = main{1};
                end
                ss = main(ss,options);
                
                if length(ss)>1
                    options.tmp = ss{2};
                end
                
                y = combinechunks(y,ss,i,design,chunks,nargout);
                
                clear ss
                if ~isempty(h)
                    if 0 %not(d.ascending)
                        close(h)
                        h = waitbar((chunks(1,i)-chunks(1,end))/chunks(2,1),...
                            ['Computing ' func2str(d.method) ' (backward)']);
                    else
                        waitbar((chunks(2,i)-chunks(1))/chunks(end),h)
                    end
                end
            end
            
            y = design.after(y,design.options);
            
            if 0 %isa(d,'mirstruct') && ...
                (isempty(d.frame) || isfield(d.frame,'dontchunk'))
                y = evalbranches(d,y);
            end
            if ~isempty(h)
                close(h)
            end
            drawnow
            
        else
            % No chunk decomposition
            y = sig.evaleach(design.input,filename,window,sr,1,frame);
            design.options.extract = [];
            main = design.main;
            if iscell(main)
                main = main{1};
            end
            y = main(y,design.options);
            y = design.after(y,design.options);
            if 0 %isa(d,'mirstruct') && isfield(d.frame,'dontchunk')
                y = evalbranches(d,y);
            end
        end
    end
    if isa(y,'seq.Sequence')
        return
    end
%     if design.nochunk && ...
%             ~isempty(frame) && frame.toggle
%         frate = sig.compute(@sig.getfrate,y{1}.Srate,frame);
%         y{1}.Ydata = y{1}.Ydata.frame(frame,y{1}.Srate);
%         y{1}.Frate = frate;
%     end
end



if iscell(y)
    for i = 1:length(y)
        if isa(y{i},'sig.Signal')
            if ischar(design)
                y{i}.design = {filename};
            else
                y{i}.design = design(1);
                y{i}.design.evaluated = 1;
                y{i}.design.files = filename;
            end
        end
    end
end
 
if 0 %iscell(y)
    for i = 1:length(y)
        if not(isempty(y{i}) || isstruct(y{i}))
            if iscell(y{i})
                for j = 1:length(y{i})
                    y{i}{j} = set(y{i}{j},'InterChunk',[]);
                end
            else
                y{i} = set(y{i},'InterChunk',[]);
            end
        end
    end
end


function chunks = compute_frames(fr,sr,w,lsz,CHUNKLIM,frov)
if strcmpi(fr.size.unit,'s')
    fl = fr.size.value*sr;
elseif strcmpi(fr.size.unit,'sp')
    fl = fr.size.value;
end
if strcmpi(fr.hop.unit,'/1')
    h = fr.hop.value*fl;
elseif strcmpi(fr.hop.unit,'%')
    h = fr.hop.value*fl*.01;
elseif strcmpi(fr.hop.unit,'s')
    h = fr.hop.value*sr;
elseif strcmpi(fr.hop.unit,'sp')
    h = fr.hop.value;
elseif strcmpi(fr.hop.unit,'Hz')
    h = sr/fr.hop.value;
end
n = floor((lsz-fl)/h)+1;   % Number of frames
if n < 1
    %warning('WARNING IN MIRFRAME: Frame length longer than total sequence size. No frame decomposition.');
    fp = w;
else
    st = floor(((1:n)-1)*h)+w(1);
    fp = [st; floor(st+fl-1)];
    fp(:,fp(2,:)>w(2)) = [];
end
fpsz = (fp(2,1)-fp(1,1)) * n;      % Total number of samples
if fpsz > CHUNKLIM
    % The required memory exceed the max memory threshold.
    nfr = size(fp,2);                     % Total number of frames
    frch = max(ceil(CHUNKLIM/(fp(2,1)-fp(1,1))),2); % Number of frames per chunk
    frch = max(frch,frov*2);
    nch = ceil((nfr-frch)/(frch-frov))+1; % Number of chunks
    chbeg = (frch-frov)*(0:nch-1)+1;    % First frame in the chunk
    chend = (frch-frov)*(0:nch-1)+frch; % Last frame in the chunk
    chend = min(chend,nfr);
    if frov > 1
        chbeg = chend-frch+1;
    end
    chunks = [fp(1,chbeg) ; fp(2,chend)+1]; % After resampling, one sample may be missing, leading to a complete frame drop.
    chunks(end) = min(chunks(end),fp(end)); % Last chunk should not extend beyond audio size.
else
    chunks = [];
end


%%
function res = combinechunks(old,new,i,design,chunks,nargout) %,sg,single)
if i == 1
    res = new;
else
    if iscell(old{1})
        old{1} = old{1}{1}; % This needs to be properly studied..
    end
    if iscell(new{1})
        new{1} = new{1}{1};
    end
    
    if old{1}.Frate
        res = combineframes(old,new);
    elseif old{1}.Srate
        res = combinesamples(old,new,design.overlap(1));
    else
        res = old;
        for z = 1:length(old)
            %if 0 %isframed(old{z})
            %    res(z) = combineframes(old{z},new{z});
            %else
            if ischar(design.combine)
                %if strcmpi(design.combine,'Concat')
                %    res{z} = concatchunk(old{z},new{z},d2.ascending);
                %elseif strcmpi(design.combine,'Sum')
                res{z}.Ydata = old{z}.Ydata.(design.combine)(new{z}.Ydata);
                %else
                %    error(['SYNTAX ERROR: ',design.combine,...
                %           ' is not a known keyword for combinechunk.']);
                %end
            else
                res{z} = design.combine(old{z},new{z});
            end
        end
        res{z}.Ssize = old{z}.Ssize + new{z}.Ssize;
    end
end


function old = combineframes(old,new)
old{1}.Ydata = old{1}.Ydata.concat(new{1}.Ydata,'frame');
if ~isempty(old{1}.peak)
    old{1}.peak = old{1}.peak.concat(new{1}.peak,'frame');
end


function old = combinesamples(old,new,delta)
for i = 1:length(new)
    if ~isa(old{i},'sig.Signal')
        continue
    end
    old{i}.Ydata = old{i}.Ydata.concat(new{i}.Ydata,'sample',delta/2);
    if ~isempty(old{i}.peak)
        old{i}.peak = old{i}.peak.concat(new{i}.peak,'sample');
    end
end
      

function d0 = callbeforechunk(d0,d,w,lsz)
% If necessary, the chunk decomposition is performed a first time for
% initialisation purposes.
% Currently used only for miraudio(...,'Normal')
if not(ischar(d)) && not(iscell(d))
    specif = d.specif;
    CHUNKLIM = mirchunklim;
    nch = ceil(lsz/CHUNKLIM); 
    if isfield(specif,'beforechunk') ...
            && ((isfield(d.option,specif.beforechunk{2}) ...
                    && d.option.(specif.beforechunk{2})) ...
             || (isfield(d.postoption,specif.beforechunk{2}) ...
                    && d.postoption.(specif.beforechunk{2})) )
        if mirwaitbar
            h = waitbar(0,['Preparing ' func2str(d.method)]);
        else
            h = 0;
        end
        for i = 1:nch
            disp(['Chunk ',num2str(i),'/',num2str(nch),'...'])
            chbeg = CHUNKLIM*(i-1);
            chend = CHUNKLIM*i-1;
            d2 = set(d,'Size',d0.size,'File',d0.file,...
                       'Chunk',[chbeg+w(1) min(chend,lsz-1)+w(1)]);
            d2.method = specif.beforechunk{1};
            d2.postoption = {chend-lsz};
            d2.chunkdecomposed = 1;
            [tmp d] = evalnow(d2);
            d0 = set(d0,'AcrossChunks',tmp);
            if h
                waitbar(chend/lsz,h)
            end
        end
        if h
            close(h);
        end
        drawnow
    else
        d0 = callbeforechunk(d0,d.argin,w,lsz);
    end
end