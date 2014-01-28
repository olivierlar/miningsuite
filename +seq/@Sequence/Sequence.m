classdef Sequence
%%
    properties (Constant)
        sequenceoptions = initoptions;
        default = sig.defaults.get('Sequence');
        initmethod = @init;
        mainmethod = @main;
        sonify = @sonifier;
    end
    properties
        content
        design
        name
        date
        ver
        celllayers
        files
    end
    properties (Dependent)
        polyfile
    end
%%
    methods
        function s = Sequence(content,name,date,ver)
            if nargin<1
                content = [];
            end
            if nargin<2
                name = 'Sequence';
            end
            if nargin<3
                date = [];
            end
            if nargin<4
                ver = [];
            end
            s.content = content;
            s.name = name;
            s.date = date;
            s.ver = ver;
        end
        
        function b = get.polyfile(obj)
            b = ~isempty(obj.celllayers) && strcmp(obj.celllayers,'files');
        end
       
        function obj = integrate(obj,event)
            if iscell(obj.files)
                obj.content{end} = [obj.content{end} {event}];
            else
                obj.content = [obj.content {event}];
            end
        end
        
        %%
        function obj = after(obj,option)
            if option.name
                obj.name = option.name;
            end
            if option.channel
                obj = obj.channel(option.channel);
            end
            if option.mix
                obj = obj.sum('channel');
            end

            if ~isempty(option.extract)
                obj = obj.extract(option.extract);
            end
            if option.trim
                obj = obj.trim(option.trimwhere,option.trimthreshold);
            end
        end
        %%
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
        name.key = 'Name';
        name.type = 'String';
        name.when = 'Both';
    options.name = name;

        channel.key = {'Channel','Channels'};
        channel.type = 'Numeric';
        channel.default = [];
        channel.when = 'After';
    options.channel = channel;
    
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