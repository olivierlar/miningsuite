% SIG.PEAKS
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = peaks(varargin)
    varargout = sig.operate('sig','peaks',initoptions,...
                            @init,@main,@after,varargin);
end


function options = initoptions
        m.key = 'Total';
        m.type = 'Integer';
        m.default = Inf;
    options.m = m;
        
        nobegin.key = 'NoBegin';
        nobegin.type = 'Boolean';
        nobegin.default = 0;
    options.nobegin = nobegin;
        
        noend.key = 'NoEnd';
        noend.type = 'Boolean';
        noend.default = 0;
    options.noend = noend;
        
        order.key = 'Order';
        order.type = 'String';
        order.choice = {'Amplitude','Abscissa'};
        order.default = 'Amplitude';
    options.order = order;
        
        vall.key = 'Valleys';
        vall.type = 'Boolean';
        vall.default = 0;
    options.vall = vall;
    
        cthr.key = 'Contrast';
        cthr.type = 'Integer';
        cthr.default = .1;
    options.cthr = cthr;
        
        first.key = 'SelectFirst';
        first.type = 'Integer';
        first.default = 0;
        first.keydefault = NaN;
    options.first = first;
    
        thr.key = 'Threshold';
        thr.type = 'Integer';
        thr.default = NaN;
    options.thr = thr;
            
        smthr.key = 'MatrixThreshold'; % to be documented in version 1.3
        smthr.type = 'Integer';
        smthr.default = NaN;
    options.smthr = smthr;
    
        graph.key = 'Graph';
        graph.type = 'Integer';
        graph.default = 0;
        graph.keydefault = .25;
    options.graph = graph;
        
        interpol.key = 'Interpol';
        interpol.type = 'String';
        interpol.default = 'Quadratic';
        interpol.keydefault = 'Quadratic';
    options.interpol = interpol;
    
        reso.key = 'Reso';
        reso.type = 'Numeric';
        reso.default = 0;
    options.reso = reso;
    
        resofirst.key = 'First';
        resofirst.type = 'Boolean';
        resofirst.default = 0;
    options.resofirst = resofirst;
        
        logsc.type = 'String';
        logsc.choice = {'Lin','Log',0};
        logsc.default = 'Lin';
    options.logsc = logsc;
        
        normal.key = 'Normalize';
        normal.type = 'String';
        normal.choice = {'Local','Global'};
        normal.default = 'Global';
    options.normal = normal;

%         extract.key = 'Extract';
%         extract.type = 'Boolean';
%         extract.default = 0;
%     options.extract = extract;
    
        only.key = 'Only';
        only.type = 'Boolean';
        only.default = 0;
    options.only = only;

        delta.key = 'Track';
        delta.type = 'Integer';
        delta.default = 0;
        delta.keydefault = Inf;
    options.delta = delta;
    
        mem.key = 'TrackMem';
        mem.type = 'Integer';
        mem.default = Inf;
    options.mem = mem;

        shorttrackthresh.key = 'CollapseTracks';
        shorttrackthresh.type = 'Integer';
        shorttrackthresh.default = 0;
        shorttrackthresh.keydefault = 7;
    options.shorttrackthresh = shorttrackthresh;

        scan.key = 'ScanForward'; % specific to mironsets(..., 'Klapuri99')
        scan.default = [];
    options.scan = scan;
end


function [x type] = init(x,option,frame)
    type = '?';
end


function out = main(s,option)
    if isnan(option.thr)
        option.thr = 0;
    elseif option.vall
        option.thr = 1-option.thr;
    end
    if isnan(option.first)
        option.first = option.cthr / 2;
    end
    
    if iscell(s)
        s = s{1};
    end
    xdata = s.xdata;
    if length(xdata) < 2
        s.peakdim = 'sample';
        x = s.sdata;
    else
        s.peakdim = 'element';
        x = xdata;
    end
    
    interpol = s.interpolable && not(isempty(option.interpol)) && ...
        ((isnumeric(option.interpol) && option.interpol) || ...
        (ischar(option.interpol) && ...
            not(strcmpi(option.interpol,'No')) && ...
            not(strcmpi(option.interpol,'Off'))));
    
    [s.peak s.peakprecisepos s.peakpreciseval] = ...
        sig.compute(@routine,s.Ydata,x,s.peakdim,option,interpol);
    
    out = {s};
end


function out = routine(y,x,dim,option,interpol)
    if option.vall
        y = y.apply(@uminus,{},{dim});
    end
    if strcmpi(option.normal,'Global')
        maxy = y.findglobal(@max);
        miny = y.findglobal(@min);
        y = y.minus(miny).divide(maxy-miny);
    end
    
    out = y.apply(@search,{x,option,interpol},{dim},1,'{}');
    p = out;
    p.content = p.content{1};
    pp = out;
    pp.content = pp.content{2};
    pv = out;
    pv.content = pv.content{3};
    out = {p pp pv};
