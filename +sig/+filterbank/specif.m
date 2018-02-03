% SIG.FILTERBANK.SPECIF
% Filterbank specification, called by sig.filterbank and aud.filterbank
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [Hd,ch] = specif(option,sampling,nCh,ch)
    %% Determination of the filterbank specifications
    freqi = option.freq;
    j = 1;
    while j <= length(freqi)
        if not(isinf(freqi(j))) && freqi(j)>sampling/2
            if j == length(freqi)
                freqi(j) = Inf;
            else
                freqi(j) = [];
                j = j-1;
            end
        end
        j = j+1;
    end
    step = option.overlap;
    nchan = length(freqi)-step;
    if nchan < 1
        error('Error in sig.filterbank: the ''Cutoff'' parameter is not properly defined.');
    end
    for j = 1:nchan
        if isinf(freqi(j))
            [z{j},p{j},k{j}] = ellip(option.filterorder,3,40,...
                                freqi(j+step)/sampling*2);
        elseif isinf(freqi(j+step))
            [z{j},p{j},k{j}] = ellip(option.filterorder,3,40,...
                                freqi(j)/sampling*2,'high');
        else
            [z{j},p{j},k{j}] = ellip(option.filterorder,3,40,...
                                freqi([j j+step])/sampling*2);
        end
    end
    for j = 1:length(z)
        [sos,g] = zp2sos(z{j},p{j},k{j});
        Hd{j} = dfilt.df2tsos(sos,g);
    end
    if isempty(ch) || ch == 0
        ch = 1:length(freqi)-step;
    end

    for k = 1:length(Hd)
        Hdk = Hd{k};
        if ~iscell(Hdk)
            Hdk = {Hdk};
        end
        for h = 1:length(Hdk)
            if ~isa(Hdk{h},'function_handle')
                Hdk{h}.PersistentMemory = true;
            end
        end
    end
end