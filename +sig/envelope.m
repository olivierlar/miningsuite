% SIG.ENVELOPE
% extracts the envelope, showing the global shape of the waveform
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = envelope(varargin)
    varargout = sig.operate('sig','envelope',sig.envelope.options,...
                            @sig.envelope.init,...
                            @sig.envelope.main,@after,...
                            varargin,'concat','extensive');
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    if ~x.processed
        if strcmpi(option.method,'Spectro')
            option.trim = 0;
            option.ds = 0;
        elseif strcmpi(option.method,'Filter')        
            option.ds = option.ds(1);
            if isnan(option.ds)
                if option.decim
                    option.ds = 0;
                else
                    option.ds = 16;
                end
            end
        end
        x = sig.envelope.resample(x,option);
        x = sig.envelope.rescale(x,option);
        x = sig.envelope.upsample(x,option);
        x.processed = 1;
    end
    x = sig.envelope.diff(x,option);
    x = sig.envelope.after(x,option);
    out = {x};
end