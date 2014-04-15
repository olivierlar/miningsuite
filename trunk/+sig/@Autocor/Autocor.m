% sig.Autocor class
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Autocor < sig.Spectrum
%%
    properties
        normalized = 0;
        window
    end
%%
    methods
        function s = Autocor(varargin)
          	s = s@sig.Spectrum(varargin{:});
            if strcmp(s.yname,'Spectrum')
                s.yname = 'Autocor';
            end
            s.Xaxis.subunit = sig.subunit('Frequency','Hz',@time2freq);
            s.xname = 'Lag';
            s.xunit = 's';
        end
        %%
        function obj = after(obj,option)
            obj = after@sig.Spectrum(obj,option);
            
            if option.freq
                obj.Xaxis.name = 'Frequency';
            else
                obj.Xaxis.name = 'Time';
            end

            if isstruct(option.min) || isstruct(option.max)
                if ~isstruct(option.min)
                    option.min.value = -Inf;
                    option.min.unit = 's';
                end
                if ~isstruct(option.max)
                    option.max.value = Inf;
                    option.max.unit = 's';
                end
                param.value = [option.min.value,option.max.value];
                param.unit = option.min.unit;
                obj = obj.extract(param,'element','Xaxis',...
                                        'Ydata','window');
            end
            
            if not(isequal(option.normwin,0) || ...
                   strcmpi(option.normwin,'No') || ...
                   strcmpi(option.normwin,'Off') || ...
                   obj.normalized)
                obj = obj.normalize(option.normwin);
            end
            if option.hwr
                obj = obj.hwr;
            end
            if max(option.enhance)>1
                obj = obj.enhance(option.enhance);
            end
            
            
            function s = sindex(s,srate,sstart)
                f = round((s-sstart)*srate) + 1;
            end
        end
        %%
        function obj = combinechunks(obj,new)
            do = obj.Ydata;
            dn = new.Ydata;
            lo = do.size('element');
            ln = dn.size('element');
            if abs(lo-ln) <= 2  % Probleme of border fluctuation
                mi = min(lo,ln);
                do = do.extract('element',[1,mi]);
                dn = dn.extract('element',[1,mi]);
            elseif ln < lo
                dn = dn.edit('element',lo,0);   % Zero-padding
            elseif lo < ln
                do = do.edit('element',ln,0);   % Zero-padding
            end
            obj.Ydata = do.plus(dn);
        end
        %%
        obj = normalize(obj,win);
        obj = hwr(obj);
        obj = enhance(obj,param);
    end
end