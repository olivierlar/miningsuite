% SIG.SIGNAL class
% represents any kind of signal data, by encapsulating all relevant
% information (Exported data includes details of operations & settings),
% and providing standard post-processing operations, as well as by
% sig.evaleach.
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
classdef Signal
%%
    properties (Constant)
        signaloptions = initoptions;
        frameoptions = @initframes;
        default = sig.defaults.get('Signal');
        initmethod = @init;
        mainmethod = @main;
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
                
        Sstart = 0;
        Srate = 0;
        Ssize = 0;
        
        Frate = 0;
        Fsize = 0;
        
        celllayers
        peak
        peakdim
        
        date
        ver
    end
    properties (Dependent)
        %Xaxis
    	xdata
        
        Saxis
        sdata
        
        Faxis
        fstarts
        fends
        fcenters
        
        design
        framed
        polyfile
        combinables
        files
        
        peakpos
    end
%%
    methods
        function s = Signal(data,name,unit,...
                            xname,xunit,xsampling,xstart,...
                            srate,sstart,ssize,frate)
            if nargin<2
                name = 'Signal';
            end
            if nargin<3
                unit = '';
            end
            
            s.Ydata = data;
            s.yname = name;
            s.yunit = unit;
            
            s.Xaxis = sig.axis(xname,xstart,xunit,0,xsampling);
            s.xname = xname;
            s.xstart = xstart;
            s.xunit = xunit;
            s.xsampling = xsampling;
            
            %if nargin<4
            %    xname = '';
            %end
            %if nargin<5
            %    xunit = '';
            %end
            %if nargin<6
            %    xsampling = 0;
            %end
            %if nargin<7
            %    xstart = 1;
            %end
            %if nargin<8
            %    srate = 0;
            %end
            %if nargin<9
            %    sstart = 1;
            %end
            if nargin<10
                ssize = 0;
            end
            if nargin<11
                frate = 0;
            end
                        
            s.Sstart = sstart;
            s.Srate = srate;
            s.Ssize = ssize;
            
            s.Frate = frate;
            
            s.date = date;
            s.ver = ver;
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
        
        function s = get.Saxis(obj)
            s = sig.axis('time',obj.Sstart*obj.Srate+1,'s',0,1/obj.Srate);
        end
        function s = get.sdata(obj)
            s = obj.Saxis.data(obj.Ydata.size('sample'));
        end
        
        function f = get.Faxis(obj)
            if obj.Frate
                f = sig.axis('time',1,'s',0,1/obj.Frate);
            else
                f = [];
            end
        end
        function f = get.fstarts(obj)
            if isempty(obj.Faxis)
                f = [];
            else
                f = obj.Faxis.data(obj.Ydata.size('frame'));
            end
        end
        function f = get.fends(obj)
            if isempty(obj.Faxis)
                f = [];
            else
                f = obj.Faxis.data(obj.Ydata.size('frame')) + obj.Fsize;
            end
        end
        function f = get.fcenters(obj)
            if isempty(obj.Faxis)
                f = [];
            else
                f = obj.Faxis.data(obj.Ydata.size('frame')) + obj.Fsize/2;
            end
        end
        
        function d = get.design(obj)
            d = obj.Ydata.design;
        end
        function obj = set.design(obj,d)
            obj.Ydata.design = d;
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
        function p = get.peakpos(obj)
            p = sig.compute(@peakpos,obj.Ydata,obj.peak,obj.peakdim);
            p = p{1};
        end
        %%
        function obj = after(obj,option)
            if option.name
                obj.name = option.name;
            end
            if option.unit
                obj.unit = option.unit;
            end
            if option.xname
                obj.xname = option.xname;
            end
            if option.xunit
                obj.xunit = option.xunit;
            end
            %if option.xstart
            %    obj.Xaxis.start = option.xstart;
            %end
            %if option.fstart
            %    obj.Faxis.start = option.fstart;
            %end
            
            if option.channel
                obj = obj.channel(option.channel);
            end
            if option.mix
                obj = obj.sum('channel');
            end

            if option.center
                obj = obj.center('sample');
            end
            if option.sampling
                obj = obj.resample(option.sampling);
            end
            if ~isempty(option.extract)
                obj = obj.extract(option.extract,'sample','Saxis','Ydata');
            end
            if option.trim
                obj = obj.trim(option.trimwhere,option.trimthreshold);
            end
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
function options = initoptions
    options = initframes(.05,.5);

        name.key = 'Name';
        name.type = 'String';
        name.when = 'Both';
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
        sstart.default = 1;
    options.sstart = sstart;
    
        srate.key = 'Srate';
        srate.type = 'Numeric';
        srate.default = 0;
    options.srate = srate;

        ssize.key = 'Ssize';
        ssize.type = 'Numeric';
        ssize.default = 0;
    options.ssize = ssize;

        frate.key = 'Frate';
        frate.type = 'Numeric';
        frate.default = 0;
    options.frate = frate;
    

        mix.key = 'Mix';
        mix.type = 'Boolean';
        mix.default = sig.Signal.default.Mix;
        mix.when = 'After';
    options.mix = mix;

        center.key = 'Center';
        center.type = 'Boolean';
        center.default = sig.Signal.default.Center;
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
        out = {x{1}.after(postoption)};
    end
end


function d = sonifier(d,varargin)
end


function out = peakpos(d,p,peakdim)
    e = d.select(peakdim,p);
    out = {e};
end