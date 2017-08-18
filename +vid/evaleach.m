% VID.EVALEACH performs the top-down traversal of the design flowchart, at 
% the beginning of the evaluation phase.
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function y = evaleach(design,filename,video,nargout,frame,chunking)
if nargin<5
    frame = [];
end
if nargin<6
    chunking = 0;
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
    
    data = vid.read(filename,window);
    
    if ~isempty(frame) && frame.toggle
        frate = sig.compute(@sig.getfrate,sr,frame);
        data = data.frame(frame,sr);
        y = {vid.Video(data,'Name','video',...
            'Sstart',(window(1)-1)/sr,'Srate',sr,...
            'Ssize',data.size('sample'),...
            'Frate',frate,'fnumber',data.size('frame'))};
    else
        y = {vid.Video(data,'Name','video',...
            'Sstart',(window(1)-1)/sr,'Srate',sr,...
            'Ssize',data.size('sample'))};
    end
else
    frame = design.frame;
    if chunking % Already in a chunk decomposition process
        input = design.input;
        if iscell(input)
            input = input{1};
        end
        y = vid.evaleach(input,filename,video,1,frame,chunking);
        main = design.main;
        if iscell(main)
            main = main{1};
        end
        y = main(y,design.options);
        if chunking == 1
            y = design.after(y,design.options);
        end
    else
        f = figure;
        while video.CurrentTime < video.Duration
            image = readFrame(video);
            if ~f.isvalid
                disp('Video interrupted')
                break
            end
            imagesc(image);
            drawnow
        end
        close(f);
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