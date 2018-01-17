% SIG.EVALEACH performs the top-down traversal of the design flowchart, at 
% the beginning of the evaluation phase.
% This is during that traversal that we check whether a chunk decomposition
% needs to be performed or not, and carry out that chunk decomposition.
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function y = evaleach(design,filename,window,sr,nargout,chunking,nbsamples) %,single,name
% The last three arguments are not used when sig.evaleach is called for the
% first time, by sig.design.eval.
if nargin<6
    chunking = 0;
end
if nargin<7 && length(window) > 1
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
        
        y = {sig.Signal(data,'Name','waveform',...
            'Sstart',(window(1)-1)/sr,'Send',(window(2)-1)/sr,'Srate',sr,...
            'Ssize',data.size('sample'))};
        
        %y = set(y,'AcrossChunks',get(d,'AcrossChunks'));
    end
    
else
    if chunking % Already in a chunk decomposition process
        input = design.input;
        if iscell(input)
            input = input{1};
        end
        y = sig.evaleach(input,filename,window,sr,1,chunking);
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
        y = sig.evaleach(input,filename,window,sr,1,chunking);
        y = design.main(y,design.options);
        y = design.after(y,design.options);
    elseif design.nochunk || strcmpi(design.combine,'no')
        if length(design.input) == 1
            input = design.input;
            if iscell(input)
                input = input{1};
            end
            y = sig.evaleach(input,filename,window,sr,1,chunking);
        else
            y = [sig.evaleach(design.input{1},filename,window,sr,1,chunking),...
                 sig.evaleach(design.input{2},filename,window,sr,1,chunking)];
        end
        main = design.main;
        if iscell(main)
            main = main{1};
        end
        y = main(y,design.options);
        y = design.after(y,design.options);
    else
        if nbsamples > sig.chunklim
            % The required memory exceed the max memory threshold.
            nch = ceil(nbsamples/sig.chunklim);
            chunks = max(0,nbsamples-sig.chunklim*(nch:-1:1))+window(1);
            overlap = design.overlap.value;
            if strcmpi(design.overlap.unit,'s')
                overlap = round(overlap*sr) - 1; % The -1 is used solely for sig.frame. If other operators need 's', decompose into 2 cases
            end
            chunks(2,:) = nbsamples-max( sig.chunklim*(nch-1:-1:0)-overlap , 0)+window(1)-1;
        else
            chunks = [];
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
                options.missing = max(diffchunks) - diffchunks(i);
                chunking = 1;
                ss = sig.evaleach(design.input,filename,window,sr,1,...
                    chunking,nbsamples);
                
                main = design.main;
                if iscell(main)
                    main = main{1};
                end
                ss = main(ss,options);
                
                if isempty(ss{1})
                    break
                end
                
                if length(ss)>1
                    options.tmp = ss{2};
                end
                
                y = combinechunks(y,ss{1},i,design,chunks,nargout);
                
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
            
            if ~iscell(y)
                y = {y};
            end
            
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
            y = sig.evaleach(design.input,filename,window,sr,1);
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


%%
function res = combinechunks(old,new,i,design,chunks,nargout) %,sg,single)
if i == 1
    res = new;
else
    if old.Frate
        res = combineframes(old,new);
    elseif old.Srate
        overlap = design.overlap.value;
        if strcmp(design.overlap.unit,'s')
            overlap = 0; % Used solely for sig.frame. If other operators need 's', decompose into 2 cases
        end
        res = combinesamples(old,new,overlap);
    else
        res = old;
        if ischar(design.combine)
            res.Ydata = old.Ydata.(design.combine)(new.Ydata);
            
        else
            res = design.combine(old,new);
        end
        res.Ssize = old.Ssize + new.Ssize;
    end
end


function old = combineframes(old,new)
old.Ydata = old.Ydata.concat(new.Ydata,'frame');
if ~isempty(old.peakindex)
    old.peakindex = old.peakindex.concat(new{1}.peak,'frame');
end


function old = combinesamples(old,new,delta)
old.Ydata = old.Ydata.concat(new.Ydata,'sample',delta/2);
if ~isempty(old.peakindex)
    old.peakindex = old.peakindex.concat(new.peak,'sample');
end
if isa(old,'sig.Spectrum') && ~isempty(old.phase)
    old.phase = old.phase.concat(new.phase,'sample');
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