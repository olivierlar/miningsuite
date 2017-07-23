% SIG.NOVELTY
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = flux(varargin)
    varargout = sig.operate('sig','novelty',options,@init,@main,@after,varargin);
end


function options = options
    options = sig.signal.signaloptions('FrameAuto',.05,1);

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
        x = sig.simatrix(x,'Distance',option.dist,'Similarity',option.sm,...
                           'Width',max(option.K),option.transf,...
                           'Half',option.half,'Cluster',option.cluster,...
                           'FrameConfig',frame);
    end
    type = 'sig.novelty';
end


function out = main(x,option)
    x = x{1};
    
    if x.istype('sig.novelty')
        out = {x};
        return
    end
    
    if isinf(option.K)
        d = sig.compute(@routine_inf,x.Ydata);
    end
    
    n = sig.signal(d,'Name','Novelty','Srate',x.Srate,'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    out = {n};
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


function x = after(x,option)
end