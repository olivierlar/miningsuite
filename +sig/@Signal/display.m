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
    
    xdata = obj.xdata;
    if isempty(xdata)
        disp(['The ' obj.yname ' is empty.']);
        return
    end
    sdata = obj.sdata;
    
    nchans = obj.Ydata.size('freqband');
    if iscell(nchans)
        nchans = nchans{1};
    end
    
    %%    
    if ~obj.Srate || isequal(obj.Ydata.size('sample',1), 1)
        if isempty(xdata) || length(xdata) == 1
            textual(obj.yname,obj.Ydata.content);
            return
        end
        abscissa = 'xdata';
        Xaxis = obj.Xaxis;
        yname = '';
        yunit = '';
        ydata = obj.Ydata;
        iscurve = (length(obj.Sstart) == 1);  
        
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
                if iscell(ydatai.content)
                    for j = 1:length(ydatai.content)
                        ydatai.apply(@draw,{obj.(abscissa),obj.Frate,'index',j},{dim,'channel'},2);
                    end
                else
                    ydatai.apply(@draw,{obj.(abscissa),obj.Frate,'index',0},{dim,'channel'},2);
                end
            elseif iscell(ydatai.content)
                for j = 1:length(ydatai.content)
                    x = obj.Sstart(j) + [0, obj.Ssize(j)];
                    y = xdata{j}';
                    y(end+1) = 2 * y(end) - y(end-1);
                    surfplot(x,y,ydatai.content{j});
                end
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
                    for j = 1:length(p.content)
                        pj = p.content{j};
                        if ~isempty(pj)
                            px = Xaxis.data(pj');
                            py = ydatai.view(dim,pj(:),'channel',j);
                            plot(px,squeeze(py),'or');
                        end
                    end
                elseif iscell(ydatai.content)
                    for k = 1:length(ydatai.content)
                        pk = p;
                        pk.content = p.content{k};
                        if pk.size('sample') == 1
                            pk = pk.content{1};
                            if ~isempty(pk)
                                py = obj.Xaxis.data(pk'+.5);
                                px = obj.Sstart(k) + obj.Ssize(k) / 2;
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
            
            if i-1 == floor((nchans-1)/2) && ~isempty(yname)
                if ~isempty(yunit)
                    label = [yname,' (',yunit,')'];
                else
                    label = yname;
                end
                ylabel(label);
            end
        end
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


function draw(y,x,frate,index,segment)
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
    elseif segment
        plot(x{segment},y{segment});
    else
        plot(x,y);
    end
end


function drawmat(z,x,y)
    x(end+1) = 2*x(end) - x(end-1);
    y = [1.5*y(1)-0.5*y(2);...
         (y(1:end-1)+y(2:end))/2;...
         1.5*y(end)-0.5*y(end-1)];
    surfplot(x,y,z')
end


function surfplot(x,y,c)
    cax = newplot([]);
    surface(x,y,zeros(size(y,1),size(x,2)),c,'parent',cax,'EdgeColor','none');  % Here are the modification
    lims = [min(min(x)) max(max(x)) min(min(y)) max(max(y))];
    set(cax,'View',[0 90]);
    set(cax,'Box','on');
    axis(cax,lims);
end
