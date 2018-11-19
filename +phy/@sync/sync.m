% PHY.SYNC
%
% Copyright (C) 2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

classdef sync
%%
    properties
        audiofilename
%         audiodelay
        data
    end
%%
    methods
        function s = sync(varargin)
            audiofilename = '';
%             audiodelay = 0;
            data = {};
            i = 1;
            while i <= nargin
                argin = varargin{i};
                if ischar(argin)
                    audiofilename = argin;
%                     if i < nargin && isnumeric(varargin{i+1})
%                         i = i + 1;
%                         audiodelay = varargin{i};
%                     end
                else
                    if isa(argin,'sig.design')
                        argin = argin.eval;
                        argin = argin{1};
                    end
                    if isa(argin,'phy.Point')
                        datargin = argin;
                        data{end+1} = datargin;
                    end
                end
                i = i + 1;
            end
            s.audiofilename = audiofilename;
%             s.audiodelay = audiodelay;
            s.data = data;
        end
        
        function display(obj)
            fig = figure;
            pref = phy.pref;
            hold on
            ap = [];

            if ~isempty(obj.audiofilename)
                a = sig.signal(obj.audiofilename);
                a = a.eval{1};
                audiorate = get(a,'Srate');
                a = a.getdata;
                ap = audioplayer(a(:,1),audiorate);
                play(ap)
            end
            
            l = length(obj.data);
            nfr = size(obj.data{1}.Ydata.content,1);
            ax = zeros(l,6);
            for h = 1:l
                w = obj.data{h}.Ydata.content;
                ax(h,:) = [min(min(w(:,:,1))),max(max(w(:,:,1))),...
                           min(min(w(:,:,2))),max(max(w(:,:,2))),...
                           min(min(w(:,:,3))),max(max(w(:,:,3)))];
            end
            connect = obj.data{1}.connect;
            k = 1;
            if isempty(ap) && pref.dropFrame
                tic
            end
            while k <= nfr
                if ~isempty(ap)
                    t = ap.CurrentSample / audiorate; % + obj.audiodelay;
                    k = find(obj.data{1}.sdata > t,1);
                    if isempty(k)
                        break
                    end
                elseif pref.dropFrame
                    k = find(obj.data{1}.sdata > toc,1);
                    if isempty(k)
                        break
                    end
                end
                for h = 1:l
                    subplot(1,l,h,'replace')
                    axis(ax(h,:))
%                     set(gca, 'color', 'k');
                    hold on
                    w = obj.data{h}.Ydata.content;
                    for i = 1:size(w,2)
                        plot3(w(k,i,1),w(k,i,2),w(k,i,3),'ok','MarkerSize',2);
                        text(w(k,i,1),w(k,i,2),w(k,i,3),num2str(i));
                    end
                    for i = 1:size(connect,1)
                        plot3(w(k,connect(i,:),1),w(k,connect(i,:),2),w(k,connect(i,:),3),'-k')
                    end
                end
                drawnow limitrate %nocallbacks
                if ~fig.isvalid
                    disp('Animation interrupted')
                    break
                end
                if isempty(ap) && ~pref.dropFrame
                    k = k + 1;
                end
            end
        end
    end
end