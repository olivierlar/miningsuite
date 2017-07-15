% AUD.FILTERBANK
% performs a filterbank decomposition of an audio waveform following
% auditory models
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = filterbank(varargin)
    varargout = sig.operate('aud','filterbank',initoptions,...
                            @init,@main,@after,varargin,'concat');
end


function options = initoptions
    options = sig.filterbank.options;
    options = rmfield(options,'freq');
    options.nCh.default = 10;
    
        filtertype.type = 'String';
        filtertype.choice = {'Gammatone','2Channels',0};
        filtertype.default = 'Gammatone';
    options.filtertype = filtertype;
    
        lowF.key = 'Lowest';
        lowF.type = 'Integer';
        lowF.default = 50;
    options.lowF = lowF;

        presel.type = 'String';
        presel.choice = {'Scheirer','Klapuri','Mel','Bark'};
        presel.default = '';
    options.presel = presel;
end
    

%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function x = main(x,option)
    if isempty(option)
        return
    end
    if strcmpi(option.presel,'Scheirer')
        option.freq = [-Inf 200 400 800 1600 3200 Inf];
        option.filtertype = 'Manual';
    elseif strcmpi(option.presel,'Klapuri')
        option.freq = 44*[2.^([0:2,(9+(0:17))/3])];
        option.filtertype = 'Manual';
    elseif strcmpi(option.presel,'Mel')
        lowestFrequency = 133.3333;
        linearFilters = 13;
        linearSpacing = 66.66666666;
        logFilters = 27;
        logSpacing = 1.0711703;
        totalFilters = linearFilters + logFilters;
        cepstralCoefficients = 13;
        option.freq = lowestFrequency + (0:linearFilters-1)*linearSpacing;
        option.freq(linearFilters+1:totalFilters+2) = ...
            option.freq(linearFilters) * logSpacing.^(1:logFilters+2);

        option.overlap = 2;
        option.filtertype = 'Manual';
    elseif strcmpi(option.presel,'Bark')
        option.freq = [10 20 30 40 51 63 77 92 108 127 148 172 200 232 ...
                        270 315 370 440 530 640 770 950 1200 1550]*10; %% Hz
        option.filtertype = 'Manual';
    end
    
    x = sig.filterbank.main(x,option,@filterbank_specif);
end


function [Hd,ch] = filterbank_specif(option,sampling,nCh,ch)
    %% Determination of the filterbank specifications
    if strcmpi(option.filtertype,'Gammatone')
        if not(ch)
            ch = 1:nCh;
        end
        Hd = ERBFilters(sampling,nCh,ch,option.lowF);
    elseif strcmpi(option.filtertype,'2Channels')
        if not(ch)
            ch = 1:2;
        end
        [bl,al] = butter(4,[70 1000]/sampling*2);
        if ismember(1,ch)
            Hd{1} = dfilt.df2t(bl,al);
            k = 2;
        else
            k = 1;
        end
        if ismember(2,ch)
            if sampling < 20000
                [bh,ah] = butter(2,1000/sampling*2,'high');
            else
                [bh,ah] = butter(2,[1000 10000]/sampling*2);
            end
            Hd{k} = {dfilt.df2t(bl,al),...
                     @(x) max(x,0),...
                     dfilt.df2t(bh,ah)};
        end
    else
        [Hd,ch] = sig.filterbank.specif(option,sampling,nCh,ch);
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
%%

