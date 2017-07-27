% SIG.ENVELOPE.INIT
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [x,type] = init(x,option,frame)
    type = 'sig.Envelope';
    if x.istype('sig.Envelope')
        return
    end
    if ~isa(x,'seq.Sequence')
        if isa(x,'sig.Signal')
            x = init_audio(x,option);
        elseif isa(x,'sig.design')
            x = [init_audio(x,option),x];
        end
    end
end


function x = init_audio(x,option)
    if strcmpi(option.method,'Filter')
        if isa(x,'sig.design')
            decim = option.decim(end);
            if isnan(decim)
                if option.decim
                    decim = 0;
                else
                    decim = 16;
                end
            end
            if ~decim
                decim = 1;
            end
            x.overlap = [6400,decim]; %3200
        end
    elseif strcmpi(option.method,'Spectro')
        x = aud.spectrum(x,'FrameSize',option.spectroframe(1),...
                           'FrameHop',option.spectroframe(2),...
                           'Window','hanning',option.band,...
                           ...'dB',
                           'Power',option.powerspectrum,...
                           'TimeSmooth',option.timesmooth,...
                           'Terhardt',option.terhardt);
    end
end