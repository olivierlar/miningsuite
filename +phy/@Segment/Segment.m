% phy.Segment class
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Segment < phy.Point
    properties (Constant)
    end
    properties   
        parent = [];
        roottrans = [];
        rootrot = [];
        eucl = [];
        r = [];
        quat = [];
        angle = [];
        spar = [];
    end
    methods
        function s = Segment(varargin)
            parent = [];
            roottrans = [];
            rootrot = [];
            eucl = [];
            r = [];
            quat = [];
            angle = [];
            i = 1;
            while i < length(varargin)
                if strcmpi(varargin{i},'Parent')
                    varargin(i) = [];
                    parent = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'RootTrans')
                    varargin(i) = [];
                    roottrans = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'RootRot')
                    varargin(i) = [];
                    rootrot = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Eucl')
                    varargin(i) = [];
                    eucl = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'R')
                    varargin(i) = [];
                    r = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Quat')
                    varargin(i) = [];
                    quat = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Angle')
                    varargin(i) = [];
                    angle = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            s = s@phy.Point(varargin{:});
            if strcmp(s.yname,'Point Trajectory')
                s.yname = 'Segment Trajectory';
            end
            s.parent = parent;
            s.roottrans = roottrans;
            s.rootrot = rootrot;
            s.eucl = eucl;
            s.r = r;
            s.quat = quat;
            s.angle = angle;
        end
        
        function d = get(obj,field)
            if strcmpi(field,'parent')
                d = obj.parent;
            elseif strcmpi(field,'roottrans')
                d = obj.roottrans;
            elseif strcmpi(field,'rootrot')
                d = obj.rootrot;
            elseif strcmpi(field,'eucl')
                d = obj.eucl;
            elseif strcmpi(field,'r')
                d = obj.r;
            elseif strcmpi(field,'quat')
                d = obj.quat;
            elseif strcmpi(field,'angle')
                d = obj.angle;
            else
                d = get@sig.Signal(obj,field);
            end
        end
        
        display(obj)
    end
end