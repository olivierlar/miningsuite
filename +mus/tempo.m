function varargout = tempo(varargin)

    if isnumeric(varargin{1})
        [options post] = sig.options(initoptions,varargin,'mus.tempo');
        varargout = {sig.signal(varargin{1},'Name','Tempo')};
    else
        
        varargout = sig.operate('musi','tempo',...
                                initoptions,@init,@main,varargin,'plus');
    end
end


%%
function options = initoptions
    options = sig.Signal.frameoptions(5,.2);
    
        method.type = 'String';
        method.choice = {'Autocor','Pattern'};
        method.default = 'Autocor';
    options.method = method;
end


%%
function [x type] = init(x,option)
    if strcmpi(option.method,'Autocor')
        x = sig.envelope(x);
        x = sig.autocor(x,'Max',5);
        x = sig.peak(x,'Total',1);
    elseif strcmpi(option.method,'Pattern')
        x = mus.minr(x,'Metre');
    end
    type = 'sig.Signal';
end


function out = main(in,option,postoption)
    if isa(in,'mus.Sequence')
        o = [];
        for i = 1:length(in.content)
            v = in.content{i}.parameter.getfield('metre').value
            if ~isempty(v)
                o(end+1) = in.content{i}.parameter.getfield('onset').value;
            end
        end
        tp = zeros(length(o)-1,1);
        for i = 2:length(o)
            tp(i-1) = 60/(o(i) - o(i-1));
        end
        d = sig.data(tp,{'sample'});
        x = sig.signal(d,'Name','Tempo','Srate',1);
    else
        x = in{1};
        if ~strcmpi(x.yname,'Tempo')
            p = sig.compute(@routine,x.peakpos);
            x = sig.signal(p{1},'Name','Tempo','Srate',in{1}.Srate);
        end
    end
    out = {x};
end


function out = routine(d)
    e = d.apply(@convert,{},{'element'});
    out = {e};
end


function y = convert(x)
    y = 60./x;
end