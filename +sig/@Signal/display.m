% SIG.SIGNAL.DISPLAY
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function display(obj)
    if obj.polyfile
        for i = 1:length(obj.Ydata)
            file = obj.selectfile(i);
            display(file);
        end
        return
    end
    
    if isempty(obj.files)
        filemessage = '';
    else
        filemessage = [' related to file ' obj.files];
    end
    
    xdata = obj.xdata;
    if isempty(xdata)
        disp(['The ' obj.yname filemessage ' is empty.']);
        return
    end
    sdata = obj.sdata;
    
    nchans = obj.Ydata.size('freqband');
    if iscell(nchans)
        nchans = nchans{1};
    end
    
    %%    
    if length(obj.Sstart) > 1 && iscell(xdata)
        iscurve = 0;
        Xaxis = obj.saxis;
        yname = obj.Xaxis.name;
        if ~isempty(obj.Xaxis.subunit) && ...
                strcmp(obj.Xaxis.subunit.dimname,obj.Xaxis.name)
            yunit = obj.Xaxis.subunit.unitname;
        else
            yunit = obj.Xaxis.unit.name;
        end
        ydata = obj.Ydata;
    elseif length(obj.Sstart) > 1 && ~obj.Srate
        if iscell(obj.Sstart) 
            iscurve = 2;
            abscissa = 'sdata';
            Xaxis = obj.saxis;
            yname = '';
            yunit = obj.yunit;
            ydata = obj.Ydata;
        else
            iscurve = 1;
            abscissa = 'sdata';
            Xaxis = obj.saxis;
            yname = '';
            yunit = '';
            ydata = obj.Ydata;
        end
    elseif isempty(obj.Srate) || ~obj.Srate || isequal(obj.Ydata.size('sample',1), 1)
        if isempty(xdata) || length(xdata) == 1
            if length(obj.fbchannels) > 1
                figure
                obj.Ydata.apply(@drawchannel,{obj.fbchannels},{'freqband'});
                title(obj.yname);
                xlabel('Channels');
                if ~isempty(obj.yunit)
                    ylabel(['(' obj.yunit ')'])
                end
                if ~isempty(obj.label)
                    set(gca,'YTick',1:length(obj.label));
                    set(gca,'YTickLabel',obj.label);
                end
            else
                ydata = obj.Ydata.content;
                if iscell(ydata) && isnumeric(ydata{1}) && length(ydata) > 1
                    figure, hold on
                    for i = 1:length(ydata)
                        plot(0,ydata{i},'+');
                    end
                    title(obj.yname);
                    if ~isempty(obj.yunit)
                        ylabel(['(' obj.yunit ')'])
                    end
                    if ~isempty(obj.label)
                        set(gca,'YTick',1:length(obj.label));
                        set(gca,'YTickLabel',obj.label);
                    end
                    fig = gcf;
                    if isa(fig,'matlab.ui.Figure')
                        fig = fig.Number;
                    end
                    disp(['The ' obj.yname filemessage ' is displayed in Figure ',num2str(fig),'.']);
                else
                    textual(obj.yname,obj.Ydata.content,obj.yunit,obj.label,filemessage);
                end
            end
            return
        else
            abscissa = 'xdata';
            Xaxis = obj.Xaxis;
            yname = '';
            yunit = '';
            ydata = obj.Ydata;
            iscurve = (length(obj.Sstart) <= 1);  
        end
        
    elseif length(xdata) < 2
        switch length(xdata)
            case 0
                % Variable number of data points per sample
                iscurve = -1;
            case 1
                iscurve = 1;
        end
        abscissa = 'sdata';
        Xaxis = obj.saxis;
        yname = '';
        yunit = '';
        ydata = obj.Ydata;
        
    else
        iscurve = 0;
