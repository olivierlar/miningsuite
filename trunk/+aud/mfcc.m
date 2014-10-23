% AUD.MFCC
%
% Copyright (C) 2014, Olivier Lartillot
% Copyright (C) 1998, Malcolm Slaney, Interval Research Corporation
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = mfcc(varargin)
    varargout = sig.operate('aud','mfcc',...
                            initoptions,@init,@main,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions(.05,.5);
    
        nbbands.key = 'Bands';
        nbbands.type = 'Numeric';
        nbbands.default = 40;
    options.nbbands = nbbands;

        rank.key = 'Rank';
        rank.type = 'Numeric';
        rank.default = 1:13;
    options.rank = rank; 
        
        delta.key = 'Delta';
        delta.type = 'Numeric';
        delta.default = 0;
        delta.keydefault = 1;
        delta.when = 'After';
    options.delta = delta;
        
        radius.key = 'Radius';
        radius.type = 'Numeric';
        radius.default = 2;
        radius.when = 'After';
    options.radius = radius;
end


%%
function [x type] = init(x,option,frame)
    if ~x.istype('aud.mfcc')
        x = aud.spectrum(x,'Mel','log','Bands',option.nbbands);
    end
    type = {'aud.mfcc','sig.Spectrum'};
end


function out = main(in,option,postoption)
    x = in{1};
    if isa(x,'aud.mfcc')
        % Not done yet.
        out = in;
    else
        res = sig.compute(@routine,x.Ydata,option.rank);
        x = aud.Mfcc(res,'Srate',x.Srate,'Ssize',x.Ssize);
        x = after(x,postoption);
        out = {x in{1}};
    end
end


function out = routine(d,rank)
    e = d.apply(@algo,{rank},{'element'},2);
    out = {e};
end


function ceps = algo(m,rank)
    totalFilters = size(m,1); %Number of bands
    mfccDCTMatrix = 1/sqrt(totalFilters/2)*...
                    cos(rank' * (2*(0:(totalFilters-1))+1) * ...
                        pi/2/totalFilters);
    rank0 = find(rank == 0);
    mfccDCTMatrix(rank0,:) = mfccDCTMatrix(rank0,:) * sqrt(2)/2;
    %ceps = zeros(size(mfccDCTMatrix,1),size(m,2));
    ceps = mfccDCTMatrix * m;
end


function x = after(x,option)
    if option.delta
        d = sig.compute(@delta,x.Ydata,option.delta,option.radius);
        x.Ydata = d;
        x.yname = ['Delta-',x.yname];
    end
end


function x = delta(x,delta,radius)
    x = x.apply(@delta_algo,{delta,radius},{'element','sample'},2);
end


function y = delta_algo(x,delta,M)
    nc = size(x,2) - 2*M;
    y = zeros(size(x,1),nc);
    for i = 1:delta
        y = y + i * (x(:,M+i+(1:nc)) - x(:,M-i+(1:nc)));
    end
    y = y / 2 / sum((1:M).^2); % MULTIPLY BY 2 INSTEAD OF SQUARE FOR NORMALIZATION ?
end