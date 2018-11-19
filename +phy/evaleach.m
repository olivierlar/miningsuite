% PHY.EVALEACH
%
% Copyright (C) 2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%

function y = evaleach(design,filename,d,nargout)

% if iscell(design)
%     design = design{1};
% end

if isempty(design.main)
    % The top-down traversal of the design flowchart now reaches the lowest
    % layer, i.e., file loading.
    % Now the actual evaluation will be carried out bottom-up.
    
    dd = d.data;
     yd = zeros(d.nFrames,d.nMarkers,3);
     j = 1;
     for i = 1:d.nMarkers
         yd(:,i,1) = dd(:,j);
         yd(:,i,2) = dd(:,j+1);
         yd(:,i,3) = dd(:,j+2);
         j = j + 3;
     end
     
     missing = [];
     for i = 1:size(yd,2)
         f = find(isnan(yd(:,i,:)));
         if ~isempty(f)
             disp(['Warning: Missing data for marker ',num2str(i),' for ',num2str(size(f,1)),' frames.'])
         end
         if isempty(missing)
             missing.point = i;
             missing.frames = f;
         else
             missing(end+1).point = i;
             missing(end).frames = f;
         end
     end
     
     dat = sig.data(yd,{'sample','point','dim'});
%      if isfield(d,'label')
%          label = d.label;
%      else
%          label = [];
%      end
     y = phy.Point(dat,'Srate',d.freq,'Missing',missing); %'Points',label
     y.design.files = {design.files};
else
    y = phy.evaleach(design.input,filename,d,nargout);
    if iscell(y)
        y = y{1};
    end
    main = design.main;
    if iscell(main)
        main = main{1};
    end
    y = main(y,design.options);
    y = design.after(y,design.options);
end