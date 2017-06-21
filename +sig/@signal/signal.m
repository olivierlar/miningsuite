% SIG.SIGNAL represents any kind of signal data, by encapsulating all 
% relevant information (Exported data includes details of operations and
% settings), and providing standard post-processing operations, as well as
% by sig.evaleach.
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

classdef signal
%%
    properties (Constant)
        signaloptions = @classoptions;
        frameoptions = @initframes;
        default = sig.defaults.get('signal');
        initmethod = @init;
        mainmethod = @main;
        aftermethod = @after;
        %sonify = @sonifier;
    end
    properties
        yname
        yunit
        Ydata
        
        Xaxis
        xname
        xstart
        xunit
        xsampling
        xunsampled
                
        Sstart
        Srate
        Ssize
        
        Frate
        fnumber
        
        celllayers
        peak
        peakprecisepos
        peakpreciseval
        peakdim
        fbchannels
        
        interpolable = 1
        
        date
        ver
        
        design
%         tmpfile
    end
    properties (Dependent)
        %Xaxis
    	xdata
        
        saxis
        sdata
        
        faxis
        fstarts
        fends
        fcenters
        
        %design
        framed
        polyfile
        combinables
        files
        
        peakpos
        peakval
    end
%%
    methods
        function s = signal(varargin)
            [options post] = sig.options(constructoptions,varargin,...
                                         'sig.signal');
            
            data = varargin{1};
            if isnumeric(data)
                data = sig.data(data,{'sample'});
            end
            s.Ydata = data;
            
            s.yname = options.name;
            s.yunit = options.unit;
            
            s.Xaxis = sig.axis(options.xname,options.xstart,...
                               options.xunit,0,options.xsampling);
            s.xname = options.xname;
            s.xstart = options.xstart;
            s.xunit = options.xunit;
            s.xsampling = options.xsampling;
            
            s.xunsampled = options.xdata;
            
            s.Sstart = options.sstart;
            s.Srate = options.srate;
            s.Ssize = options.ssize;
            
            s.Frate = options.frate;
            s.fnumber = options.fnumber;
            
            s.fbchannels = options.fbchannels;
            
            s.date = date;
            s.ver = ver;
            
            if ~isempty(options.deframe)
                s = s.deframe(options.deframe);
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
        
        %function x = get.Xaxis(obj)
        %    x = sig.axis(obj.xname,obj.xstart,obj.xunit,0,obj.xsampling);
        %end
        function x = get.xdata(obj)
            if ~isempty(obj.xunsampled)
                x = obj.xunsampled;
            elseif ~obj.xsampling
                x = obj.xstart;
            else
                x = obj.Xaxis.data(obj.Ydata.size('element'));
            end
        end
        
        function s = get.saxis(obj)
            s = sig.axis('time',obj.Sstart*obj.Srate+1,'s',0,1/obj.Srate);
        end
        function s = get.sdata(obj)
            if ~obj.Srate
                s = obj.xdata(1);
            else
                s = obj.saxis.data(obj.Ydata.size('sample',1));
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
                f = obj.faxis.data(obj.Ydata.size('frame'));
            end
        end
        function f = get.fends(obj)
            if isempty(obj.faxis)
                f = [];
            else
                f = obj.faxis.data(obj.Ydata.size('frame')) + obj.fnumber;
            end
        end
        function f = get.fcenters(obj)
            if isempty(obj.faxis)
                f = [];
            else
                f = obj.faxis.data(obj.Ydata.size('frame')) + obj.fnumber/2;
            end
        end
        
        %function d = get.design(obj)
        %    d = obj.Ydata.design;
        %end
        %function obj = set.design(obj,d)
        %    obj.Ydata.design = d;
        %end
        
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
        function p = get.peakpos(obj)
            if strcmp(obj.peakdim,'sample')
                pos = obj.sdata;
            else
                pos = obj.xdata;
            end
            p = sig.compute(@peakpos,obj.peak,pos);
        end
        function p = get.peakval(obj)
            p = sig.compute(@peakval,obj.peak,obj.Ydata);
        end
        function p = getpeakpos(obj)
            p = obj.peakpos;
            if isempty(p)
                p = [];
                return
            end
            if isa(p,'sig.data')
                for i = 1:length(p)
                    p = squeeze(p.content);
                end
            end
            if length(p) == 1
                p = p{1};
            end
        end
        function v = getpeakval(obj)
            v = obj.peakval;
            if isempty(v)
                v = [];
                return
            end
            if isa(v,'sig.data')
                for i = 1:length(v)
                    v = squeeze(v.content);
                end
            end
            if length(v) == 1
                v = v{1};
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
                    
        obj = sum(obj,dim)
        obj = center(obj,dim)
        obj = halfwave(obj)
        obj = median(obj,field,order,offset)
        
        obj = resample(obj,sampling)
        obj = extract(obj,param,dim,finder,varargin)
        obj = trim(obj,trimwhere,trimthreshold)
        
        obj = selectfile(obj,index)
        display(obj)
        playclass(obj,options)
        
        function func = sonifier(obj)
            func = @sonify;
        end
    end
