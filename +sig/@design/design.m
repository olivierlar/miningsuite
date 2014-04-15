% SIG.DESIGN class
% stores the whole dataflow design, which is evaluated only when the user
% wants to display the results.
% Internally called by sig.operate and seq.Sequence.
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

classdef design
    properties
        package
        name
        input
        type
        argin
        extract
        
        main
        
        duringoptions
        afteroptions
        
        frame
        combine
        
        evaluate = 0;
        evaluated

        date
        ver
        
        extensive
        nochunk = 0
    end
    properties (Dependent)
        files
    end
%%
    methods
        function obj = design(pack,name,input,type,main,during,after,...
                              frame,combine,argin,extract,extensive,nochunk)
            if nargin<10
                extract = [];
            end
            
            obj.package = pack;
            obj.name = name;
            obj.input = input;
            obj.type = type;
            obj.main = main;
            obj.duringoptions = during;
            if nargin>6
                obj.afteroptions = after;
                obj.frame = frame;
                obj.combine = combine;
                obj.argin = argin;
                obj.extract = extract;
                obj.date = date;
                obj.ver = ver;
                obj.extensive = extensive;
                obj.nochunk = nochunk;
            end
        end
        %%
        function f = get.files(obj)
            f = getfiles(obj);
        end
        %%
        function out = eval(obj,arg)
            if nargin<2
                arg = obj.files;
            end
            if strcmpi(arg,'Folder') || strcmpi(arg,'Folders')
                [nfiles sz sr files] = ...
                    folderinfo('',[],0,[],[],{},strcmpi(arg,'Folders'));
                if nfiles == 0
                    sig.warning('sig.eval','No sound file detected in this folder.')
                    out = {{}};
                    return
                end
                w = zeros(2,length(sz));
                if isempty(obj.extract)
                    for i = 1:length(sz)
                        w(:,i) = [1;sz(i)];
                    end
                else
                    for i = 1:length(sz)
                        interval = obj.extract.value;
                        if strcmpi(obj.extract.unit,'s')
                            interval = round(interval*sr(i)) + 1;
                        end
                        w(:,i) = min(max(interval,1),sz(i));
                    end
                end
            else
                [sz,ch,sr] = fileinfo(arg,0);
                if isempty(obj.extract)
                    w = [1;sz];
                else
                    interval = obj.extract.value;
                    if strcmpi(obj.extract.unit,'s')
                        interval = round(interval*sr) + 1;
                    end
                    w = min(max(interval,1),sz);
                end
                files = {arg};
                nfiles = 1;
            end
            out = cell(1,nfiles);
            for i = 1:nfiles
                out{i} = sig.evaleach(obj,files{i},w,sr(i));
            end
            %if isempty(obj.input.main)
            %    out{1}.Ydata.design.input = files;
            %end
            if nfiles > 1
                out = combineaudiofile(files,out{:});
                out{1}.celllayers = 'files';
            else
                out = out{1};
            end
        end
        %%
        function out = display(obj,recurs)
            if obj.evaluate
                if strcmpi(obj.files,'Folder') || ...
                   strcmpi(obj.files,'Folders')
                    [nfiles sz sr files] = folderinfo('',[],0,[],[],{},...
                                            strcmpi(obj.files,'Folders'));
                    if nfiles == 0
                        sig.warning('sig.eval','No sound file detected in this folder.')
                        out = {{}};
                        return
                    end
                    for i = 1:length(files)
                        out = obj.eval(files{i});
                        if isa(out{1},'sig.signal')
                            out{1}.display;
                        end
                    end
                else
                    out = obj.eval(obj.files);
                    if isa(out{1},'sig.signal')
                        out{1}.display;
                    end
                end
            else
                input = obj.input;
                if ischar(input)
                    input = ['''' input ''''];
                else
                    input.evaluate = 0;
                    input = input.display(1);
                end
                out = [obj.package '.' obj.name,'(',input,')'];
                if nargin<2
                    display(out);
                end
            end
            if length(out) == 1
                out = out{1};
            end
            sig.ans(out);
        end
        function show(obj,varargin)
            if isempty(obj.input)
                return
            end
            if ~ischar(obj.input)
                obj.input.show(0);
            end
            str = '';
            for i = 1:length(obj.argin)
                arg = obj.argin{i};
                if isnumeric(arg)
                    arg = num2str(arg);
                else
                    arg = ['''',arg,''''];
                end
                str = [str ', ' arg];
            end
            if ischar(obj.input)
                disp('--------')
                input = ['''' obj.input ''''];
            else
                %disp(' ')
                input = '...';
            end
            disp(['> ',obj.package,'.',obj.name,' ( ',input,str,' )']);
            disp(obj.duringoptions)
            disp(obj.afteroptions)
            if nargin < 2
                disp(['Design date: ' obj.date])
                for i = 1:length(obj.ver)
                    if strcmp(obj.ver(i).Name,'The MiningSuite')
                        disp(['using The MiningSuite version ',obj.ver(i).Version])
                        break
                    end
                end
            end
        end
        function play(obj,varargin)
            sig.play(obj,varargin{:});
        end
        %function res = isa(obj,class)
        %    res = strcmp(obj.type,class);
        %end
    end
end

%%
function f = getfiles(obj)
    f = obj.input;
    if isa(f,'sig.design')
        f = getfiles(f);
    elseif isa(f,'sig.signal')
        f = getfiles(f.design);
    end
end
        

function [l sz sr a] = folderinfo(path,s,l,sz,sr,a,folders)
    if not(isempty(path))
        path = [path '/'];
    end
    dd = dir;
    dn = {dd.name};
    nn = cell(1,length(dn));  % Modified file names
    for i = 1:length(dn)      % Each file name is considered
        j = 0;
        while j<length(dn{i})   % Each successive character is modified if necessary
            j = j+1;
            tmp = dn{i}(j) - '0';
            if tmp>=0 && tmp<=9
                while j+1<length(dn{i}) && dn{i}(j+1)>='0' && dn{i}(j+1)<='9'
                    j = j+1;
                    tmp = tmp*10 + (dn{i}(j)-'0');
                end
            else
                tmp = dn{i}(j);
            end
            nn{i}{end+1} = tmp;
        end
    end
    dd = sortnames(dd,[],nn);
    for i = 1:length(dd);
        nf = dd(i).name;
        if folders && dd(i).isdir
            if not(strcmp(nf(1),'.'))
                cd(dd(i).name)
                [l sz sr a] = folderinfo([path nf],s,l,sz,sr,a,1);
                cd ..
            end
        else
            [di,ch,fi] = fileinfo(nf,1);
            if not(isempty(di))
                l = l+1;
                sz(l) = di;
                sr(l) = fi;
                a{l} = [path nf];
            end
        end
    end
end


function [sz,ch,sr] = fileinfo(file,folder)
    sz = [];
    ch = [];
    sr = [];
    try
        [sz,ch,sr] = audioread(@wavread,file);
    catch
        err.wav = lasterr;
        try
           [sz,ch,sr] = audioread(@auread,file);
        catch
            err.au = lasterr;
            try
                [sz,ch,sr] = audioread(@mp3read,file);
            catch
                err.mp3 = lasterr;
                try
                    [sz,ch,sr] = audioread(@aiffread,file);
                catch
                    err.aiff = lasterr;
                    try
                        ch = midiread(file);
                        sr = 0;
                        sz = 0;
                        if ~ch
                            error;
                        end
                    catch
                        if not(strcmp(err.wav(1:11),'Error using') && folder)
                            misread(file, err);
                        end
                    end
                end
            end
        end
    end
end


function [sz,ch,sr] = audioread(reader,file)
    [unused,sr] = reader(file,1);
    dsize = reader(file,'size');
    sz = dsize(1);
    ch = dsize(2);
end


function test = midiread(name)
    fid = fopen(name);
    if fid<0
        error;
        return
    end
    head = fread(fid,'uint8');
    fclose(fid);
    test = isequal(head(1:4)',[77 84 104 100]);
end


function misread(file,err)
    display('Here are the error message returned by each reader:');
    display(err.wav);
    display(err.au);
    display(err.mp3);
    display(err.aiff);
    error(['Cannot open file ',file]);
end


%%
function c = combineaudiofile(files,varargin)
    % Combine output from several audio files into one single
    c = varargin{1};    % The (series of) output(s) related to the first audio file
    if 0 %isempty(c)
        return
    end
    if 0 %isstruct(c)
        for j = 1:length(varargin)
            if j == 1
                fields = fieldnames(varargin{1});
            else
                fields = union(fields,fieldnames(varargin{j}));
            end
        end
        for i = 1:length(fields)
            field = fields{i};
            v = {};
            for j = 1:length(varargin)
                if isfield(varargin{j},field)
                    v{j} = varargin{j}.(field);
                else
                    v{j} = NaN;
                end
            end
            c.(field) = combineaudiofile('',isstat,v{:});
            if strcmp(field,'Class')
                c.Class = c.Class{1};
            end
        end
        if not(isempty(files)) && isstat
            c.FileNames = files;
        end
        return
    end
    if 0% ischar(c)
        c = varargin;
        return
    end
    if 0 %(not(iscell(c)) && not(isa(c,'sig.signal')))
        for j = 1:length(varargin)
            if j == 1
                lv = size(varargin{j},1);
            else
                lv = max(lv,size(varargin{j},1));
            end
        end
        c = NaN(lv,length(varargin));
        for i = 1:length(varargin)
            if not(isempty(varargin{i}))
                c(1:length(varargin{i}),i) = varargin{i};
            end
        end
        return
    end
    if 0 %(iscell(c) && not(isa(c{1},'sig.signal')))
        for i = 1:length(c)
            v = cell(1,nargin-2);
            for j = 1:nargin-2
                v{j} = varargin{j}{i};
            end
            c{i} = combineaudiofile(files,isstat,v{:});
        end
        return
    end
    if not(iscell(c))
        c = {c};
    end
    nv = length(c); % The number of output for each different audio file
    for j = 1:nv    % Combine files for each different output
        v = varargin;
        for i = 1:length(varargin)
            if iscell(v{i})
                v{i} = v{i}{j};
            end
        end
        if not(isempty(v)) && not(isempty(v{1}))
            c{j} = combine(v);
        end
    end
end


function c = combine(v)
    c = v{1};
    l = length(v);
    if isa(c,'sig.signal')
        cfields = c.combinables;
        for i = 1:length(cfields)
            v1 = v{1}.(cfields{i});
            if isa(v1,'sig.axis')
                val = v1;
                val.start = ones(1,l);
                for j = 1:l
                    val.start(j) = v{j}.(cfields{i}).start;
                end
                c.(cfields{i}) = val;
            else
                usecell = 0;
                isdata = isa(c.(cfields{i}),'sig.data');
                val = cell(1,l);
                for j = 1:l
                    val{j} = v{j}.(cfields{i});
                    if isdata
                        val{j} = val{j}.content;
                    end
                    if ~usecell
                        if length(val{j})~=1
                            usecell = 1;
                        end
                    end
                end
                if ~usecell
                    val = cell2mat(val);
                end
                if isdata
                    c.(cfields{i}).content = val;
                else
                    c.(cfields{i}) = val;
                end
            end
        end
        c.celllayers = [{'files'} c.celllayers];
    end
end


function d2 = sortnames(d,d2,n)
    if length(n) == 1
        d2(end+1) = d(1);
        return
    end
    first = zeros(1,length(n));
    for i = 1:length(n)
        if isempty(n{i})
            first(i) = -Inf;
        else
            ni = n{i}{1};
            if ischar(ni)
                first(i) = ni-10058;
            else
                first(i) = ni;
            end
        end
    end
    [o i] = sort(first);
    n = {n{i}};
    d = d(i);
    i = 0;
    while i<length(n)
        i = i+1;
        if isempty(n{i})
            d2(end+1) = d(i);
        else
            dmp = (d(i));
            tmp = {n{i}(2:end)};
            while i+1<=length(n) && n{i+1}{1} == n{i}{1};
                i = i+1;
                dmp(end+1) = d(i);
                tmp{end+1} = n{i}(2:end);
            end
            d2 = sortnames(dmp,d2,tmp);
        end
    end
end