% VID.VIDEO
%
% Copyright (C) 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

classdef Video
%%
    properties (Constant)
        videooptions = @classoptions;
        frameoptions = @initframes;
        initmethod = @init;
        mainmethod = @main;
        aftermethod = @after;
    end
    properties
        Ydata
                
        Sstart
        Srate
        Ssize
        
        Frate
        fnumber
        
        celllayers
        
        date
        ver
        
        design
    end
    properties (Dependent)
        saxis
        sdata
        
        faxis
        fstarts
        fends
        fcenters
        
        polyfile
        combinables
        files
    end
%%
    methods
        function v = Video(varargin)
            [options post] = sig.options(constructoptions,varargin,...
                                         'vid.Video');
            
            data = varargin{1};
            if isnumeric(data)
                data = sig.data(data,{'sample'});
            end
            v.Ydata = data;
            
            v.Sstart = options.sstart;
            v.Srate = options.srate;
            v.Ssize = options.ssize;
            
            v.Frate = options.frate;
            v.fnumber = options.fnumber;
            
            v.date = date;
            v.ver = 0; %ver;
            
            if ~isempty(options.deframe)
                v = v.deframe(options.deframe);
            end
        end
        
        function d = getdata(obj)
            d = obj.Ydata;
            if isempty(d)
                d = [];
                return
            end
            if ~iscell(d)
                d = {d};
            end
            if isa(d{1},'sig.data')
                for i = 1:length(d)
                    d{i} = squeeze(d{i}.content);
                end
            end
            if length(d) == 1
                d = d{1};
            end
        end
        
        function s = get.saxis(obj)
            s = sig.axis('time',obj.Sstart*obj.Srate+1,'s',0,1/obj.Srate);
        end
        function s = get.sdata(obj)
            if ~obj.Srate
                s = obj.xdata(1);
            else 
                ysize = obj.Ydata.size('sample',1);
                if iscell(ysize)
                    s = cell(1,length(ysize));
                    for i = 1:length(ysize)
                        s{i} = obj.saxis.data([1 ysize{i}],i);
                    end
                else
                    s = obj.saxis.data([1 ysize]);
                end
            end
        end
        
        function f = get.faxis(obj)
            if obj.Frate
                f = sig.axis('time',1,'s',0,1/obj.Frate);
            else
                f = [];
            end
        end
        function f = get.fstarts(obj)
            if isempty(obj.faxis)
                f = [];
            else
                f = obj.faxis.data([1 obj.Ydata.size('frame')]);
            end
        end
        function f = get.fends(obj)
            if isempty(obj.faxis)
                f = [];
            else
                f = obj.faxis.data([1 obj.Ydata.size('frame')]) + obj.fnumber;
            end
        end
        function f = get.fcenters(obj)
            if isempty(obj.faxis)
                f = [];
            else
                f = obj.faxis.data([1 obj.Ydata.size('frame')]) + obj.fnumber/2;
            end
        end
        
        function b = get.polyfile(obj)
            b = ~isempty(obj.celllayers) && strcmp(obj.celllayers,'files');
        end
        function c = get.combinables(obj)
            c = {};
            meta = metaclass(obj);
            prop = meta.Properties;
            for i = 1:length(prop)
                field = prop{i}.Name;
                if isstrprop(field(1),'upper')
                    c{end+1} = field;
                end
            end
        end
        function f = get.files(obj)
            d = obj.design;
            if isempty(d)
                f = {};
            else
                f = obj.design.files;
            end
        end    
        function b = istype(obj,type)
            b = strcmp(class(obj),type);
        end
        %%
        
        function obj = deframe(obj,in)
            obj.Srate = in.Frate;
            
            if iscell(in.sdata)
                Sstart = zeros(1,length(in.sdata));
                Ssize = zeros(1,length(in.sdata));
                for i = 1:length(in.sdata)
                    Sstart(i) = in.sdata{i}(1);
                    Ssize(i) = size(in.Ydata.content{i},1);
                end
            else
                Sstart = in.sdata(1);
                Ssize = size(in.Ydata.content,1);
            end
            obj.Sstart = Sstart;
            obj.Ssize = Ssize / in.Srate;
        end
                    
