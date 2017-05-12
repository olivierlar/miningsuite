% SIG.FILTERBANK.MAIN
% Main routine of sig.filterbank, also called by aud.filterbank
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function x = main(x,option,filterspecif)
    [x{1}.Ydata x{1}.fbchannels x{2}] = ...
        sig.compute(@routine,x{1}.Ydata,x{1}.Srate,x{1}.fbchannels,...
                    option,filterspecif);
end


function out = routine(in,sampling,ch,option,filterspecif)
    if in.size('freqband') > 1
        %warning('WARNING IN SIG.FILTERBANK: The input data is already decomposed into channels. No more channel decomposition.');
        if option.Ch
            in = in.extract('freqband',option.Ch);
            out = {in [] option.Ch};
        else
            out = {in [] ch};
        end
    else
        nCh = option.nCh;
        ch = option.Ch;
        
        if isfield(option,'tmp')
            tmp = option.tmp;
        else
            tmp = [];
        end

        if isempty(tmp)
            [Hd,ch] = filterspecif(option,sampling,nCh,ch);
        else
            Hd = tmp;
        end
        
        [out{1},out{2}] = in.apply(@subroutine,{Hd},...
                                   {'sample','freqband'},Inf);
        out{3} = ch;
    end
end


function [y Hd] = subroutine(x,Hd)
    y = zeros(size(x,1),length(Hd));
    for k = 1:length(Hd)
        Hdk = Hd{k};
        if ~iscell(Hdk)
            Hdk = {Hdk};
        end
        yk = x;
        for h = 1:length(Hdk)
            if isa(Hdk{h},'function_handle')
                yk = Hdk{h}(yk);
            else
                yk = Hdk{h}.filter(yk);
            end
        end
        y(:,k) = yk;
    end
end