% SIG.SIMATRIX
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = simatrix(varargin)
    out = sig.operate('sig','simatrix',options,...
                            @init,@main,@after,varargin);
    if isa(out{1},'sig.design')
        out{1}.nochunk = 1;
    end
    varargout = out;
end


function options = options    
    options = sig.Signal.signaloptions('FrameAuto',.05,1);

        distance.key = 'Distance';
        distance.type = 'String';
        distance.default = 'cosine';
    options.distance = distance;

        simf.key = 'Similarity';
        simf.type = 'String';
        simf.default = 'oneminus';
        simf.keydefault = 'Similarity';        
    options.simf = simf;

        dissim.key = 'Dissimilarity';
        dissim.type = 'Boolean';
        dissim.default = 0;
    options.dissim = dissim;
    
        K.key = 'Width';
        K.type = 'Integer';
        K.default = Inf;
    options.K = K;
    
        filt.key = 'Filter';
        filt.type = 'Integer';
        filt.default = 0;
    options.filt = filt;

        view.type = 'String';
        view.default = 'Standard';
        view.choice = {'Standard','Horizontal','TimeLag'};
    options.view = view;

        half.key = 'Half';
        half.type = 'Boolean';
        half.default = 0;
    options.half = half;

        warp.key = 'Warp';
        warp.type = 'Integer';
        warp.default = 0;
        warp.keydefault = .5;
    options.warp = warp;
    
        cluster.key = 'Cluster';
        cluster.type = 'Boolean';
        cluster.default = 0;
    options.cluster = cluster;

        arg2.position = 2;
        arg2.default = [];
    options.arg2 = arg2;
    
        rate.type = 'Integer';
        rate.position = 2;
        rate.default = 20;
    options.rate = rate;
end


function [x,type] = init(x,option,frame)
    if x.istype('sig.Signal')
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
            'FrameHop',option.fhop.value,option.fhop.unit);
        x = sig.spectrum(x);   
    end
    type = 'sig.simatrix';
end


function out = main(x,option)
    x = x{1};
    
    if option.filt
        option.view = 'TimeLag';
    end

    lK = 2*floor(option.K/2)+1;
    d = sig.compute(@routine,x.Ydata,lK,option);
    y = sig.Simatrix(d,'Srate',x.Srate);
    y.diagwidth = lK;
    if strcmpi(option.view,'TimeLag')
        y.view = 'l';
    else
        y.view = 's';
    end
    y.half = option.half;
    y.similarity = 0;  
    out = {y};
end


function out = routine(in,lK,option)
    out = in.apply(@algo,{lK,option},{'element','sample'},2);
end


function d = algo(v,lK,option)
    ll = size(v,1);
    l = size(v,2);
    nc = 1;
    if strcmpi(option.view,'TimeLag')
        if isinf(lK)
            if option.half
                lK = l;
            else
                lK = l*2-1;
            end
        end
        d = NaN(lK,l,nc);
    else
        d = zeros(l,l,nc);
    end

    if iscell(v)
        vv = zeros(ll,l);
        for i = 1:ll
            for j = 1:l
                vj = v{i,j};
                if isempty(vj)
                    vv(i,j) = NaN;
                else
                    vv(i,j) = vj;
                end
            end
        end
    else
        vv = v;
    end
    
    if isinf(option.K) && not(strcmpi(option.view,'TimeLag'))
        try
            manually = 0;
            d = squareform(pdist(vv',option.distance));
        catch
            manually = 1;
        end
    else
        manually = 1;
    end
    if manually
        if strcmpi(option.distance,'cosine')
            for i = 1:l
                nm = norm(vv(:,i));
                if ~isnan(nm) && nm
                    vv(:,i) = vv(:,i)/nm;
                end
            end
        end
        hK = ceil(lK/2);
        if strcmpi(option.view,'TimeLag')
            for i = 1:l
                ij = min(i+lK-1,l); % Frame region i:ij
                if ij==i
                    continue
                end
                if strcmpi(option.distance,'cosine')
                    dkij = cosine(vv(:,i),vv(:,i:ij));
                else
                    mm = squareform(pdist(vv(:,i:ij)',...
                        option.distance));
                    dkij = mm(:,1);
                end
                if option.half
                    for j = 1:length(dkij)
                        d(j,i+j-1) = dkij(j);
                    end
                else
                    for j = 0:ij-i
                        if hK-j>0
                            d(hK-j,i) = dkij(j+1);
                        end
                        if hK+j<=lK
                            d(hK+j,i+j) = dkij(j+1);
                        end
                    end
                end
            end
        else
            win = window(@hanning,lK);
            win = win(ceil(length(win)/2):end);
            for i = 1:l
                j = min(i+hK-1,l);
                if j==i
                    continue
                end
                if strcmpi(option.distance,'cosine')
                    dkij = cosine(vv(:,i),vv(:,i:j))';
                else
                    mm = squareform(pdist(vv(:,i:j)',...
                        option.distance));
                    dkij = mm(:,1);
                end
                dkij = dkij.*win(1:length(dkij));
                d(i,i:j,g) = dkij';
                if ~option.half
                    d(i:j,i) = dkij;
                end
            end
        end
    elseif option.half
        for i = 1:l
            d(i+1:end,i) = 0;
        end
    end
end


function x = after(x,option)
    x = x{1};
    if ischar(option.simf)
        if strcmpi(option.simf,'Similarity')
            if not(isequal(x.similarity,NaN))
                option.dissim = 0;
            end
            option.simf = 'oneminus';
        end
        if isequal(x.similarity,0) && ~option.dissim
            simf = str2func(option.simf);
            x.Ydata = sig.compute(@routine_sim,x.Ydata,simf);
            x.similarity = option.simf;
            x.yname = 'Similarity Matrix';
        elseif length(x.similarity) == 1 && isnan(x.similarity) ...
                && option.dissim
            x.similarity = 0;
        end
    end
    x = {x};
end


function out = routine_sim(in,simf)
    out = in.apply(simf,{},{'element','sample'},2);
end


function d = cosine(r,s)
    d = 1-r'*s;
end


function d = KL(x,y)
    % Kullback-Leibler distance
    if size(x,4)>1
        x(end+1:2*end,:,:,1) = x(:,:,:,2);
        x(:,:,:,2) = [];
    end
    if size(y,4)>1
        y(end+1:2*end,:,:,1) = y(:,:,:,2);
        y(:,:,:,2) = [];
    end
    m1 = mean(x);
    m2 = mean(y);
    S1 = cov(x);
    S2 = cov(y);
    d = (trace(S1/S2)+trace(S2/S1)+(m1-m2)'*inv(S1+S2)*(m1-m2))/2 - size(S1,1);
end


function s = exponential(d)
    s = (exp(-d) - exp(-1)) / (1-exp(-1));
end
    
    
function s = oneminus(d)
    s = 1-d;
end