end


%%
function options = constructoptions
    options = classoptions;

        name.key = 'Name';
        name.type = 'String';
        name.when = 'Both';
        name.default = 'Signal';
    options.name = name;

        unit.key = 'Unit';
        unit.type = 'String';
        unit.default = '';
        unit.when = 'Both';
    options.unit = unit;
    
    
        xname.key = 'XName';
        xname.type = 'String';
        xname.default = '';
        xname.when = 'Both';
    options.xname = xname;

        xunit.key = 'XUnit';
        xunit.type = 'String';
        xunit.default = '';
        xunit.when = 'Both';
    options.xunit = xunit;
    
        xdatamethod.key = 'XDataMethod';
        xdatamethod.type = 'Function';
        xdatamethod.default = @defaultxdatamethod;
    options.xdatamethod = xdatamethod;
    
        xstart.key = 'Xstart';
        xstart.type = 'Numeric';
        xstart.default = 1;
    options.xstart = xstart;
    
        xdata.key = 'Xdata';
        xdata.type = 'Numeric';
        xdata.default = [];
    options.xdata = xdata;
    
        xsampling.key = 'Xsampling';
        xsampling.type = 'Numeric';
        xsampling.default = 0;
    options.xsampling = xsampling;
    
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
    
        fbchannels.key = 'FbChannels';
        fbchannels.default = [];
    options.fbchannels = fbchannels;
    
        deframe.key = 'Deframe';
        deframe.default = [];
    options.deframe = deframe;
end


function [options,frame] = classoptions(mode,fsize,fhop)
    if nargin
        if strcmpi(mode,'FrameAuto')
            options = initframes(fsize,fhop);
        else
            options.frame.auto = 0;
        end
        frame = options.frame;
    else
        frame = [];
    end

        mix.key = 'Mix';
        mix.type = 'String';
        mix.choice = {'Pre','Post','No',0};
        mix.default = 'Pre'; %sig.signal.default.Mix;
        mix.when = 'Both';
    options.mix = mix;

        center.key = 'Center';
        center.type = 'Boolean';
        center.default = sig.signal.default.Center;
        center.when = 'After';
    options.center = center;

%        normal.key = 'Normal';
%        normal.type = 'Boolean';
%        normal.default = 0;
%        normal.when = 'After';
%    options.normal = normal;
    
    %    channel.key = {'Channel','Channels'};
    %    channel.type = 'Numeric';
    %    channel.default = [];
    %    channel.when = 'After';
    %options.channel = channel;
    
        sampling.key = 'Sampling';
        sampling.type = 'Numeric';
        sampling.when = 'Both';
    options.sampling = sampling;

        extract.key = {'Extract','Excerpt'};
        extract.type = 'Unit';
        extract.number = 2;
        extract.default = [];
        extract.unit = {'s','sp'};
        extract.when = 'After';
    options.extract = extract;
    
        trim.key = {'Trim'};
        trim.type = 'Boolean';
        trim.default = 0;
        trim.when = 'After';
    options.trim = trim;
    
        trimwhere.type = 'String';
        trimwhere.choice = {'JustStart','JustEnd','BothEnds'};
        trimwhere.default = 'BothEnds';
        trimwhere.when = 'After';
    options.trimwhere = trimwhere;
    
        trimthreshold.key = 'TrimThreshold';
        trimthreshold.type = 'Numeric';
        trimthreshold.default = .06;
        trimthreshold.when = 'After';
    options.trimthreshold = trimthreshold;
end


function options = initframes(size,hop)
        frame.auto = 1;
        frame.key = 'Frame';
        frame.type = 'Boolean';
        frame.default = 0;
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
    type = 'sig.signal';
end


function out = main(x,option,postoption)
    if isempty(postoption)
        out = x;
    else
        out = {after(x{1},postoption)};
    end
end


function obj = after(obj,option)
    %if option.channel
    %    obj = obj.channel(option.channel);
    %end
    if strcmpi(option.mix,'Post')
        obj = obj.sum('channel');
    end

    if option.center
        obj = obj.center('sample');
    end
    if option.sampling
        obj = obj.resample(option.sampling);
    end
    if ~isempty(option.extract)
        obj = obj.extract(option.extract,'sample','saxis','Ydata');
    end
    if option.trim
        obj = obj.trim(option.trimwhere,option.trimthreshold);
    end
    %if option.median
    %    order = round(option.median(1) * obj.sampling);
    %    obj = obj.median('sample',order,option.median(2));
    %end
end


function [d,sr] = sonify(d,sr)
end


function out = peakpos(d,p)
    d = d.apply(@peakroutine,{p},{'element'},1,'{}');
    out = {d};
end


function out = peakval(d,v)
    d = d.apply(@peakroutine,{v},{'element'},1,'{}');
    out = {d};
end


function d = peakroutine(d,v)
    d = v(d);
    d = d(:);
end