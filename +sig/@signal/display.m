function display(obj)
    if obj.polyfile
        for i = 1:length(obj.Ydata)
            file = obj.selectfile(i);
            display(file);
        end
        return
    end
    
    %%    
    if ~obj.Srate || obj.Ydata.size('sample',1) == 1
        if isempty(obj.xdata)
            textual(obj.yname,obj.Ydata.content);
            return
        end
        abscissa = 'xdata';
        Xaxis = obj.Xaxis;
        ydata = obj.Ydata;
        iscurve = (length(obj.Sstart) == 1);  
        
    elseif length(obj.xdata) < 2   
        switch length(obj.xdata)
            case 0
                % Variable number of data points per sample
                iscurve = -1;
            case 1
                iscurve = 1;
        end            
        abscissa = 'sdata';
        Xaxis = obj.saxis;
        ydata = obj.Ydata;
        
    else
        iscurve = 0;
        f = obj.sdata;
        t = [f 2*f(end)-f(end-1)]; %% Caution: does not work with frames longer than input
        x = obj.xdata(:);
        x = [ 1.5*x(1) - 0.5*x(2); ...
              (x(1:end-1) + x(2:end)) / 2; ...
              1.5*x(end) - 0.5*x(end-1) ];
        Xaxis = obj.saxis;
        ydata = obj.Ydata.format({'element','sample'});
    end

    %%
    figure
    hold on
    
    nchans = obj.Ydata.size('freqband');
    if iscell(nchans)
        nchans = nchans{1};
    end
    for i = 1:nchans
        if nchans > 1
            subplot(nchans,1,nchans-i+1,'align');
            hold on
            ydatai = ydata.extract('freqband',i);
        else
            ydatai = ydata;
        end
        
        if iscurve
            if iscurve == -1 && iscell(ydatai.content)
                varpeaks = 0;
                for j = 1:length(ydatai.content)
                    if length(ydatai.content{j}) > 1
                        varpeaks = 1;
                        break
                    end
                end
                if ~varpeaks
                    iscurve = 1;
                    d = zeros(1,length(ydatai.content));
                    for j = 1:length(ydatai.content)
                        if isempty(ydatai.content{j})
                            d(j) = NaN;
                        else
                            d(j) = ydatai.content{j};
                        end
                    end
                    ydatai.content = d;
                end
            end
            if iscell(ydatai.content)
                if strcmp(abscissa,'sdata')
                    sdata = obj.sdata;
                    if iscell(sdata)
                        for j = 1:length(ydata.content)
                            plot(sdata{j},squeeze(ydatai.content{j}));
                        end
                    else
                        for j = 1:length(ydata.content)
                            plot(sdata(j),squeeze(ydatai.content{j}),'+');
                        end
                    end
                else
                    
                end
            else
                plot(obj.(abscissa),squeeze(ydatai.content));
            end
        elseif iscell(ydatai.content)
            for j = 1:length(ydatai.content)
                x = obj.Sstart(j) + [0, obj.Ssize(j)];
                y = obj.xdata{j}';
                y(end+1) = 2 * y(end) - y(end-1);
                surfplot(x,y,ydatai.content{j});
            end
        else
            surfplot(t,x,ydatai.content)
            set(gca,'YDir','normal');
        end
                
        if ~isempty(obj.peak)
            if nchans == 1
                p = obj.peak;
            else
                p = obj.peak.extract('freqband',i);
            end
            
            if iscurve
                pi = p.content{1};
                px = Xaxis.unit.generate(pi);
                py = ydatai.content(pi);
                plot(px,squeeze(py),'or');
            elseif iscell(ydatai.content)
                for k = 1:length(ydatai.content)
                    pk = p;
                    pk.content = p.content{k};
                    if pk.size('sample') == 1
                        pk = pk.content{1};
                        if ~isempty(pk)
                            py = obj.Xaxis.unit.generate(pk+.5);
                            px = obj.Sstart(k) + obj.Ssize(k) / 2;
                            plot(px,py,'+k');
                        end
                    else
                        for j = 1:pk.size('sample')
                            pj = pk.view('sample',j);
                            if ~isempty(pj{1})
                                px = obj.saxis.unit.generate(j+.5);
                                py = obj.Xaxis.unit.generate(pj{1});
                                plot(px,py,'+k');
                            end
                        end
                    end
                end
            else
                for j = 1:obj.peak.size('sample')
                    pj = p.view('sample',j);
                    if ~isempty(pj{1})
                        px = obj.saxis.unit.generate(j+.5);
                        py = obj.Xaxis.unit.generate(pj{1});
                        plot(px,py,'+k');
                    end
                end
            end
        end
        
        if i == 1
            xlabel(Xaxis.name);
        end
        axis tight
        
        title(obj.yname);
    end
    fig = gcf;
    if isa(fig,'matlab.ui.Figure')
        fig = fig.Number;
    end
    disp(['The ' obj.yname ' is displayed in Figure ',num2str(fig),'.']);
end


function textual(name,data)
    disp(['The ' name ' is:']);
    display(data);
end