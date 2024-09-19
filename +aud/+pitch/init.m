% AUD.PITCH.INIT
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [x, type] = init(x,option)
    if x.istype('sig.Autocor')
        x = sig.autocor(x,'Min',option.mi,'Hz','Max',option.ma,'Hz');
    elseif x.istype('sig.Cepstrum')
    elseif x.istype('sig.Spectrum')
        if ~(option.ce || option.s || option.as)
            option.ce = 1;
        end
        if option.ce
            x = sig.cepstrum(x,'Freq','Min',option.mi,'Hz',...
                                      'Max',option.ma,'Hz');
        elseif option.as
            x = sig.autocor(x,'Freq',...
                            'Min',option.mi,'Hz','Max',option.ma,'Hz');
        end
    else
        if option.tolo
            option.enh = 2:10;
            option.gener = .67;
            option.filtertype = '2Channels';
        end
        
        if ~(option.ac || option.ce || option.s || option.as)
            option.ac = 1;
        end
        if option.ac
            if not(strcmpi(option.filtertype,'NoFilterBank'))
                x = aud.filterbank(x,option.filtertype);
            end
            if option.frame
                x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                    'FrameHop',option.fhop.value,option.fhop.unit);
            end
            x = sig.autocor(x,'Generalized',option.gener);
            if option.sum
                x = sig.sum(x);
            end
            x = sig.autocor(x,'Enhanced',option.enh,'Freq');
            x = sig.autocor(x,'Min',option.mi,'Hz','Max',option.ma,'Hz');
        else
            if option.frame
                x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                    'FrameHop',option.fhop.value,option.fhop.unit);
            end
            x = sig.spectrum(x,'Min',option.mi,'Max',option.ma,...
                             'Res',option.res,'dB',option.db,...
                             'Normal',option.norm);
            if option.ce
                x = sig.cepstrum(x,'Freq','Min',option.mi,'Hz',...
                    'Max',option.ma,'Hz');
            elseif option.as
                x = sig.autocor(x,'Freq',...
                    'Min',option.mi,'Hz','Max',option.ma,'Hz');
            end
        end
    end
    
    if option.mono
        option.total = 1;
    end
    x = sig.peaks(x,'Total',option.total,...'Track',option.track,...
               'Contrast',option.cthr,'Threshold',option.thr,...
               'Reso',option.reso,'NoBegin','NoEnd',...
               'Order',option.order);
           
    type = 'sig.Signal';
end