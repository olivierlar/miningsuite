function [x,type] = init(x,option,frame)
    type = 'sig.Envelope';
    if x.istype('sig.Envelope')
        return
    end
    if option.zp ~= 2 && ~isa(x,'seq.Sequence')
        if isa(x,'sig.Signal')
            x = init_audio(x,option);
        elseif isa(x,'sig.design')
            x = [init_audio(x,option),x];
        end
    end
end


function x = init_audio(x,option)
    if strcmpi(option.method,'Filter')
        if isnan(option.zp)
            if strcmpi(option.filter,'IIR')
                option.zp = 1;
            else
                option.zp = 0;
            end
        end
        if option.zp == 1
            x = sig.envelope(x,'ZeroPhase',2,'Down',1,...
                            'Tau',option.tau,'PreDecim',option.decim);
            if isa(x,'sig.design')
                x.tmpfile.fid = 0;
            end
        end
    elseif strcmpi(option.method,'Spectro')
        x = aud.spectrum(x,'FrameSize',option.spectroframe(1),...
                           'FrameHop',option.spectroframe(2),...
                           'Window','hanning',option.band,...
                           ...'dB',
                           'Power',option.powerspectrum,...
                           'TimeSmooth',option.timesmooth,...
                           'Terhardt',option.terhardt);%,'Mel');
    end
end