%         obj = sum(obj,dim)
%         obj = center(obj,dim)
%         
%         obj = resample(obj,sampling)
%         obj = extract(obj,param,dim,finder,varargin)
%         obj = trim(obj,trimwhere,trimthreshold)
        
        obj = selectfile(obj,index)
        display(obj)
        playclass(obj,options)
    end
end


%%
function options = constructoptions
    options = classoptions;

        name.key = 'Name';
        name.type = 'String';
        name.default = 'Signal';
    options.name = name;

        sstart.key = 'Sstart';
        sstart.type = 'Numeric';
        sstart.default = 0;
    options.sstart = sstart;
    
        srate.key = 'Srate';
        srate.type = 'Numeric';
        srate.default = 1;
    options.srate = srate;

        ssize.key = 'Ssize';
        ssize.type = 'Numeric';
        ssize.default = 0;
    options.ssize = ssize;

        frate.key = 'Frate';
        frate.type = 'Numeric';
        frate.default = 0;
    options.frate = frate;
        
        fnumber.key = 'fnumber';
        fnumber.type = 'Numeric';
        fnumber.default = 0;
    options.fnumber = fnumber;
    
        deframe.key = 'Deframe';
        deframe.default = [];
    options.deframe = deframe;
end


function [options,frame] = classoptions(mode,fsize,fhop,when)
    if nargin
        if nargin > 1
            if nargin < 4
                when = 'During';
            end
            options = initframes(fsize,fhop,when);
            options.frame.auto = strcmpi(mode,'FrameAuto');
        else
            options.frame.auto = 0;
        end
        frame = options.frame;
    else
        frame = [];
    end
    
        motion.key = 'Motion';
        motion.type = 'Boolean';
    options.motion = motion;

%         center.key = 'Center';
%         center.type = 'Boolean';
%         center.default = sig.Signal.default.Center;
%     options.center = center;
%     
%         sampling.key = 'Sampling';
%         sampling.type = 'Numeric';
%     options.sampling = sampling;
% 
%         extract.key = {'Extract','Excerpt'};
%         extract.type = 'Unit';
%         extract.number = 2;
%         extract.default = [];
%         extract.unit = {'s','sp'};
%     options.extract = extract;
%     
%         trim.key = {'Trim'};
%         trim.type = 'Boolean';
%         trim.default = 0;
%     options.trim = trim;
%     
%         trimwhere.type = 'String';
%         trimwhere.choice = {'JustStart','JustEnd','BothEnds'};
%         trimwhere.default = 'BothEnds';
%     options.trimwhere = trimwhere;
%     
%         trimthreshold.key = 'TrimThreshold';
%         trimthreshold.type = 'Numeric';
%         trimthreshold.default = .06;
%     options.trimthreshold = trimthreshold;
end


function options = initframes(size,hop,when)
        frame.auto = 1;
        frame.key = 'Frame';
        frame.type = 'Boolean';
        frame.default = 0;
        frame.when = when;
    options.frame = frame;
    
        fsize.key = 'FrameSize';
        fsize.type = 'Unit';
        fsize.default.unit = 's';
        fsize.default.value = size;
        fsize.unit = {'s','sp'};
    options.fsize = fsize;

        fhop.key = 'FrameHop';
        fhop.type = 'Unit';
        fhop.default.unit = '/1';
        fhop.default.value = hop;
        fhop.unit = {'/1','s','sp','Hz'};
    options.fhop = fhop;
    
        frameconfig.key = 'FrameConfig';
        frameconfig.type = 'Other';
    options.frameconfig = frameconfig;
end
    

%%
function [x type] = init(x,option,frame)
    type = 'vid.Video';
end


function out = main(x,option)
    out = x;
end


function obj = after(obj,option)
    if isfield(option,'motion') && option.motion
        if size(obj.Ydata.content,4) > 1
            obj.Ydata.content(:,:,:,3) = diff(obj.Ydata.content(:,:,:,1:2),1,4);
        end
    end

%     if option.center
%         obj = obj.center('sample');
%     end
%     if option.sampling
%         obj = obj.resample(option.sampling);
%     end
%     if ~isempty(option.extract)
%         obj = obj.extract(option.extract,'sample','saxis','Ydata');
%     end
%     if option.trim
%         obj = obj.trim(option.trimwhere,option.trimthreshold);
%     end
end