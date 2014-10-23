function [x, type] = init(x,option,frame)
    type = 'sig.signal';
    if not(strcmpi(option.filtertype,'NoFilterBank'))
        x = aud.filterbank(x,option.filtertype);
    end
    if ~isempty(frame) && frame.toggle
        x = sig.frame(x,'FrameSize',frame.size.value,frame.size.unit,...
                        'FrameHop',frame.hop.value,frame.hop.unit);
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