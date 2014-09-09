% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
function field = val2field(value,value2)

if isa(value,'seq.paramval')
    field = pat.val2field(value.value);
elseif isstruct(value)
    f = fields(value);
    field = '';
    for i = 1:length(f)
        if i > 1
            field = [field,'_'];
        end
        field = [field,'val',relnum2str(value.(f{i}))];
    end
else
    if ischar(value)
        value = double(value);
    end
    if nargin == 1 || isempty(value2)
        field = ['val' relnum2str(value)];
    else
        field = ['val' relnum2str(value) '_' relnum2str(value2)];
    end
end


function y = relnum2str(x)
if isnumeric(x)
    y = num2str(x);
    if x<0
        y = ['m',y(2:end)];
    end
else
    y = x;
end
for i = 1:length(y)
    if strcmp(y(i),' ')
        y(i) = '_';
    elseif strcmp(y(i),'.')
        y(i) = 'd';
    end
end