end


function out = search(y,x,option,interpol)
    pp = [];
    pv = [];
    
    if strcmpi(option.normal,'Local')
        miny = min(y);
        y = (y - miny) / (max(y) - miny);
    end
    
    if option.nobegin
        y = [Inf;y];
    else
        y = [-Inf;y];
    end
    
    if option.noend
        y(end+1) = Inf;
    else
        y(end+1) = -Inf;
    end

    dy = diff(y);

    % Let's find the local maxima
    p = find(y(2:end-1) >= max(option.cthr,option.thr) & ...     
             dy(1:end-1) > 0 & dy(2:end) <= 0);
    
    if isempty(p)
        out = {p pp pv};
        return
    end
         
    if option.cthr
        finalm = [];
        wait = 0;
        if length(p)>5000
            wait = waitbar(0,['Selecting peaks... (0 out of 0)']);
        end
        j = 1;  % Scans the peaks from begin to end.
        mj = p(1); % The current peak
        jj = j+1;
        bufmin = Inf;
        bufmax = y(mj+1);
        oldbufmin = min(y(1:p(1)));
        while jj <= length(p)
            if isa(wait,'matlab.ui.Figure') && not(mod(jj,5000))
                waitbar(jj/length(p),wait,['Selecting peaks... (',...
                                            num2str(length(finalm)),...
                                            ' out of ',num2str(jj),')']);
            end
            bufmin = min(bufmin,min(y(p(jj-1)+2:p(jj))));
            if bufmax - bufmin < option.cthr
                % There is no contrastive notch
                if y(p(jj)+1) > bufmax && ...
                        (y(p(jj)+1) - bufmax > option.first ...
                        || (bufmax - oldbufmin < option.cthr))
                    % If the new peak is significantly
                    % higher than the previous one,
                    % The peak is transfered to the new
                    % position
                    j = jj;
                    mj = p(j); % The current peak
                    bufmax = y(mj+1);
                    oldbufmin = min(oldbufmin,bufmin);
                    bufmin = Inf;
                elseif y(p(jj)+1) - bufmax <= option.first
                    bufmax = max(bufmax,y(p(jj)+1));
                    oldbufmin = min(oldbufmin,bufmin);
                end
            else
                % There is a contrastive notch
                if bufmax - oldbufmin < option.cthr
                    % But the previous peak candidate
                    % is too weak and therefore
                    % discarded
                    oldbufmin = min(oldbufmin,bufmin);
                else
                    % The previous peak candidate is OK
                    % and therefore stored
                    finalm(end+1) = mj;
                    oldbufmin = bufmin;
                end
                bufmax = y(p(jj)+1);
                j = jj;
                mj = p(j); % The current peak
                bufmin = Inf;
            end
            jj = jj+1;
        end
        if (isempty(oldbufmin) || bufmax - oldbufmin >= option.cthr) && ...
                (p(j) == length(y) || ...
                 bufmax - min(y(p(j)+2:end)) >= option.cthr)
            % The last peak candidate is OK and stored
            finalm(end+1) = p(j);
        end
        if isa(wait,'matlab.ui.Figure')
            waitbar(1,wait);
            close(wait);
            drawnow
        end
        p = finalm;
    end
    
    if option.reso % Removing peaks too close to higher peaks
        [unused,idx] = sort(y(p+1),'descend');
        p = p(idx);
        del = [];
        j = 1;
        while j < length(p)
            jj = j+1;
            while jj <= length(p)
                if abs(x(p(jj)) - x(p(j))) < option.reso
                    if option.resofirst && p(j)>p(jj)
                        del = [del j];
                    else
                        del = [del jj];
                    end
                end
                jj = jj+1;
            end
            j = j+1;
        end
        p(del) = [];
    end
    
    idx = [];
    if length(p) > option.m
        [unused,idx] = sort(y(p+1),'descend');
        idx = idx(1:option.m);
        p = p(idx);
    end
    if strcmpi(option.order,'Abscissa')
        p = sort(p);
    elseif isempty(idx)
        [unused,idx] = sort(y(p+1),'descend');
        p = p(idx);
    end
    
    if interpol
        pv = zeros(1,length(p));
        pp = zeros(1,length(p));
        for i = 1:length(p)
            if p(i) > 2 && p(i) < length(y)
                % More precise peak position
                y0 = y(p(i)+1);
                ym = y(p(i));
                yp = y(p(i)+2);
                r = (yp-ym)/(2*(2*y0-yp-ym));
                pv(i) = y0 - 0.25*(ym-yp)*r;
                if r >= 0
                    pp(i) = (1-r)*x(p(i))+r*x(p(i)+1);
                elseif r < 0
                    pp(i) = (1+r)*x(p(i))-r*x(p(i)-1);
                end
            else
                pv(i) = y(p(i)+1);
                pp(i) = x(p(i));
            end
        end
    end
    out = {p pp pv};
end





function x = after(x,option)
end