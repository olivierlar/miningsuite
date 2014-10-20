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
            e.Ydata = sig.compute(@routine_resample,e.Ydata,newsr,sr);
        end
    elseif postoption.ds>1
        if postoption.ds ~= round(postoption.ds)
            error('Error in sig.envelope: The ''Down'' sampling rate should be an integer.');
        end
        e.Ydata = sig.compute(@routine_downsample,e.Ydata,postoption.ds);
    end
    e.Srate = newsr;

    if not(strcmpi(e.method,'Spectro')) && postoption.trim 
        tdk = round(newsr*.1); 
        d{k}{i}(1:tdk,:,:) = repmat(d{k}{i}(tdk,:,:),[tdk,1,1]); 
        d{k}{i}(end-tdk+1:end,:,:) = repmat(d{k}{i}(end-tdk,:,:),[tdk,1,1]);
    end
end


function d = routine_resample(d,newsr,sr)
    d = d.apply(@resample,{newsr,sr},{'sample'});
end


function d = routine_downsample(d,ds)
    d = d.apply(@downsample,{ds},{'sample'});
end