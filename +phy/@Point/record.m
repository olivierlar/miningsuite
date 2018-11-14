% PHY.POINT.RECORD
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function record(obj)
    sig.compute(@routine,obj.Ydata,obj.yname,obj.Srate,...
                obj.diffed,obj.files,obj.connect);
end


function out = routine(obj,name,srate,diffed,filename,connect)
    fig = figure;
    fignum = fig;
    if isa(fig,'matlab.ui.Figure')
        fignum = fig.Number;
    end
    
    writerObj = VideoWriter('record.avi','Uncompressed AVI');
    writerObj.FrameRate = 10;
    open(writerObj);
    
    switch diffed
        case 1
            name = [name ' Velocity'];
        case 2
            name = [name ' Acceleration'];
    end
    
    pref = phy.pref;

    disp(['The ',name,' related to file ',filename{1},...
        ' is displayed in Figure ',num2str(fignum),'.']);
    w = obj.content; %{1}{1};
    ax = [min(min(w(:,:,1))),max(max(w(:,:,1))),...
            min(min(w(:,:,2))),max(max(w(:,:,2))),...
            min(min(w(:,:,3))),max(max(w(:,:,3)))];
    for k = 1:10:size(w,1)
        clf
        axis(ax)
        hold on
        for i = 1:size(w,2)
            plot3(w(k,i,1),w(k,i,2),w(k,i,3),'ok','MarkerSize',2);
            if pref.displayIndex
                text(w(k,i,1),w(k,i,2),w(k,i,3),num2str(i));
            end
        end
        for i = 1:size(connect,1)
            plot3(w(k,connect(i,:),1),w(k,connect(i,:),2),w(k,connect(i,:),3),'-k')
        end
        drawnow limitrate
        
        if ~fig.isvalid
            disp('Animation interrupted')
            break
        end
        
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    out = {};
end