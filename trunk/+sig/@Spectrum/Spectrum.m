classdef Spectrum < sig.Signal
%%
    properties (Constant)
        spectrumoptions = initoptions;
        spectruminit = @init;
        spectrummain = @main;
        spectrumsonify = @sonifier;
    end
    properties   
        Xsampling
        powered = 0;
        loged = 0;
        terharded = 0;
        resonance = '';
        masked = 0;
    end
%%
    methods
        function s = Spectrum(data,xsampling,xstart,srate,sstart,...
                              name,xname,xunit)
            if nargin<3
                xstart = 1;
            end
            if nargin<4
                srate = 0;
            end
            if nargin<5
                sstart = 1;
            end
            if nargin<6
                name = 'Spectrum';
            end
            if nargin<7
                xname = 'Frequency';
            end
            if nargin<8
                xunit = 'Hz';
            end
            s = s@sig.Signal(data,name,'',xname,xunit,xsampling,xstart,...
                             srate,sstart);
            s.Xsampling = xsampling;
        end
        %%
        function obj = after(obj,option)
            obj = after@sig.Signal(obj,option);
            if 0 %option.min || option.max<Inf
                obj = obj.extract([option.min,option.max],'element',...
                                  @sindex,obj.Xsampling,obj.Xstart);
            end
            %if ~obj.powered && option.power
            %    obj = obj.power;
            %end
            %if option.norm
            %    obj = obj.norm(option.norm);
            %end
            %if ~obj.terharded && option.terhardt
            %    obj = obj.terhardt;
            %end
            %if isempty(obj.resonance) && option.resonance
            %    obj = obj.resonate(option.resonance);
            %end
            %if strcmp(obj.xname,'frequency')
            %    if strcmpi(option.band,'Mel')
            %        obj = obj.mel;
            %    elseif strcmpi(option.band,'Bark')
            %        obj = obj.bark;
            %    elseif strcmpi(option.band,'Cents')
            %        obj = obj.cents;
            %    end
            %end
            %if ~obj.masked && option.mask
            %    obj = obj.mask;
            %end
            %if option.log || option.db
            %end
            %if option.filter
            %    obj = obj.filter(option.filter);
            %end
        end
        %%
        playclass(obj,options)
    end
end


%%
function options = initoptions
    options = sig.Signal.signaloptions;

    options.fsize.default.value = .05;
    options.fhop.default.value = .5;
    
        min.key = 'Min';
        min.type = 'Integer';
        min.default = 0;
    options.min = min;
        
        max.key = 'Max';
        max.type = 'Integer';
        max.default = Inf;
    options.max = max;
    
        win.key = 'Window';
        win.type = 'String';
        win.default = 'hamming';
    options.win = win;
    
        db.key = 'dB';
        db.type = 'Integer';
        db.default = 0;
        db.keydefault = Inf;
        db.when = 'After';
    options.db = db;   
end


%%
function [x type] = init(x,option)
    type = '?';
end


function out = main(x,option,postoption)
    if isa(x{1},'sig.Spectrum')
        obj = x{1};
    else
        d = sig.compute(@routine,x{1}.Ydata,x{1}.Srate,option);
        
        obj = sig.Spectrum(d,1/x{1}.Srate,0,x{1}.Frate,0,...
                           'Spectrum','Frequency','Hz');
    end
    if isempty(postoption)
        out = {obj};
    else
        out = {obj.after(postoption)};
    end
end


function out = routine(in,sampling,option)
    l = in.size('sample');

    if ischar(option.win) 
        if strcmpi(option.win,'Rectangular')
            w = sig.data(ones(l,1),{'sample'});
        else
            winf = str2func(option.win);
            try
                w = window(winf,l);
            catch
                if strcmpi(option.win,'hamming')
                    disp('Signal Processing Toolbox does not seem to be installed. Recompute the hamming window manually.');
                    w = 0.54 - 0.46 * cos(2*pi*(0:l-1)'/(l-1));
                else
                    warning(['WARNING in MIRAUTOCOR: Unknown windowing function ',option.win,' (maybe Signal Processing Toolbox is not installed).']);
                    disp('No windowing performed.')
                    w = ones(l,1);
                end
            end
            w = sig.data(w,{'sample'});
            in = in.times(w);
        end
    else
        w = [];
    end
    
    out = in.apply(@fft,{l},{'sample'});
    out = out.apply(@abs,{},{'sample'});
    out = out.deframe;
    out = out.extract('element',[1,l/2]); 
end


%%
function d = sonifier(d,varargin)
end