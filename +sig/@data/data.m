% SIG.DATA CLASS adds a syntactic layer on top of Matlab that makes 
% operators' code simpler.
% Internally called by all operators available to users in SigMinr,
% AudMinr, VocMinr and audio-based approaches in MusMinr, as well as by
% sig.read
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

classdef data
%%
    properties
        content
        dims
        layers = 1
        multioutput = 0;
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
            for i = 1:length(obj.dims)
                if strcmp(obj.dims{i},'sample')
                    obj = obj.rename('element','nothing');
                    obj.dims{i} = 'element';
                    break
                end
            end
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
        
        function s = size(obj,field,option)
            if nargin<2
                field = 'element';
            end
            if nargin<3
                option = 0;
            end
            dim = obj.whichdim(field);
            if isempty(dim)
                s = 1;
                return
            end
            if (option && obj.multioutput) || ...
                    (obj.layers == 2 && iscell(obj.content))
                s = cell(1,length(obj.content));
                for j = 1:length(obj.content)
                    s{j} = zeros(1,length(dim));
                    for i = 1:length(dim)
                        s{j}(i) = size(obj.content{j},dim(i));
                    end
                end
            else
                s = zeros(1,length(dim));
                for i = 1:length(dim)
                    s(i) = size(obj.content,dim(i));
                end
            end
        end
                
        function obj = concat(obj,obj2,field,from)
            if nargin<3
                field = 'element';
            end
            dim = obj.whichdim(field);
            if nargin>3 && from
                l1 = obj.size(field);
                obj = obj.extract(field,[1,l1-from]);
                l2 = obj2.size(field);
                obj2 = obj2.extract(field,[from+1,l2]);
            end
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
            if obj.layers == 1
                content = subsref(obj.content,args);
            elseif obj.layers == 2
                for i = 1:length(obj.content)
                    content{i} = subsref(obj.content{i},args);
                end
            end
        end
        
        function obj = edit(obj,varargin)
            data = varargin{end};
            if isa(data,'sig.data')
                data = data.content;
            end
            args = scanargin(obj,varargin(1:end-1));
            obj.content = subsasgn(obj.content,args,data);
        end
        
        function obj = extract(obj,varargin)
            args = scanargin(obj,varargin);
            if obj.layers == 1
                obj.content = subsref(obj.content,args);
            elseif obj.layers == 2
                for i = 1:length(obj.content)
                    obj.content{i} = subsref(obj.content{i},args);
                end
            end
        end
        %%
        function obj = sum(obj,field,adjacent)
            if nargin<3
                adjacent = 1;
            end
            if nargin<2
                field = 'element';
            end
            dim = obj.whichdim(field);
            if isempty(dim)
                return
            end
            for i = 1:length(dim)
                if adjacent < 2
                    obj.content = sum(obj.content,dim(i));
                else
                    nc1 = size(obj.content,dim(i));
                    nc2 = ceil(nc1/adjacent);
%                     res = zeros(size(dh{i},1),size(dh{i},2),nc2);
                    for j = 1:nc2
                        d = obj.extract(field,[(j-1)*adjacent+1,min(j*adjacent,nc1)]);
                        d = d.sum(field);
                        if j == 1
                            res = d;
                        else
                            res = res.concat(d,field);
                        end
                    end
                    obj = res;
                end
            end
            if adjacent < 2
                obj.dims(dim) = [];
                order = 1:length(size(obj.content));
                if length(order) >= dim
                    order(dim) = [];
                end
                order(end+1) = dim;
                obj.content = permute(obj.content,order);
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
            found = zeros(1,length(dims));
            different = 0;
            for i = 1:length(dims)
                foundi = find(strcmpi(dims{i},obj.dims));
                if isempty(foundi)
                    obj.dims{end+1} = dims{i};
                    found(i) = length(obj.dims);
                else
                    found(i) = foundi;
                end
                if ~different && found(i)~=i
                    different = 1;
                end
            end
            if different
                ndims = length(size(obj.content));
                if length(found) < ndims
                    for i = 1:ndims
                        if ~ismember(i,found)
                            found(end+1) = i;
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
            if verLessThan('matlab', 'R2016b')
                obj1 = obj1.bsxfun(obj2,@plus);
            else
                if isa(obj2,'sig.data')
                    obj2 = format(obj2,obj1.dims);
                    d = obj2.content;
                else
                    d = obj2;
                end
                obj1.content = obj1.content + d;
            end
        end
        function obj1 = minus(obj1,obj2)
            if verLessThan('matlab', 'R2016b')
                obj1 = obj1.bsxfun(obj2,@minus);
            else
                if isa(obj2,'sig.data')
                    obj2 = format(obj2,obj1.dims);
                    d = obj2.content;
                else
                    d = obj2;
                end
                obj1.content = obj1.content - d;
            end
        end
        function obj1 = times(obj1,obj2)
            if verLessThan('matlab', 'R2016b')
                obj1 = obj1.bsxfun(obj2,@times);
            else
                if isa(obj2,'sig.data')
                    obj2 = format(obj2,obj1.dims);
                    d = obj2.content;
                else
                    d = obj2;
                end
                obj1.content = obj1.content .* d;
            end
        end
        function obj1 = divide(obj1,obj2)
            if isa(obj2,'sig.data')
                if verLessThan('matlab', 'R2016b')
                    obj1 = obj1.bsxfun(obj2,@rdivide);
                else
                    if isa(obj2,'sig.data')
                        obj2 = format(obj2,obj1.dims);
                        d = obj2.content;
                    else
                        d = obj2;
                    end
                    obj1.content = obj1.content ./ d;
                end
            else
                if isa(obj2,'sig.data')
                    obj2 = format(obj2,obj1.dims);
                    d = obj2.content;
                else
                    d = obj2;
                end
                obj1.content = obj1.content / d;
            end
        end
        function b = isempty(obj)
            b = isempty(obj.content);
        end
        
        function d = findglobal(obj,func)
            d = obj.content;
            for i = 1:length(size(d))
                d = func(d,[],i);
            end
        end
        
        [obj varargout] = apply(obj,func,argin,dimfunc,ndimfunc,varargin)
        obj = select(obj,pos,dim,type)
                
        obj = median(obj,field,order,offset)
    end
end