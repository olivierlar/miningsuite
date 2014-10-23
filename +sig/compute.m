% SIG.COMPUTE
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function varargout = compute(algo,varargin)
varargout = recurse(algo,varargin,nargout,1);


function argouts = recurse(algo,argins,nout,layer)
arg1 = argins{1};
if isa(arg1,'sig.data')
    nblayers = arg1.layers;
    arg1 = arg1.content;
else
    nblayers = 1;
end
if nblayers > layer
    l = length(arg1);
    argouts = cell(1,nout);
    for i = 1:l
        argi = argins;
        for j = 1:length(argi)
            if isa(argi{j},'sig.data')
                argj = argi{j}.content;
                if length(argj) == l
                    if iscell(argj)
                        argi{j}.content = argj{i};
                    else
                        argi{j}.content = argj(i);
                    end
                end
            elseif isa(argi{j},'sig.axis')
                argi{j}.start = argi{j}.start{i};
            else
                if length(argi{j}) == l
                    if iscell(argi{j})
                        argi{j} = argi{j}{i};
                    else
                        argi{j} = argi{j}(i);
                    end
                end
            end
        end
        y = recurse(algo,argi,nout,layer+1);
        if ~iscell(y)
            y = {y};
        end
        for j = 1:nout
            if isa(y{j},'sig.data')
                if i == 1
                    argouts{j} = y{j};
                    argouts{j}.content = {y{j}.content};
                else
                    argouts{j}.content{i} = y{j}.content;
                end
            else
                argouts{j}{i} = y{j};
            end
        end
    end
else
    argouts = algo(argins{:});
    if ~iscell(argouts)
        argouts = {argouts};
    end
end