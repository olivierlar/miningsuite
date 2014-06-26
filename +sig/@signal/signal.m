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
        sonify = @sonifier;
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
                
        Sstart
        Srate
        Ssize
        
        Frate
        Fsize
        
        celllayers
        peak
        peakdim
        
        date
        ver
        
        design
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
            
            s.Sstart = options.sstart;
            s.Srate = options.srate;
            s.Ssize = options.ssize;
            
            s.Frate = options.frate;
            
            s.date = date;
            s.ver = ver;
            
            s = after(s,post);
        end
        
        %function x = get.Xaxis(obj)
        %    x = sig.axis(obj.xname,obj.xstart,obj.xunit,0,obj.xsampling);
        %end
        function x = get.xdata(obj)
            if ~obj.xsampling
                x = obj.xstart;
            else
                x = obj.Xaxis.data(obj.Ydata.size('element'));
            end
        end
        
        function s = get.saxis(obj)
            s = sig.axis('time',obj.Sstart*obj.Srate+1,'s',0,1/obj.Srate);
        end
        function s = get.sdata(obj)
            s = obj.saxis.data(obj.Ydata.size('sample'));
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
                f = obj.faxis.data(obj.Ydata.size('frame')) + obj.Fsize;
            end
        end
        function f = get.fcenters(obj)
            if isempty(obj.faxis)
                f = [];
            else
                f = obj.faxis.data(obj.Ydata.size('frame')) + obj.Fsize/2;
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
            p = sig.compute(@peakpos,obj.Ydata,obj.peak,obj.peakdim);
            p = p{1};
        end
        %%
        
        obj = sum(obj,dim)
        obj = center(obj,dim)
        
        obj = resample(obj,sampling)
        obj = extract(obj,param,dim,finder,varargin)
        obj = trim(obj,trimwhere,trimthreshold)
        
        obj = selectfile(obj,index)
        display(obj)
        out = play(obj,varargin)
        playclass(obj,options)
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
end


function options = classoptions(fsize,fhop)
    if nargin < 1
        fsize = .05;
    end
    if nargin < 2
        fhop = .5;
    end
    options = initframes(fsize,fhop);

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
    
        channel.key = {'Channel','Channels'};
        channel.type = 'Numeric';
        channel.default = [];
        channel.when = 'After';
    options.channel = channel;
    
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


function options = initframes(size,hop,inner)
if nargin < 3
    inner = 0;
end

        frame.key = 'Frame';
        frame.type = 'Boolean';
        frame.default = 0;
        %frame.inner = strcmpi(inner,'inner');
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
        fhop.unit = {'s','sp','Hz','/1'};
    options.fhop = fhop;
end
    

%%
function [x type] = init(x,option)
    type = '?';
end


function out = main(x,option,postoption)
    if isempty(postoption)
        out = x;
    else
        out = {after(x{1},postoption)};
    end
end


function obj = after(obj,option)
    if option.channel
        obj = obj.channel(option.channel);
    end
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
end


function d = sonifier(d,varargin)
end


function out = peakpos(d,p,peakdim)
    e = d.select(peakdim,p);
    out = {e};
end