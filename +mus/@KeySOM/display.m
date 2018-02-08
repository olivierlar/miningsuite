% MUS.KEYSOM.DISPLAY
%
% Copyright (C) 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function mov = display(obj)
% KEYSOM/DISPLAY display of key som

    mov = [];
    folder = fileparts(which('mus.score'));
    load(fullfile(folder,'keysomaudiodata.mat'));
    sig.compute(@routine,obj.Ydata,obj.files,keyx,keyy,keyN);
end


function out = routine(obj,name,keyx,keyy,keyN)
    fig = figure;
    w = obj.content{1}{1};
    for k = 1:size(w,2)
        pcolor(squeeze(w(:,k,:)));
        shading interp
        axis([1,36,1,24]), view(2) , caxis([-1 1])
        axis off;
        hold on
        for m=1:24
            text(0.99*keyx(m)-1, 0.98*keyy(m)+1, keyN(m,:),...
                'FontSize',16,'FontName','Arial');
        end
        hold off
        set(gca,'PlotBoxAspectRatio',[1.5 1 1])
        colormap('jet')
        title('Self-organizing map projection of chromagram')
        drawnow
    end
    if isa(fig,'matlab.ui.Figure')
        fig = fig.Number;
    end
    disp(['The key som related to file ',name,...
                ' is displayed in Figure ',num2str(fig),'.']);
    out = {};
end