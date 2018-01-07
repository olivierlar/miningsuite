% SIG.FILTERBANK.MAIN
% Main routine of sig.filterbank, also called by aud.filterbank
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(x,option,filterspecif)
    [x{1}.Ydata,x{2},x{1}.fbchannels] = ...
        sig.compute(@routine,x{1}.Ydata,x{1}.Srate,x{1}.fbchannels,...
                    option,filterspecif);

    x = sig.framenow(x,option.frame);
    out = {x};
end


function out = routine(in,sampling,ch,option,filterspecif)
    if in.size('freqband') > 1
        if option.Ch
            in = in.extract('freqband',option.Ch);
            out = {in [] option.Ch};
        else
            out = {in [] ch};
        end
    else
        ch = option.Ch;
        nCh = option.nCh;
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
        
        [out{1},out{2}] = in.apply(@subroutine,{Hd,ch},...
                                   {'sample','freqband'},3);
        out{3} = ch;
    end
end


function [y,Hd] = subroutine(x,Hd,ch)
    y = zeros(size(x,1),length(ch),size(x,3));
    if ch == 0
        ch = 1:length(Hd);
    end
    for k = 1:length(ch)
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
        y(:,k,:) = yk;
    end
end