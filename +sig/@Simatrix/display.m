% SIG.SIMATRIX.DISPLAY
%
% Copyright (C) 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

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