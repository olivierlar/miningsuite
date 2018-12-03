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
    display('Filling missing data.');
    d = d.apply(@routine,{},{'sample'},1);
    out = {d};
end


function d = routine(d)
%     maxfill = Inf;
%     method = [];

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
%                 if gaplength(m)>maxfill
%                     notfilled(gapstart(m):gapend(m)) = 1;
%                     display(['Warning: Data not filled for marker x for ',gapend(m)-gapstart(m)+1,' frames.']);
%                 end
            end
        end

        ind2 = min(ind1):max(ind1); % interpolation range


%         d2(ind2,k) = interp1(ind1, d(ind1,k), ind2,'cubic');
        d(ind2) = interp1(ind1, d(ind1), ind2,'PCHIP'); %recommended by Matlab #BB_20150302
        d(find(notfilled)) = NaN;
    end
end