% SIG.DATA class adds a syntactic layer on top of Matlab that makes 
% operators' code simpler.
% Internally called by all operators available to users in SigMinr,
% AudMinr, VocMinr and audio-based approaches in MusMinr, as well as by
% sig.read
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

classdef data
%%
    properties
        content
        %design
        dims
        %layers
    end
%%
    methods
        [args content] = scanargin(obj,argin)
    end
%%
    methods
        function obj = data(content,dims)%,layers)
            %if nargin<3
            %    layers = {};
            %end
            obj.content = content;
            obj.dims = dims;
            %obj.layers = layers;
        end
        
        %%        
        function obj = rename(obj,dim1,dim2)
            for i = 1:length(obj.dims)
                if strcmp(obj.dims{i},dim1)
                    obj.dims{i} = dim2;
                    return
                end
            end
        end
        
        function obj = deframe(obj)
            obj = obj.rename('element','nothing');
            obj = obj.rename('sample','element');
            obj = obj.rename('frame','sample');
        end
        
        function obj = reframe(obj)
            obj = obj.rename('sample','frame');
            obj = obj.rename('element','sample');
        end
        
        function obj = zeros(obj,varargin)
            s = size(obj.content);
            for i = 1:length(varargin)
                obj = obj.rename(varargin{i}{1},varargin{i}{2});
                if length(varargin{i}) > 2
                    d = obj.whichdim(varargin{i}{2});
                    s(d) = varargin{i}{3};
                end
            end
            obj.content = zeros(s);
        end
        
        function dim = whichdim(obj,dimname)
            dim = [];
            for i = 1:length(obj.dims)
                dimi = obj.dims{i};
                if strcmp(dimi,dimname)
                    dim = i;
                    return
                end
                [numindx number] = regexp(dimi,'\d','start','match');
                if ~isempty(number)
                    number = str2double([number{:}]);
                    dimi(numindx) = [];
                    if strcmp(dimi,dimname)
                        dim(number) = i;
                    end
                end
            end
        end
        
        function s = size(obj,field)
            if nargin<2
                field = 'element';
            end
            dim = obj.whichdim(field);
            if isempty(dim)
                s = 1;
                return
            end
            s = zeros(1,length(dim));
            for i = 1:length(dim)
                s(i) = size(obj.content,dim(i));
            end
        end
                
        function obj = concat(obj,obj2,field)
            if nargin<3
                field = 'element';
            end
            dim = obj.whichdim(field);
            obj.content = cat(dim,obj.content,obj2.content);
        end
        
        
        function obj = concat_sample(obj,obj2)
            obj = concat(obj,obj2,'sample');
        end
        
        %function obj = zeros(obj,datasize)
        %    s = size(obj.content);
        %    if nargin>1
        %        s(obj.whichdim('element')) = datasize;
        %    end
        %    obj.content = zeros(s);
        %end
                
        function content = view(obj,varargin)
            args = scanargin(obj,varargin);
            content = subsref(obj.content,args);
        end
                
        function obj = edit(obj,varargin)
            data = varargin{end};
            if isa(data,'sig.data')
                data = data.content;
            end
            args = scanargin(obj,varargin(1:end-1));
            obj.content = subsasgn(obj.content,args,data);
            %eval(['obj.content(',args,') = content;']);
        end
        
        function obj = extract(obj,varargin)
            args = scanargin(obj,varargin);
            obj.content = subsref(obj.content,args);
            %eval(['obj.content = obj.content(',args,');']);
        end
        %%
        function obj = sum(obj,field)
            if nargin<2
                field = 'element';
            end
            dim = obj.whichdim(field);
            for i = 1:length(dim)
                obj.content = sum(obj.content,dim(i));
            end
        end
        
        function obj = mean(obj,field)
            if nargin<2
                field = 'element';
            end
            dim = obj.whichdim(field);
            for i = 1:length(dim)
                obj.content = mean(obj.content,dim(i));
            end
        end
        function obj = center(obj,field)
            if nargin<2
                field = 'element';
            end
            m = obj.mean(field);
            obj.content = bsxfun(@minus,obj.content,m.content);
        end
        function obj = hwr(obj)
            obj.content = (obj.content + abs(obj.content)) / 2;
        end
        function obj = max(obj,field)
            if nargin<2
                field = 'element';
            end
            dim = obj.whichdim(field);
            for i = 1:length(dim)
                obj.content = max(obj.content,[],dim(i));
            end
        end
        
        function obj = flip(obj,field)
            if nargin<2
                field = 'element';
            end
            dim = obj.whichdim(field);
            for i = 1:length(dim)
                obj.content = flipdim(obj.content,dim(i));
            end
        end
        %%
        function obj = format(obj,dims)
            found = zeros(1,length(obj.dims));
            different = 0;
            for i = 1:length(obj.dims)
                foundi = find(strcmpi(obj.dims{i},dims));
                if isempty(foundi)
                    dims{end+1} = obj.dims{i};
                    found(i) = length(dims);
                else
                    found(i) = foundi;
                end
                if ~different && found(i)~=i
                    different = 1;
                end
            end
            if different
                if length(found) < max(found)
                    for i = 1:length(found)
                        if ~ismember(i,found)
                            found(end+1) = i;
                            obj.dims{end+1} = dims{i};
                        end
                    end
                end
                obj.content = permute(obj.content,found);
                obj.dims = obj.dims(found);
            end
        end
        function obj1 = bsxfun(obj1,obj2,func)
            if isa(obj2,'sig.data')
                obj2 = format(obj2,obj1.dims);
                d = obj2.content;
            else
                d = obj2;
            end
            obj1.content = bsxfun(func,obj1.content,d);
        end
        function obj1 = plus(obj1,obj2)
            obj1 = obj1.bsxfun(obj2,@plus);
        end
        function obj1 = minus(obj1,obj2)
            obj1 = obj1.bsxfun(obj2,@minus);
        end
        function obj1 = times(obj1,obj2)
            obj1 = obj1.bsxfun(obj2,@times);
        end
        function obj1 = divide(obj1,obj2)
            if isa(obj2,'sig.data')
                obj1 = obj1.bsxfun(obj2,@rdivide);
            else
                obj1.content = obj1.content/obj2;
            end
        end
        
        function d = findglobal(obj,func)
            d = obj.content;
            for i = 1:length(size(d))
                d = func(d,[],i);
            end
        end
        
        [obj varargout] = apply(obj,func,argin,dimfunc,ndimfunc,varargin)
        obj = select(obj,pos,dim,type)
        
        obj = frame(obj,param,sr)
        
        obj = median(obj,field,order,offset)
    end
end