function display(obj)
    if obj.polyfile
        for i = 1:length(obj.Ydata)
            file = obj.selectfile(i);
            display(file);
        end
        return
    end
    
    %%    
    if ~obj.Srate
        if isempty(obj.xdata)
            textual(obj.yname,obj.Ydata.content);
            return
        end
        iscurve = 1;
        abscissa = 'xdata';
        Xaxis = obj.Xaxis;
        ydata = obj.Ydata;
        
    elseif isempty(obj.xdata) ... % Variable number of data points per sample
            || length(obj.xdata) == 1   % Always one data point per sample
        if length(obj.xdata) == 1
            iscurve = 1;
        else
            iscurve = -1;
        end
        abscissa = 'sdata';
        Xaxis = obj.saxis;
        ydata = obj.Ydata;
        
    else
        iscurve = 0;
        f = obj.sdata;
        t = [f 2*f(end)-f(end-1)];
        x = obj.xdata';
        x = [ 1.5*x(1) - 0.5*x(2); ...
              (x(1:end-1) + x(2:end)) / 2; ...
              1.5*x(end) - 0.5*x(end-1) ];
        Xaxis = obj.saxis;
        ydata = obj.Ydata.format({'element','sample'});
    end

    %%
    figure
    
    nchans = obj.Ydata.size('fb_channel');
    for i = 1:nchans
        if nchans > 1
            subplot(nchans,1,nchans-i+1,'align');
            ydatai = ydata.extract('fb_channel',i);
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
            plot(obj.(abscissa),squeeze(ydatai.content))
        else
            surfplot(t,x,ydatai.content)
            set(gca,'YDir','normal');
        end
        
        hold on
        
        if ~isempty(obj.peak)
            if nchans == 1
                p = obj.peak;
            else
                p = obj.peak.extract('fb_channel',i);
            end
            
            if iscurve
                pi = p.content{1};
                px = Xaxis.unit.generate(pi);
                py = ydatai.content(pi);
                plot(px,squeeze(py),'or');
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
    disp(['The ' obj.yname ' is displayed in Figure ',num2str(gcf),'.']);
end


function textual(name,data)
    disp(['The ' name ' is:']);
    display(data);
end