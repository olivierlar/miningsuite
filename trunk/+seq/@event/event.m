classdef event < hgsetget
	properties %(SetAccess = private)
		sequence
        address
        parameter
		previous
		next
        suffix
    end
    properties
        extends
        isprefix
        issuffix
        from
        to
        constructs
        property
    end
	methods
		function obj = event(sequence,param,prev,suffix)
            if nargin<3
                prev = [];
            end
            if nargin<4
                suffix = [];
            end
            obj.sequence = sequence;
            obj.parameter = param;
            obj.previous = prev;
            obj.suffix = suffix;
            %if ~isempty(sequence)
            %    [sequence obj.address] = sequence.inc_counter;
            %end
            if ~isempty(prev)
                prev.connect(obj);
            end
            if ~isempty(sequence)
                sequence.integrate(obj);
            end
        end
        function prev = connect(prev,next)
            prev.next = next;
        end
        %function p = get.parameter(obj)
        %    p = recurs_parameter(obj);
        %end
        function obj = extend(prefix,suffix,param)
            obj = seq.event(prefix.sequence,param,[],suffix);
            obj.extends = prefix;
            prefix.isprefix = [prefix.isprefix obj];
            suffix.issuffix = [suffix.issuffix obj];
            obj.previous = prefix.previous;
            obj.next = suffix.next;
            for i = 1:length(obj.previous)
                obj.previous(i).next = [obj.previous(i).next obj];
            end
            for i = 1:length(obj.next)
                obj.next(i).previous = [obj.next(i).previous obj];
            end
        end
        function l = extent(obj)
            if isa(obj.suffix,'seq.event')
                l = obj.suffix;
            else
                l = obj;
            end
            if ~isempty(obj.isprefix)
                l = [l obj.isprefix(1).extent];
            end
        end
    end
end


%function p = recurs_parameter(obj)
%    if isa(obj.suffix,'seq.event')
%        p = obj.suffix.parameter;
%    else
%        p = obj.suffix;
%    end
%end