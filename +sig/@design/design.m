% SIG.DESIGN CLASS
% stores the whole dataflow design, which is evaluated only when the user
% wants to display the results.
% Internally called by sig.operate and seq.Sequence.
%
% Copyright (C) 2014, 2017-2019 Olivier Lartillot
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
        after
        
        options
        
        combine
        
        evaluate = 0;
        evaluated

        date
        ver
        
        extensive = 0
        nochunk = 0
        overlap = struct('value',0,'unit','sp');
        files
        symbolicinput = 0;
        variable_options = 0
    end
%%
    methods
        function obj = design(pack,name,input,type,main,after,options,...
                              combine,argin,extract,extensive,nochunk,...
                              variable_options)
            if nargin < 13
                variable_options = [];
            end
            obj.package = pack;
            obj.name = name;
            obj.input = input;
            obj.type = type;
            obj.main = main;
            obj.after = after;
            obj.options = options;
            if nargin>7
                obj.combine = combine;
                obj.argin = argin;
                obj.extract = extract;
                obj.date = date;
                obj.ver = 0; %ver;
                obj.extensive = extensive;
                obj.nochunk = nochunk;
                obj.variable_options = variable_options;
            end
            if iscell(input)
                input = input{1};
            end
            if ischar(input)
                obj.files = input;
            else
                obj.files = input.files;
            end
            if isa(input,'sig.design')
                obj.files = input.files;
            end
        end
        function res = istype(obj,type,pos)
            if iscell(obj.type)
                if nargin < 3
                    pos = 1;
                end
                res = strcmpi(obj.type{pos},type);
            else
                res = strcmpi(obj.type,type);
            end
        end
        function out = eval(obj,arg,nargout)
            if strcmpi(obj.files,'Folder')
                disp(arg)
            end
            if nargin<2
                arg = obj.files;
            end
            if nargin<3
                nargout = 1;
            end

            if strcmpi(obj.package,'vid')
                v = VideoReader(arg);
                out = vid.evaleach(obj,arg,v,nargout);
            elseif strcmpi(obj.package,'phy')
                d = phy.mcread(arg);
                out = phy.evaleach(obj,arg,d,nargout);
            else
                [sz,sr] = audiofileinfo(arg);
                if isempty(sz)
                    w = [];
                elseif isempty(obj.extract)
                    w = [1;sz];
                else
                    interval = obj.extract.value(:);
                    if strcmpi(obj.extract.unit,'s')
                        interval = round(interval*sr) + 1;
                    end
                    w = min(max(interval,1),sz);
                end
                out = sig.evaleach(obj,arg,w,sr,nargout);
            end
        end
        %%
        function out = display(obj,recurs)
            if obj.evaluate
                if strcmpi(obj.files,'Folder') || ...
                   strcmpi(obj.files,'Folders')
                    [nfiles,files] = folderinfo('',[],0,[],[],{},...
                                            strcmpi(obj.files,'Folders'),...
                                            strcmpi(obj.package,'vid'));
                    if nfiles == 0
                        if strcmpi(obj.package,'vid')
                            disp('No video file detected in this folder.');
                        else
                            sig.warning('sig.eval','No sound file detected in this folder.')
                        end
                        out = {{}};
                        return
                    end
                    for i = 1:length(files)
                        out = obj.eval(files{i},1);
                        if ~isempty(out) && isa(out{1},'sig.Signal')
                            out{1}.display;
                        end
                    end
                else
                    out = obj.eval(obj.files,1);
                    for i = length(out):-1:1
                        if isa(out{i},'mus.Sequence')
                            out{i}.display;
                        elseif isa(out{i},'sig.Signal')
                            out{i}.display;
                        end
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
            if iscell(out) && length(out) == 1
                out = out{1};
            end
            sig.recent(out);
        end
        function d = getdata(obj)
            v = obj.eval;
            d = v{1}.getdata;
        end
        function p = getpeakpos(obj)
            v = obj.eval;
            p = v{1}.getpeakpos;
        end
        function v = getpeakval(obj)
            v = obj.eval;
            v = v{1}.getpeakval;
        end
        function r = get(obj,field)
            v = obj.eval;
            r = v{1}.get(field);
        end
        function show(obj,varargin)
            obj = obj(1);
            if isempty(obj.input)
                return
            end
            input = obj.input;
            if iscell(input)
                input = input{1};
            end
            if isa(input,'sig.design')
                input.show(0);
            elseif isa(input,'sig.Signal')
                disp(['> ',class(input)]);
            end
            str = '';
            for i = 1:length(obj.argin)
                arg = obj.argin{i};
                if isnumeric(arg)
                    arg = num2str(arg);
                elseif isa(arg,'sig.design')
                    arg = '(sig.design)';
                else
                    arg = ['''',arg,''''];
                end
                str = [str ', ' arg];
            end
            if ischar(input)
                disp('--------')
                input = ['''' input ''''];
            else
                %disp(' ')
                input = '...';
            end
            disp(['> ',obj.package,'.',obj.name,' ( ',input,str,' )']);
            disp(obj.options)
%             if nargin < 2
%                 disp(['Design date: ' obj.date])
%                 for i = 1:length(obj.ver)
%                     if strcmp(obj.ver(i).Name,'The MiningSuite')
%                         disp(['using The MiningSuite version ',obj.ver(i).Version])
%                         break
%                     end
%                 end
%             end
        end
        function obj = previous(obj,n)
            obj = obj.input;
            if nargin > 1 && n > 1
                obj = obj.previous(n-1);
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
%function f = getfiles(obj)
%    f = obj.input;
%    if isa(f,'sig.design')
%        f = getfiles(f);
%    elseif isa(f,'sig.Signal')
%        f = getfiles(f.design);
%    end
%end
        

function [l,a] = folderinfo(path,s,l,sz,sr,a,folders,video)
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
                [l,a] = folderinfo([path nf],s,l,sz,sr,a,1,video);
                cd ..
            end
        else
            if video
                di = [];
                try
                    di = VideoReader(nf);
                    if ~di.FrameRate
                        di = [];
                    end
                end
            else
                di = audiofileinfo(nf);
            end
            if not(isempty(di))
                l = l+1;
                a{l} = [path nf];
            end
        end
    end
end


function [sz,sr] = audiofileinfo(file)
    sz = [];
    sr = [];
    try
        info = audioinfo(file);
        sz = info.TotalSamples;
        sr = info.SampleRate;
    catch
        fid = fopen(file);
        if fid >= 0
            sz = 0;
        end
    end
end


function d2 = sortnames(d,d2,n)
    if length(n) == 1
        if isempty(d2)
            d2 = d(1);
        else
            d2(end+1) = d(1);
        end
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
            if isempty(d2)
                d2 = d(i);
            else
                d2(end+1) = d(i);
            end
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