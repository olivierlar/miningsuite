function e = resample(e,postoption)
    sr = e.Srate;

    if postoption.sampling
        newsr = postoption.sampling;
    elseif postoption.ds>1
        newsr = sr/postoption.ds;
    else
        newsr = sr;
    end
        
    if isfield(postoption,'norm') && ...
            ischar(postoption.norm) && ...
            strcmpi(postoption.norm,'AcrossSegments')
        abse = e.Ydata.apply(@abs,{},{'sample'});
        maxe = e.Ydata.apply(@max,{},{'sample'});
        % Check code in mirenvelope.
    end

    if postoption.sampling
        if sr ~= newsr
            if sr ~= round(sr)
                error('Error in sig.envelope: The ''Sampling'' postoption cannot be used after using the ''Down'' postoption.');
            end
            e.Ydata = e.Ydata.apply(@resample,{newsr,sr},{'sample'});
        end
    elseif postoption.ds>1
        if postoption.ds ~= round(postoption.ds)
            error('Error in sig.envelope: The ''Down'' sampling rate should be an integer.');
        end
        e.Ydata = e.Ydata.apply(@downsample,{postoption.ds},{'sample'});
    end
    e.Srate = newsr;

    if not(strcmpi(e.method,'Spectro')) && postoption.trim 
        tdk = round(newsr*.1); 
        d{k}{i}(1:tdk,:,:) = repmat(d{k}{i}(tdk,:,:),[tdk,1,1]); 
        d{k}{i}(end-tdk+1:end,:,:) = repmat(d{k}{i}(end-tdk,:,:),[tdk,1,1]);
    end
end