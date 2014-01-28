classdef Spectral < sig.Vectorial
    properties (Constant)
        spectraloptions = initoptions;
        synth = @synthmethod;
    end
    properties
        SamplingRate
        window
    end
    methods
        function s = Spectral(data,name,unit,sampling,start,dims)
            s = s@sig.Vectorial(data,name,unit,@xdata,'frequency','Hz',...
                                dims,start);
            s.SamplingRate = sampling;
        end
        function obj = after(obj,option)
            voption = option;
            voption.extract = {};
            obj = after@sig.Vectorial(obj,voption);
            
            if option.sampling
                obj = obj.resample(option.sampling);
            end
            if ~isempty(option.extract)
                obj = obj.extract(option.extract,option.extractfrom);
            elseif option.start
                obj.Tstart = option.start;
            end
            if option.trim
                obj = obj.trim(option.trimwhere,option.trimthreshold);
            end
        end
        playclass(obj,options)
    end
end


function x = xdata(obj)
    ndims = length(obj.Tstart);
    if ndims == 0
        t = [];
    elseif ndims == 1
        t = obj.Tstart + ((0:size(obj.Data,1)-1)')/obj.SamplingRate;
    else
        t = cell(1,ndims);
        for i = 1:ndims
            t{i} = obj.Tstart(i) + ...
                ((0:size(obj.Data{i},1)-1)')/obj.SamplingRate(i);
        end
    end
end


function options = initoptions
    options = sig.Vectorial.vectorialoptions;
    
        reso.key = 'Resonance';
        reso.type = 'String';
        reso.choice = {'ToiviainenSnyder','Toiviainen','vanNoorden','no','off',0};
        reso.keydefault = 'Toiviainen';
        reso.when = 'After';
        reso.default = 0;
    options.reso = reso;
        
        resocenter.key = {'Center','Centre'};
        resocenter.type = 'Integer';
        resocenter.when = 'After';
    options.resocenter = resocenter;

        h.key = 'Halfwave';
        h.type = 'Boolean';
        h.when = 'After';
        h.default = 0;
    options.h = h;
        
        e.key = 'Enhanced';
        e.type = 'Integers';
        e.default = [];
        e.keydefault = 2:10;
        e.when = 'After';
    options.e = e;
        
        fr.key = 'Freq';
        fr.type = 'Boolean';
        fr.default = 0;
        fr.when = 'After';
    options.fr = fr;
        
        nw.key = 'NormalWindow';
        nw.when = 'Both';
        if isamir(orig,'mirspectrum')
            nw.default = 0;
        elseif isamir(orig,'mirenvelope')
            nw.default = 'rectangular';
        else
            nw.default = 'hanning';
        end
    options.nw = nw;
    
        win.key = 'Window';
        win.type = 'String';
        win.default = NaN;
    options.win = win;
end


function d = synthmethod(d,varargin)
end