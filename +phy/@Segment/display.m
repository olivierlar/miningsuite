% PHY.SEGMENT.DISPLAY
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function display(obj)
    sig.compute(@routine,obj.Ydata,obj.yname,obj.sdata,...
                obj.label,obj.diffed,obj.files,obj.connect);
end


function out = routine(obj,name,sdata,label,diffed,filename,connect)
    fig = figure;
    fignum = fig;
    if isa(fig,'matlab.ui.Figure')
        fignum = fig.Number;
    end
    switch diffed
        case 1
            name = [name ' Velocity'];
        case 2
            name = [name ' Acceleration'];
    end

    pref = phy.pref;

    disp(['The ',name,' related to file ',filename{1},...
        ' is displayed in Figure ',num2str(fignum),'.']);
%     set(gcf, 'color', 'k');
    w = obj.content; %{1}{1};
    ax = [min(min(w(:,:,1))),max(max(w(:,:,1))),...
            min(min(w(:,:,2))),max(max(w(:,:,2))),...
            min(min(w(:,:,3))),max(max(w(:,:,3)))];
    k = 1;
    if pref.dropFrame
        tic
    end
    while k <= size(w,1)
        if pref.dropFrame
            k = find(sdata > toc,1);
            if isempty(k)
                break
            end
        end
        clf
        axis(ax)
%         set(gca, 'color', 'k');
        hold on
        view([-37.5 -30])
        for i = 1:size(w,2)
            plot3(w(k,i,1),w(k,i,2),w(k,i,3),'ok','MarkerSize',2); %,'MarkerEdgeColor','k','MarkerFaceColor','k');
        end
        for i = 1:size(connect,1)
            plot3(w(k,connect(i,:),1),w(k,connect(i,:),2),w(k,connect(i,:),3),'-k')
            if pref.displayIndex
                text(mean(w(k,connect(i,:),1)),mean(w(k,connect(i,:),2)),...
                    mean(w(k,connect(i,:),3)),num2str(i));
            end
        end
        drawnow limitrate %nocallbacks
        
        if ~fig.isvalid
            disp('Animation interrupted')
            break
        end
        if ~pref.dropFrame
            k = k + 1;
        end

    end
    out = {};
end