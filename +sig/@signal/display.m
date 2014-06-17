function display(obj)
    if obj.polyfile
        for i = 1:length(obj.Ydata.content)
            file = obj.selectfile(i);
            display(file);
        end
        return
    end
    
    %%    
    if ~obj.Srate
        iscurve = 1;
        abscissa = 'xdata';
        Xaxis = obj.Xaxis;
        ydata = obj.Ydata;
        
    elseif length(obj.xdata) == 1
        iscurve = 1;
        abscissa = 'sdata';
        Xaxis = obj.Saxis;
        ydata = obj.Ydata;
        
    else
        iscurve = 0;
        f = obj.sdata;
        t = [f 2*f(end)-f(end-1)];
        x = obj.xdata';
        x = [ 1.5*x(1) - 0.5*x(2); ...
              (x(1:end-1) + x(2:end)) / 2; ...
              1.5*x(end) - 0.5*x(end-1) ];
        Xaxis = obj.Saxis;
        ydata = obj.Ydata.format({'element','sample'});
    end

    %%
    figure
    
    nchans = obj.Ydata.size('channel');
    for i = 1:nchans
        if nchans > 1
            subplot(nchans,1,nchans-i+1,'align');
            ydatai = ydata.extract('channel',i);
        else
            ydatai = ydata;
        end
        
        if iscurve
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
                p = obj.peak.extract('channel',i);
            end
            
            if iscurve
                pi = p.content{1};
                px = Xaxis.unit.generate(pi);
                py = ydatai.content(pi);
                plot(px,squeeze(py),'or');
            else
                for j = 1:obj.peak.size('sample')
                    pj = p.view('sample',j);
                    px = obj.Saxis.unit.generate(j+.5);
                    py = obj.Xaxis.unit.generate(pj{1});
                    plot(px,py,'+k');
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