function Hd=ERBFilters(fs,numChannels,chans,lowFreq)
    % This function computes the filter coefficients for a bank of 
    % Gammatone filters.  These filters were defined by Patterson and 
    % Holdworth for simulating the cochlea.  
    % The transfer function  of these four second order filters share the same
    % denominator (poles) but have different numerators (zeros).
    % The filter bank contains "numChannels" channels that extend from
    % half the sampling rate (fs) to "lowFreq".

    % Note this implementation fixes a problem in the original code by
    % computing four separate second order filters.  This avoids a big
    % problem with round off errors in cases of very small cfs (100Hz) and
    % large sample rates (44kHz).  The problem is caused by roundoff error
    % when a number of poles are combined, all very close to the unit
    % circle.  Small errors in the eigth order coefficient, are multiplied
    % when the eigth root is taken to give the pole location.  These small
    % errors lead to poles outside the unit circle and instability.  Thanks
    % to Julius Smith for leading me to the proper explanation.

    % Code taken from Auditory Toolbox and optimized.
    % (Malcolm Slaney, August 1993, (c) 1998 Interval Research Corporation)

    T = 1/fs;
    EarQ = 9.26449;				%  Glasberg and Moore Parameters
    minBW = 24.7;

    %%
    % Computes an array of numChannels frequencies uniformly spaced between
    % fs/2 and lowFreq on an ERB scale.
    %
    % For a definition of ERB, see Moore, B. C. J., and Glasberg, B. R. (1983).
    % "Suggested formulae for calculating auditory-filter bandwidths and
    % excitation patterns," J. Acoust. Soc. Am. 74, 750-753.
    % 
    % Derived from Apple TR #35, "An
    % Efficient Implementation of the Patterson-Holdsworth Cochlear
    % Filter Bank."  See pages 33-34.
    cf = -(EarQ*minBW) + exp((1:numChannels)'*(-log(fs/2 + EarQ*minBW) + ...
            log(lowFreq + EarQ*minBW))/numChannels) * (fs/2 + EarQ*minBW);

    %%
    ERB = ((cf/EarQ) + minBW);
    B=1.019*2*pi*ERB;

    A0 = T;
    A2 = 0;
    B0 = 1;
    B1 = -2*cos(2*cf*pi*T)./exp(B*T);
    B2 = exp(-2*B*T);

    A11 = -(2*T*cos(2*cf*pi*T)./exp(B*T) + 2*sqrt(3+2^1.5)*T*sin(2*cf*pi*T)./ ...
            exp(B*T))/2;
    A12 = -(2*T*cos(2*cf*pi*T)./exp(B*T) - 2*sqrt(3+2^1.5)*T*sin(2*cf*pi*T)./ ...
            exp(B*T))/2;
    A13 = -(2*T*cos(2*cf*pi*T)./exp(B*T) + 2*sqrt(3-2^1.5)*T*sin(2*cf*pi*T)./ ...
            exp(B*T))/2;
    A14 = -(2*T*cos(2*cf*pi*T)./exp(B*T) - 2*sqrt(3-2^1.5)*T*sin(2*cf*pi*T)./ ...
            exp(B*T))/2;

    gain = abs((-2*exp(4i*cf*pi*T)*T + ...
                     2*exp(-(B*T) + 2i*cf*pi*T).*T.* ...
                             (cos(2*cf*pi*T) - sqrt(3 - 2^(3/2))* ...
                              sin(2*cf*pi*T))) .* ...
               (-2*exp(4i*cf*pi*T)*T + ...
                 2*exp(-(B*T) + 2i*cf*pi*T).*T.* ...
                  (cos(2*cf*pi*T) + sqrt(3 - 2^(3/2)) * ...
                   sin(2*cf*pi*T))).* ...
               (-2*exp(4i*cf*pi*T)*T + ...
                 2*exp(-(B*T) + 2i*cf*pi*T).*T.* ...
                  (cos(2*cf*pi*T) - ...
                   sqrt(3 + 2^(3/2))*sin(2*cf*pi*T))) .* ...
               (-2*exp(4i*cf*pi*T)*T + 2*exp(-(B*T) + 2i*cf*pi*T).*T.* ...
               (cos(2*cf*pi*T) + sqrt(3 + 2^(3/2))*sin(2*cf*pi*T))) ./ ...
              (-2 ./ exp(2*B*T) - 2*exp(4i*cf*pi*T) +  ...
               2*(1 + exp(4i*cf*pi*T))./exp(B*T)).^4);

    allfilts = ones(length(cf),1);
    A0 = A0*allfilts;
    A2 = A2*allfilts;
    B0 = B0*allfilts;

    for i = 1:length(chans)
        chan = length(gain)-chans(i)+1; % Revert the channels order
        aa1 = [A0(chan)/gain(chan) A11(chan)/gain(chan)  A2(chan)/gain(chan)];
        bb1 = [B0(chan) B1(chan) B2(chan)];
        aa2 = [A0(chan) A12(chan) A2(chan)];
        bb2 = [B0(chan) B1(chan) B2(chan)];
        aa3 = [A0(chan) A13(chan) A2(chan)];
        bb3 = [B0(chan) B1(chan) B2(chan)];
        aa4 = [A0(chan) A14(chan) A2(chan)];
        bb4 = [B0(chan) B1(chan) B2(chan)];
        Hd{i} = {dfilt.df2t(aa1,bb1);dfilt.df2t(aa2,bb2);...
                 dfilt.df2t(aa3,bb3);dfilt.df2t(aa4,bb4)};
    end
end


function x = after(x,option)    
end