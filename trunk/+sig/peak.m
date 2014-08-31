function varargout = peak(varargin)

    varargout = sig.operate('sig','peak',initoptions,@init,@main,varargin);
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
    
        chro.key = 'Chrono'; % obsolete, corresponds to 'Order','Abscissa'
        chro.type = 'Boolean';
        chro.default = 0;
    options.chro = chro;
    
        ranked.key = 'Ranked'; % obsolete, corresponds to 'Order','Amplitude'
        ranked.type = 'Boolean';
        ranked.default = 0;
    options.ranked = ranked;
        
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
        %reso.type = 'String';
        %reso.choice = {0,'SemiTone'};
        reso.default = 0;
    options.reso = reso;
    
        resofirst.key = 'First';
        resofirst.type = 'Boolean';
        resofirst.default = 0;
    options.resofirst = resofirst;
    
        resoloose.key = 'Loose';
        resoloose.type = 'Boolean';
        resoloose.default = 0;
    options.resoloose = resoloose;
        
        c.key = 'Pref';
        c.type = 'Integer';
        c.number = 2;
        c.default = [0 0];
    options.c = c;
        
        near.key = 'Nearest';
        near.type = 'Integer';
        near.default = NaN;
    options.near = near;
        
        logsc.type = 'String';
        logsc.choice = {'Lin','Log',0};
        logsc.default = 'Lin';
    options.logsc = logsc;
        
        normal.key = 'Normalize';
        normal.type = 'String';
        normal.choice = {'Local','Global'};
        normal.default = 'Global';
    options.normal = normal;

        extract.key = 'Extract';
        extract.type = 'Boolean';
        extract.default = 0;
    options.extract = extract;
    
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


function out = main(in,option,postoption)
    if option.chro
        option.order = 'Abscissa';
    elseif option.ranked
        option.order = 'Amplitude';
    end
    if not(isnan(option.near)) && option.m == 1
        option.m = Inf;
    end
    if isnan(option.thr)
        option.thr = 0;
    else
        if option.vall
            option.thr = 1-option.thr;
        end
    end
    
    s = in{1};
    if length(s.xdata) == 1
        s.peakdim = 'sample';
    else
        s.peakdim = 'element';
    end
    
    res = sig.compute(@routine,s.Ydata,s.peakdim,option);
    s.peak = res{1}; %sig.position(res{1});
    
    out = {s};
end


function out = routine(y,dim,option)
    maxy = y.findglobal(@max);
    miny = y.findglobal(@min);
    y = y.minus(miny).divide(maxy-miny);
    
    res = y.apply(@search,{option},{dim},1,'{}');
    out = {res};
end


function m = search(y,option)
    dy = diff(y);
    % Let's find the local maxima
    m = find(y(2:end-1) >= option.cthr & y(2:end-1) >= option.thr & ...     
             dy(1:end-1) > 0 & dy(2:end) <= 0);
    m = m+1;
    if isempty(m)
        return
    end
         
    if option.cthr
        finalm = [];
        if ~isempty(m)
            wait = 0;
            if length(m)>5000
                wait = waitbar(0,['Selecting peaks... (0 out of 0)']);
            end
        end
        j = 1;  % Scans the peaks from begin to end.
        mj = m(1); % The current peak
        jj = j+1;
        bufmin = Inf;
        bufmax = y(mj);
        oldbufmin = min(y(1:m(1)-1));
        while jj <= length(m)
            if wait && not(mod(jj,5000))
                waitbar(jj/length(m),wait,['Selecting peaks... (',...
                                            num2str(length(finalm)),...
                                            ' out of ',num2str(jj),')']);
            end
            bufmin = min(bufmin,min(y(m(jj-1)+1:m(jj)-1)));
            if bufmax - bufmin < option.cthr
                % There is no contrastive notch
                if y(m(jj)) > bufmax && ...
                        (y(m(jj)) - bufmax > option.first ...
                        || (bufmax - oldbufmin < option.cthr))
                    % If the new peak is significantly
                    % higher than the previous one,
                    % The peak is transfered to the new
                    % position
                    j = jj;
                    mj = m(j); % The current peak
                    bufmax = y(mj);
                    oldbufmin = min(oldbufmin,bufmin);
                    bufmin = Inf;
                elseif y(m(jj)) - bufmax <= option.first
                    bufmax = max(bufmax,y(m(jj)));
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
                bufmax = y(m(jj));
                j = jj;
                mj = m(j); % The current peak
                bufmin = Inf;
            end
            jj = jj+1;
        end
        if bufmax - oldbufmin >= option.cthr && ...
                bufmax - min(y(m(j)+1:end)) >= option.cthr
            % The last peak candidate is OK and stored
            finalm(end+1) = m(j);
        end
        if wait
            waitbar(1,wait);
            close(wait);
            drawnow
        end
        m = finalm;
    end
    
    if length(m) > option.m
        [unused,idx] = sort(y(m),'descend');
        idx = idx(1:option.m);
        m = m(idx);
    end
end