% SIG.SPECTRUM
% decomposes energy along frequencies
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = spectrum(varargin)
    varargout = sig.operate('sig','spectrum',sig.spectrum.options,...
                            @init,@main,varargin,'sum');
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.Spectrum';
end


function out = main(x,option,postoption)
    if ~isempty(option)
        if ~isempty(postoption)
            if option.phase && ...
                    (~isempty(postoption.msum) || ~isempty(postoption.mprod) ...
                     || postoption.log || postoption.db || postoption.pow ...
                     || postoption.aver || postoption.gauss)
                option.phase = 0;
            end
        end
        x = sig.spectrum.main(x,option,postoption);
    end
    if isempty(postoption)
        out = {x};
    else
        out = sig.spectrum.after(x,postoption);
    end
end