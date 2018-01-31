% AUD.PITCH.INIT
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [x, type] = init(x,option)

    if option.tolo
        option.enh = 2:10;
        option.gener = .67;
        option.filtertype = '2Channels';
    end
    
    type = 'sig.Signal';
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
    x = sig.peaks(x,'Total',option.m,'Track',option.track,...
               'Contrast',option.cthr,'Threshold',option.thr,...
               'Reso',option.reso,'NoBegin','NoEnd',...
               'Order',option.order);
end