% phy.Point class
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Point < sig.Signal
    properties (Constant)
    end
    properties   
%         ncameras = NaN;
%         label = {};
        missing = [];
        connect = [];
        diffed = 0;
    end
    methods
        function s = Point(varargin)
%             ncameras = NaN;
%             label = {};
            missing = [];
            connect = [];
            diffed = 0;
            i = 1;
            while i < length(varargin)
%                 if strcmpi(varargin{i},'NCameras')
%                     varargin(i) = [];
%                     ncameras = varargin{i};
%                     varargin(i) = [];
%                 else
%                 if strcmpi(varargin{i},'Label')
%                     varargin(i) = [];
%                     label = varargin{i};
%                     varargin(i) = [];
%                 else
                if strcmpi(varargin{i},'Missing')
                    varargin(i) = [];
                    missing = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Connect')
                    varargin(i) = [];
                    connect = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Diffed')
                    varargin(i) = [];
                    diffed = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            s = s@sig.Signal(varargin{:});
            if strcmp(s.yname,'Signal')
                s.yname = 'Point Trajectory';
            end
%             switch diffed
%                 case 1
%                     s.yname = [s.yname ' Velocity'];
%                 case 2
%                     s.yname = [s.yname ' Acceleration'];
%             end
            
%             s.ncameras = ncameras;
%             s.label = label;
            s.missing = missing;
            s.connect = connect;
            s.diffed = diffed;
        end
        
        function d = get(obj,field)
%             if strcmpi(field,'ncameras')
%                 d = obj.ncameras;
%             else
%             if strcmpi(field,'label')
%                 d = obj.label;
%             else
                d = get@sig.Signal(obj,field);
%             end
        end
        
        display(obj)
        record(obj)
        obj = fill(obj)
        obj = diff(obj,order,butter_order,butter_cutoff,norm)
    end
end