% SIG.SIGNAL.EXTRACT
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = extract(obj,param,dim,axis,varargin)
    argins = cell(1,length(varargin));
    for i = 1:length(varargin)
        argins{i} = obj.(varargin{i});
    end
    switch length(varargin)
        case 1
            [obj.(varargin{1}) start] = ...
                sig.compute(@main,argins{1},param,dim,...
                            obj.(axis),argins(2:end));
        case 2
            [obj.(varargin{1}) obj.(varargin{2}) start] =...
                sig.compute(@main,argins{1},param,dim,...
                            obj.(axis),argins(2:end));
        otherwise
            error('Not implemented yet');
    end
    if strcmp(dim,'sample')
        obj.Sstart = (start-1) / obj.Srate;
    elseif strcmp(dim,'element')
        if iscell(start)
            for i = 1:length(start)
                obj.Xaxis.start{i} = obj.Xaxis.start{i} + start{i};
            end
        else
            obj.Xaxis.start = obj.Xaxis.start + start;
        end
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
        sig.warning('sig.Signal',...
            'The ''Excerpt'' zone is out of reach. No result returned.')
        x1 = 1;
        x2 = 1;
    elseif isempty(x2) || x2>size(d,dim)
        if ~isinf(x2)
            %sig.warning('sig.Signal',...
            %    'The ''Excerpt'' zone exceeds the scope of the signal. Signal truncated.')
        end
        x2 = l;
    end
    
    d = d.extract(dim,[x1,x2]);
    for i = 1:length(fields)
        if ~isempty(fields{i})
            fields{i} = fields{i}.extract(dim,[x1,x2]);
        end
    end
    
    out = {d fields{:} x1};
end
