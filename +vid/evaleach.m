% VID.EVALEACH performs the top-down traversal of the design flowchart, at 
% the beginning of the evaluation phase.
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function y = evaleach(design,filename,video,nargout,y)
if nargin<5
    y = [];
end

sr = video.FrameRate;
d = video.Duration;

if iscell(design)
    design = design{1};
end

%sg = d.segment;

if isempty(design.main)
    % The top-down traversal of the design flowchart now reaches the lowest
    % layer, i.e., file loading.
    % Now the actual evaluation will be carried out bottom-up.
    
    data = readFrame(video);
    
    if isequal(y, 0)
        y = vid.Video(data,'Name','video');
    else
        if size(y.Ydata.content,4) > 1
            y.Ydata.content(:,:,:,1) = y.Ydata.content(:,:,:,2);
        end
        y.Ydata.content(:,:,:,2) = data;
    end
else
    if ~isempty(y) % Already in a chunk decomposition process
        input = design.input;
        if iscell(input)
            input = input{1};
        end
        y = vid.evaleach(input,filename,video,1,y);
        main = design.main;
        if iscell(main)
            main = main{1};
        end
        y = main(y,design.options);
        y = design.after(y,design.options);
    else
        f = figure;
        y = 0;
        while video.CurrentTime < video.Duration
            y = vid.evaleach(design.input,filename,video,nargout,y);
            main = design.main;
            if iscell(main)
                main = main{1};
            end
            y = main(y,design.options);
            y = design.after(y,design.options);
            
            if ~f.isvalid
                disp('Video interrupted')
                break
            end
            imagesc(abs(y.Ydata.content(:,:,:,end)));
            title(filename)
            drawnow
        end
        if f.isvalid
            close(f);
        end
        y = {};
    end
end


% if iscell(y)
%     for i = 1:length(y)
%         if isa(y{i},'vid.Video')
%             if ischar(design)
%                 y{i}.design = {filename};
%             else
%                 y{i}.design = design(1);
%                 y{i}.design.evaluated = 1;
%                 y{i}.design.files = filename;
%             end
%         end
%     end
% end