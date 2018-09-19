% SIG.SYNC
%
% Copyright (C) 2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

classdef sync
%%
    properties
        audiofilename
        audiodelay
        data
        datadelays
        channel_ids
        nbplots
        plotdelays
    end
%%
    methods
        function s = sync(varargin)
            audiofilename = '';
            audiodelay = 0;
            data = {};
            datadelays = [];
            channel_ids = zeros(0,2);
            nbplots = 0;
            plotdelays = [];
            i = 1;
            while i <= nargin
                argin = varargin{i};
                if ischar(argin)
                    audiofilename = argin;
                    if i < nargin && isnumeric(varargin{i+1})
                        i = i + 1;
                        audiodelay = varargin{i};
                    end
                elseif isa(argin,'sig.Signal') || isa(argin,'sig.design')
                    datargin = argin;
                    if isa(datargin,'sig.design')
                        datargin = datargin.eval{1};
                    end
                    data{end+1} = datargin;
                    nchans = datargin.Ydata.size('freqband');
                    if iscell(nchans)
                        nchans = nchans{1};
                    end
                    channel_ids(end+1,1) = nbplots + 1;
                    nbplots = nbplots + nchans;
                    channel_ids(end,2) = nbplots;
                    if i < nargin && isnumeric(varargin{i+1})
                        i = i + 1;
                        datadelays(end+1) = varargin{i};
                    else
                        datadelays(end+1) = 0;
                    end
                    plotdelays(end+1:end+nchans) = datadelays(end);
                end
                i = i + 1;
            end
            s.audiofilename = audiofilename;
            s.audiodelay = audiodelay;
            s.data = data;
            s.datadelays = datadelays;
            s.channel_ids = channel_ids;
            s.nbplots = nbplots;
            s.plotdelays = plotdelays;
        end
        
        function display(obj)
            nch = obj.nbplots;
            figure
            hold on
            i = 0;
            for h = 1:length(obj.data)
                d = obj.data{h};
                fc = d.fbchannels;
                nchans = d.Ydata.size('freqband');
                if iscell(nchans)
                    nchans = nchans{1};
                end
                ylims = zeros(nchans,2);
                i0 = i;
                for j = nchans:-1:1
                    i = i + 1;
                    subplot(nch,1,i)
                    hold on
                    if nchans > 1
                        dj = d.Ydata.extract('freqband',j);
                    else
                        dj = d.Ydata;
                    end
                    if length(d.xdata) < 2
                        dj.apply(@draw,{d.sdata,d.Frate,'frame'},{'sample'},1);
                        ylims(i,:) = ylim;
                    else
                        dj.apply(@drawmat,{d.sdata,d.xdata(:)},{'sample','element'},2);
                        set(gca,'YDir','normal');
                    end
                    axis tight
                    
                    if iscell(fc)
                        cj = fc{j};
                    else
                        cj = num2str(j);
                    end
                    pos = get(gca,'Position');
                    axes('Position',[pos(1)-.05 pos(2)+pos(4)/2 .01 .01],'Visible','off');
                    t = text(0,0,cj,'FontSize',12);
%                     t.Rotation = 90;
                    t.HorizontalAlignment = 'center';
                end
                if nchans > 1
                    dyl = diff(ylims,1,2);
                    mdyl = max(dyl);
                    ii = i0+1;
                    for j = nchans:-1:1
                        subplot(nch,1,ii);
                        ycen = mean(ylims(ii,:));
                        ylim([ycen - mdyl / 2, ycen + mdyl / 2]);
                        ii = ii + 1;
                    end
                end
            end
        end
        
        function play(obj)
            a = sig.signal(obj.audiofilename);
            a = a.eval{1};
            audiorate = get(a,'Srate');
            a = a.getdata;
            
            display(obj);
            
            ap = audioplayer(a(:,1),audiorate);
            play(ap)
            
            nch = obj.nbplots;
            h = cell(nch,1);
            t = ap.CurrentSample / audiorate + obj.audiodelay;
            while ap.isplaying
                for i = 1:nch
                    if ~isempty(h{i})
                        delete(h{i});
                    end
                    subplot(nch,1,i)
                    hold on
                    ti = t - obj.plotdelays(i);
                    h{i} = plot([ti,ti],ylim,'r');
                end
                drawnow
                t = ap.CurrentSample / audiorate + obj.audiodelay;
            end
            for i = 1:nch
                if ~isempty(h{i})
                    delete(h{i});
                end
                drawnow
            end
        end
        
        function record(obj)
            display(obj);
            set(gcf,'Position',[0,0,1600,800])
            nch = obj.nbplots;
            h = cell(nch,1);
            rate = 1;
            writerObj = VideoWriter('play.avi','Uncompressed AVI');
            writerObj.FrameRate = rate;
            open(writerObj);
            t = 0;
            while 1
                for i = 1:nch
                    if ~isempty(h{i})
                        delete(h{i});
                    end
                    subplot(nch,1,i)
                    hold on
                    ti = t - obj.plotdelays(i);
                    h{i} = plot([ti,ti],ylim,'r');
                end
                drawnow
                frame = getframe(gcf);
                writeVideo(writerObj,frame);
                t = t + 1/rate;
            end
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