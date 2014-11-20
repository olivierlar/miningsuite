classdef paramtype < seq.param
    properties (SetAccess = private)
        fields = {};
    end
    properties
        general
        inter
	end
	methods
        function obj = paramtype(name,fields)
            if nargin < 1
                name = '';
            end
            obj = obj@seq.param(name);
            if nargin > 1
                obj.fields = fields;
            end
        end
        function obj = type2val(obj) %necessary?
            obj = [];
        end
        function obj = common(obj1,obj2,options)
            obj = obj1;
        end
        function [test param] = implies(obj1,obj2,varargin)
            param = obj2;
            if isempty(obj2) || isa(obj2,'seq.paramtype') || ...
                    (isempty(obj2.value) && isempty(obj2.inter) ...
                     && isempty(obj2.general))
                test = true;
            else
                test = false;
                param = [];
            end
        end
        function test = implies_fast(obj1,obj2,varargin)
            test = isempty(obj2) || isa(obj2,'seq.paramtype') || ...
                    (isempty(obj2.value) && isempty(obj2.inter) ...
                     && isempty(obj2.general));
        end
        function test = isdefined(obj)
            test = 0;
        end
        function test = isvaldefined(obj)
            test = 0;
        end
        function test = isinterdefined(obj)
            test = 0;
        end
        function txt = display(obj,varargin)
            txt = '';
        end
	end
end