%         f = sdata;
%         t = [f 2*f(end)-f(end-1)];
%         x = xdata(:);
%         x = [ 1.5*x(1) - 0.5*x(2); ...
%               (x(1:end-1) + x(2:end)) / 2; ...
%               1.5*x(end) - 0.5*x(end-1) ];
        Xaxis = obj.saxis;
        yname = obj.Xaxis.name;
        yunit = obj.Xaxis.unit.name;
        ydata = obj.Ydata.format({'element','sample'});
    end

    %%
    figure
    hold on
    
    if iscurve && nchans > 20
        if obj.Srate
            ydata.apply(@drawmat,{sdata,(1:nchans)'},{'sample','freqband'},2);
        else
            ydata.apply(@drawmat,{xdata,(1:nchans)'},{'element','freqband'},2);
        end
        set(gca,'YDir','normal');   
        title(obj.yname);
    else
        fc = obj.fbchannels;
        ylims = zeros(nchans,2);
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
                if strcmp(abscissa,'xdata')
                    dim = 'element';
                elseif strcmp(abscissa,'sdata')
                    dim = 'sample';
                end
                if iscurve == 2
                    ydatai.apply(@drawpointseg,{obj.Sstart,obj.Send},{'sample'},1);
                else
                    ydatai.apply(@draw,{obj.(abscissa),obj.Frate,'frame'},{dim,'channel'},2);
                    ylims(i,:) = ylim;
                end
            elseif iscell(ydatai.content)
                ydatai.apply(@drawmatseg,{xdata,obj.Sstart,obj.Send,obj.Srate},{'sample','element'},2);
                axis tight
            else
                ydatai.apply(@drawmat,{sdata,xdata(:)},{'sample','element'},2);
                set(gca,'YDir','normal');
            end
            
            if ~isempty(obj.peakindex)
                if nchans == 1
                    p = obj.peakindex;
                else
                    p = obj.peakindex.extract('freqband',i);
                end
                
                if iscurve
                    p.apply(@drawpeaks,{obj.(abscissa),ydatai,obj.Frate,'frame'},{dim,'channel'},1,'{}');
                elseif iscell(ydatai.content)
                    for k = 1:length(ydatai.content)
                        pk = p;
                        pk.content = p.content{k};
                        if pk.size('sample') == 1
                            pk = pk.content{1};
                            if ~isempty(pk)
                                py = obj.Xaxis.data(pk'+.5);
                                sstart = obj.Sstart(k);
                                if iscell(sstart)
                                    sstart = sstart{1};
                                end
                                px = sstart + obj.Ssize(k) / 2;
                                plot(px,py,'+k');
                            end
                        else
                            for j = 1:pk.size('sample')
                                pj = pk.view('sample',j);
                                if ~isempty(pj{1})
                                    px = obj.saxis.data(j+.5);
                                    py = obj.Xaxis.data(pj{1}');
                                    plot(px,py,'+k');
                                end
                            end
                        end
                    end
                else
                    for j = 1:obj.peakindex.size('sample')
                        pj = p.view('sample',j);
                        if ~isempty(pj{1})
                            px = obj.saxis.data(j+.5);
                            py = obj.Xaxis.data(pj{1}');
                            plot(px,py,'+k');
                        end
                    end
                end
            end
            
            if i == 1
                if ~isempty(Xaxis.subunit) && strcmp(Xaxis.subunit.dimname,Xaxis.name)
                    xunit = Xaxis.subunit.unitname;
                else
                    xunit = Xaxis.unit.name;
                end
                if ~isempty(xunit)
                    label = [Xaxis.name,' (',xunit,')'];
                else
                    label = Xaxis.name;
                end
                xlabel(label);
            end
            
            if i-1 == floor((nchans-1)/2)
                if isempty(yname)
                    if ~isempty(yunit)
                        ylabel(['(',yunit,')'])
                    end
                else
                    if ~isempty(yunit)
                        label = [yname,' (',yunit,')'];
                    else
                        label = yname;
                    end
                    ylabel(label);
                end
            end
            
            if ~isempty(obj.label)
                set(gca,'YTick',1:length(obj.label));
                set(gca,'YTickLabel',obj.label);
            end
            
            if nchans > 1
                if iscell(fc)
                    ci = fc{i};
                else
                    ci = num2str(i);
                end
                pos = get(gca,'Position');
                axes('Position',[pos(1)-.05 pos(2)+pos(4)/2 .01 .01],'Visible','off');
                t = text(0,0,ci,'FontSize',12);
%                 t.Rotation = 90;
                t.HorizontalAlignment = 'center';
            end
        end
        
        if nchans > 1
            dyl = diff(ylims,1,2);
            mdyl = max(dyl);
            for i = 1:nchans
                subplot(nchans,1,nchans-i+1,'align');
                ycen = mean(ylims(i,:));
                ylim([ycen - mdyl / 2, ycen + mdyl / 2]);
            end
        end
        
        if isempty(obj.files)
            title(obj.yname)
        else
            title([obj.yname ', ' obj.files]);
        end
    end
    fig = gcf;
    if isa(fig,'matlab.ui.Figure')
        fig = fig.Number;
    end
    disp(['The ' obj.yname filemessage ' is displayed in Figure ',num2str(fig),'.']);
end


function textual(name,data,unit,label,filemessage)
    if ~isempty(label)
        if isnumeric(data) && length(data) == 1
            disp(['The ' name filemessage ' is ' label{data}]);
        else
            disp(['The ' name filemessage ' is :']);
            if iscell(data)
                for i = 1:length(data)
                    display(label{data{i}});
                end
            else
                display(label{data});
            end
        end
    elseif isnumeric(data) && length(data) == 1
        disp(['The ' name filemessage ' is ' num2str(data) ' ' unit]);
    else
        disp(['The ' name filemessage ' is :']);
        if iscell(data)
            for i = 1:length(data)
                display(data{i});
            end
        else
            display(data);
        end
    end
end


function draw(y,x,frate,index)
    if frate
        if iscell(x)
            x = x{1};
        end
        if iscell(y)
            y = y{1};
        end
        x = x + (index-1) / frate;
        plot(x,y,'k');
        y(isnan(y)) = [];
        y(isinf(y)) = [];
        if ~isempty(y)
            rectangle('Position',[x(1),...
                min(min(y)),...
                x(end)-x(1),...
                max(max(y))-...
                min(min(y))]+1e-16,...
                'EdgeColor','k',...
                'Curvature',.1,'LineWidth',1)
        end
    elseif length(x) == 1
        plot(x,y,'+');
    elseif iscell(y)
        if length(y) == 1 && length(x) > 1
            plot(x,y{1});
        elseif iscell(x)
            for i = 1:length(y)
                if ~isempty(y{i})
                    plot(x{i},y{i},'+');
                end
            end
        else
            for i = 1:length(y)
                if ~isempty(y{i})
                    plot(x(i),y{i},'+');
                end
            end
        end
    elseif iscell(x)
        plot(y);
        set(gca,'XTick',1:length(x));
        set(gca,'XTickLabel',x);
    else
        plot(x,y);
    end
end


function drawmat(z,x,y)
    x(end+1) = 2*x(end) - x(end-1);
    if iscell(y)
        l = y;
        y = (1:length(y))';
    else
        l = {};
    end
    y = [1.5*y(1)-0.5*y(2);...
         (y(1:end-1)+y(2:end))/2;...
         1.5*y(end)-0.5*y(end-1)];
    surfplot(x,y,z')
    if ~isempty(l)
        set(gca,'YTick',1:length(y));
        set(gca,'YTickLabel',l);
    end
end


function drawpointseg(y,x1,x2)
    if iscell(y)
        y = y{1};
    end
    for i = 1:length(y)
        plot([x1,x2],[y(i),y(i)]);
    end
end


function drawmatseg(z,y,Sstart,Send,Srate)
    if Srate
        x = Sstart + (0:size(z,1))/Srate;
    else
        x = [Sstart,Send];
    end
    if iscell(y)
        l = y;
        y = (1:length(y))';
    else
        l = {};
    end
    y(end+1) = 2 * y(end) - y(end-1);
    surfplot(x,y(:),z')
    if ~isempty(l)
        set(gca,'YTick',1.5:length(y)+.5);
        set(gca,'YTickLabel',l);
    end
end


function surfplot(x,y,c)
    cax = newplot([]);
    surface(x,y,zeros(size(y,1),size(x,2)),c,'parent',cax,'EdgeColor','none');  % Here are the modification
    lims = [min(min(x)) max(max(x)) min(min(y)) max(max(y))];
    set(cax,'View',[0 90]);
    set(cax,'Box','on');
    axis(cax,lims);
end


function drawpeaks(p,x,y,frate,index)
    if iscell(p)
        p = p{1};
    end
    if iscell(x)
        plot(p,y(p),'or')
    elseif frate
        x = x + (index-1) / frate;
        plot(x(p),y(p),'or')
    else
        plot(x(p),y(p),'or')
    end
end


function drawchannel(y,x)
    if iscell(y)
        y = cell2mat(y);
    end
    plot(x,y,'+');
end