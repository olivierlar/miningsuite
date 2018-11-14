% PHY.POINT.FILL
%
% Copyright (C) 2018 Olivier Lartillot
% Copyright (C) 2008 University of Jyvasklya, Finland (MoCap Toolbox)
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function obj = fill(obj)
    obj.Ydata = sig.compute(@main,obj.Ydata);
end


function out = main(d)
    d = d.apply(@routine,{},{'sample'},1);
    out = {d};
end


function d = routine(d)
    maxfill = Inf;
    method = [];

    %% % Part of the MoCap Toolbox, Copyright 2008,
       % University of Jyvaskyla, Finland
    nani = isnan(d);
    dnani = diff(nani);
    ind1 = find(1-nani);

    gapstart = find(dnani==1);
    gapend = find(dnani==-1);
    if ~isempty(gapstart)
        if isempty(gapend) gapend=length(d(:,k)); end
        if gapstart(1)>gapend(1) gapstart=[1; gapstart]; end
        if gapstart(end)>gapend(end) gapend=[gapend; length(d(:,k))]; end
        gaplength = gapend-gapstart;
        notfilled = zeros(length(d),1);
        if ~isempty(gapstart)
            for m=1:length(gapstart)
                if gaplength(m)>maxfill
                    notfilled(gapstart(m):gapend(m)) = 1;
                end
            end
        end

        ind2 = min(ind1):max(ind1); % interpolation range


%         d2(ind2,k) = interp1(ind1, d(ind1,k), ind2,'cubic');
        d(ind2) = interp1(ind1, d(ind1), ind2,'PCHIP'); %recommended by Matlab #BB_20150302
        d(find(notfilled)) = NaN;
   end
    
    if ~isempty(method) %if EITHER 'fillall' OR 'nobefill' is set
        if d(1,k)==0 || ~isfinite(d(1,k))%check if there is need to fill in the beginning
            if sum(isnan(d(:,k)))==size(d,1)%FIXBB110103: if marker is empty
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIX NEEDED HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif isempty(gapend) %THIS GETS CONFUSING HERE! IT SHOULD PROBABLY BE TESTED IN THE UPPER_LEVEL IF-CONDITION - SEEMS THAT SEGM DATA WANTS THAT; BUT DONT GET WHY
            elseif strcmp(method,'fillall')
                ge=gapend(1);%get end (frame no) of first gap
                ged=d(ge+1,k);%get data of first recorded frame
                d(1:ge,k)=repmat(ged,ge,1);
            elseif strcmp(method,'nobefill')
                ge=gapend(1);%get end (frame no) of first gap
                d(1:ge,k)=repmat(NaN,ge,1);
            end
        end
        if d(end,k)==0 || ~isfinite(d(end,k))
            if sum(isnan(d(:,k)))==size(d,1)%FIXBB110103: if marker is empty
            elseif isempty(gapstart) %THIS GETS CONFUSING HERE! IT SHOULD PROBABLY BE TESTED IN THE UPPER_LEVEL IF-CONDITION
            elseif strcmp(method,'fillall')
                gs=gapstart(length(gapstart));%get start (frame no) of last gap
                gsd=d(gs-1,k);%get data of start of last gap
                d(gs:end,k)=repmat(gsd,length(gs:length(d)),1);
            elseif strcmp(method,'nobefill')
                gs=gapstart(length(gapstart));%get start (frame no) of last gap
                d(gs:end,k)=repmat(NaN,length(gs:length(d)),1);
            end
        end
    end
end