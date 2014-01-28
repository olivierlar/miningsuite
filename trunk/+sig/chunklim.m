function cl = chunklim(lim)
% c = sig.chunklim returns the maximal chunk size.
%   If the size of a long audio files exceeds that size, it will be
%   decomposed into chunks of that size, before being analyzed in the 
%   different functions on the toolbox.
% sig.chunklim(c) specifies a new maximal chunk size.
%   If The MiningSuite tends to use more memory than what is available in the
%   RAM of your computer, you should decrease the maximal chunk size.
% sig.chunklim(Inf) toggles off the automated chunk decomposition.

persistent chunklim

if nargin
    if not(isnumeric(lim))
        error('ERROR IN SIG.CHUNKLIM: The argument should be a number.')
    end
    chunklim = lim;
else
    if isempty(chunklim)
        chunklim = 5e5;
    end
end

cl = chunklim;