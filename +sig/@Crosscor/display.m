% SIG.CROSSCOR.DISPLAY
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function display(obj)
    sig.compute(@routine,obj.Ydata,obj.sdata,obj.maxlag,obj.xdata,obj.files,obj.fbchannels);
end


function out = routine(in,t,maxlag,x,name,fbchannels)
    fig = figure;
    d = in.content;
    N = size(d,2);
    k = 0;
    clims = [0 1];
    for i = 1:N
        for j = 1:N
            k = k + 1;
            if i <= j
                subplot(N,N,k);
                if size(d,4) == 1
                    plot(x,d(:,i,j));
                else
                    imagesc([t(1),t(end)],[-maxlag,maxlag],squeeze(d(:,i,j,:)),clims);
                end
                if i == 1
                    title(fbchannels{N-j+1})
                end
                if i == j
                    l = ylabel(fbchannels{N-j+1},'Rotation',0,'FontWeight','bold');
                    p = get(l,'Position');
                    set(l,'Position',p);
                end
            end
        end
    end
    
    if isa(fig,'matlab.ui.Figure')
        fig = fig.Number;
    end
    disp(['The crosscorrelation matrix related to file ',name,...
        ' is displayed in Figure ',num2str(fig),'.']);
    out = {};
    
%     ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     text(0.5, 0.98,['Crosscorrelation matrices, ' name])
end