function mov = display(obj)
% SIMATRIX/DISPLAY display of simatrix
    sig.compute(@routine,obj.Ydata,obj.files);
end


function out = routine(obj,name)
    fig = figure;
    d = obj.content;
    imagesc(d);
    if isa(fig,'matlab.ui.Figure')
        fig = fig.Number;
    end
    disp(['The simatrix related to file ',name,...
                ' is displayed in Figure ',num2str(fig),'.']);
    out = {};
end