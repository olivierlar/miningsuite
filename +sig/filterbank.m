% SIG.FILTERBANK
% performs a filterbank decomposition of an audio waveform
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = filterbank(varargin)
    varargout = sig.operate('sig','filterbank',sig.filterbank.options(),...
                            @init,@main,@after,varargin,'concat');
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function x = main(x,option)    
    x = sig.filterbank.main(x,option,@sig.filterbank.specif);
end


function x = after(x,option)    
end