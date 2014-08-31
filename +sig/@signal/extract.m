function obj = extract(obj,param,dim,axis,varargin)
    argins = cell(1,length(varargin));
    for i = 1:length(varargin)
        argins{i} = obj.(varargin{i});
    end
    out = sig.compute(@main,argins{1},param,dim,obj.(axis),argins(2:end));
    for i = 1:length(varargin)
        obj.(varargin{i}) = out{i};
    end
    if strcmp(dim,'sample')
        obj.Sstart = out{i+1};
    elseif strcmp(dim,'element')
        obj.Xaxis.start = obj.Xaxis.start + out{i+1};
    end
end
    
   
function out = main(d,param,dim,axis,fields)
    value = axis.find(param);
    x1 = value(1);
    x2 = value(2);
    l = size(d,dim);
    
    if isinf(x1)
        x1 = 1;
    elseif x1<0
        if x2>0
            shift = round(l/2);
        else
            shift = l;
        end
        x1 = x1+shift;
        x2 = x2+shift;
    end
    
    if isempty(x1) || x1>l
        sig.warning('sig.signal',...
            'The ''Excerpt'' zone is out of reach. No result returned.')
        x1 = 1;
        x2 = 1;
    elseif isempty(x2) || x2>size(d,dim)
        if ~isinf(x2)
            %sig.warning('sig.signal',...
            %    'The ''Excerpt'' zone exceeds the scope of the signal. Signal truncated.')
        end
        x2 = l;
    end
    
    d = d.extract(dim,[x1,x2]);
    for i = 1:length(fields)
        fields{i} = fields{i}.extract(dim,[x1,x2]);
    end
    
    out = {d fields{:} x1};
end