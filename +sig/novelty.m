% SIG.NOVELTY
%
% Copyright (C) 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = flux(varargin)
    varargout = sig.operate('sig','novelty',options,@init,@main,@after,varargin);
end


function options = options
    options = sig.Signal.signaloptions('FrameAuto',.05,1);

        dist.key = 'Distance';
        dist.type = 'String';
        dist.default = 'cosine';
    options.dist = dist;

        sm.key = {'Measure','Similarity'};
        sm.type = 'String';
        sm.default = 'exponential';
    options.sm = sm;

        K.key = {'KernelSize','Width','Kernel'};
        K.type = 'Integer';
        K.default = Inf;
    options.K = K;
    
%        gran.key = 'Granul';
%        gran.type = 'Integer';
%        gran.default = 1;
%    option.gran = gran;

        transf.type = 'String';
        transf.default = 'Standard';
        transf.choice = {'Horizontal','TimeLag','Standard'};
    options.transf = transf;

        flux.key = 'Flux';
        flux.type = 'Boolean';
        flux.default = 0;
    options.flux = flux;

        simple.key = 'Simple';
        simple.type = 'Boolean';
        simple.default = 0;
    options.simple = simple;

        half.key = 'Half';
        half.type = 'Boolean';
        half.default = 1;
    options.half = half;

        cluster.key = 'Cluster';
        cluster.type = 'Boolean';
        cluster.default = 0;
    options.cluster = cluster;

        normal.key = 'Normal';
        normal.type = 'Boolean';
        normal.default = 1;
        normal.when = 'After';
    options.normal = normal;

        integr.key = 'Integrate';
        integr.type = 'Boolean';
        integr.default = 0;
        integr.when = 'After';
    options.integr = integr;

        filter.key = 'Filter';
        filter.type = 'Boolean';
        filter.default = 0;
        filter.when = 'After';
    options.filter = filter;
end


function [x,type] = init(x,option,frame)
    if ~x.istype('sig.novelty')
        if ~isinf(option.K)
            option.half = 0;
            if strcmpi(option.transf,'Standard')
                option.transf = 'TimeLag';
            end
        end
        if x.istype('sig.Signal')
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                'FrameHop',option.fhop.value,option.fhop.unit);
        end
        x = sig.simatrix(x,'Distance',option.dist,'Similarity',option.sm,...
                           'Width',max(option.K),option.transf,...
                           'Half',option.half,'Cluster',option.cluster);
    end
    type = {'sig.novelty','sig.Simatrix'};
end


function out = main(x,option)
    x = x{1};
    
    if x.istype('sig.novelty')
        out = {x};
        return
    end
    
    if isinf(option.K)
        d = sig.compute(@routine_inf,x.Ydata);
    else
        dw = x.diagwidth;
        Ks = option.K;
        if ~isnan(Ks) && Ks
            cgs = min(Ks,dw);
        else
            cgs = dw;
        end
        cg = checkergauss(cgs,option.transf)/cgs;%.^option.gran;
        d = sig.compute(@routine_K,x.Ydata,cg);
    end
    n = sig.Signal(d,'Name','Novelty','Srate',x.Srate,'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    out = {n,x};
end


function out = routine_inf(in)
    out = in.apply(@algo_inf,{},{'element','sample'},2);
end


function score = algo_inf(x)
    score = zeros(1,size(x,2));
    for i = 3:size(x,2)
        l = 1;
        bloc = x(i-l-1:-1:1,1:i-l);
        stop = find(x(i-l-1:-1:1,i) > ...
                    min(x(i-l-1:-1:1,i-l),...
                        max(mean(bloc,2) - 2 * std(bloc,0,2),...
                            min(bloc,[],2))));
        if length(stop) < 2
            stop = i-l;
        else
            stop(end+1) = stop(end)+1;
            stopp = find(diff(stop(1:end-1)) == 1 & diff(stop,2) == 0,1);
            if isempty(stopp)
                stop = i-l;
            else
                stop = stop(stopp);
            end
        end
        if ~isempty(stop)
            dist = sum(diff([x(i-l-stop+1:i-l-1,i),...
                             x(i-l-stop+1:i-l-1,i-l)],...
                            1,2));
        end
        score(i) = max(dist,0);
    end
end


function out = routine_K(in,cg)
    out = in.apply(@algo_K,{cg},{'element','sample'},2);
end


function score = algo_K(x,cg)
    ma = max(max(x));
    mi = min(min(x));
    x = (x-mi)/(ma-mi);
    x = 2*x-1;
    x(isnan(x)) = 0;
    cv = sig.convolve2(x,cg,'same');
    nl = size(cv,1);
    if nl == 0
        warning('WARNING IN NOVELTY: No frame decomposition. The novelty score cannot be computed.');
        score = [];
    else
        score = cv(floor(size(cv,1)/2),:);
        incr = find(diff(score)>=0);
        if not(isempty(incr))
            decr = find(diff(score)<=0);
            score(1:incr(1)-1) = NaN(1,incr(1)-1);
            if not(isempty(decr))
                score(decr(end)+1:end) = NaN(1,length(score)-decr(end));
            end
            incr = find(diff(score)>=0);
            sco2 = score;
            if not(isempty(incr))
                sco2 = sco2(1:incr(end)+1);
            end
            decr = find(diff(score)<=0);
            if not(isempty(decr)) && decr(1)>2
                sco2 = sco2(decr(1)-1:end);
            end
            mins = min(sco2);
            rang = find(score>= mins);
            if not(isempty(rang))
                score(1:rang(1)-1) = NaN(1,rang(1)-1);
                score(rang(end)+1:end) = NaN(1,length(score)-rang(end));
            end
        end
    end
end


function x = after(x,option)
end


function y = checkergauss(N,transf)
    %hN = ceil(N/2);
    hN = (N-1)/2+1;
    if strcmpi(transf,'TimeLag') || strcmpi(transf,'Standard')
        y = zeros(2*N,N);
        for j = 1:N
            for i = 1:2*N+1
                g = exp(-((((i-N)-(j-hN))/hN)^2 + (((j-hN)/hN)^2))*4);
                if xor(j>hN,j-hN>i-N)
                    y(i,j) = -g;
                elseif j>hN+i || j-hN<i-2*N
                    y(i,j) = 0;
                else
                    y(i,j) = g;
                end
            end
        end
    else
        y = zeros(N);
        for i = 1:N
            for j = 1:N
                g = exp(-(((i-hN)/hN)^2 + (((j-hN)/hN)^2))*4);
                if xor(j-hN>floor((i-hN)/2),j-hN>floor((hN-i)/2))
                    y(i,j) = -g;
                else
                    y(i,j) = g;
                end
            end
        end
    end
end