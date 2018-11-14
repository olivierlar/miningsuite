% PHY.POINT
%
% Copyright (C) 2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = point(varargin)
varargout = sig.operate('phy','point',options,@init,@main,@after,...
                        varargin,'concat_sample');


function options = options
options = sig.Signal.signaloptions('FrameAuto',.05,.5);

    fill.key = 'Fill';
    fill.type = 'Boolean';
    fill.when = 'After';
    fill.default = 0;
options.fill = fill;

    connect.key = 'Connect';
    connect.when = 'After';
    connect.default = [];
options.connect = connect;

    reduce.key = 'Reduce';
    reduce.when = 'After';
    reduce.default = [];
options.reduce = reduce;

    extract.key = {'Extract','Excerpt'};
    extract.type = 'Unit';
    extract.number = 2;
    extract.default = [];
    extract.unit = {'s','sp'};
options.extract = extract;

    velocity.key = 'Velocity';
    velocity.type = 'Boolean';
    velocity.when = 'After';
    velocity.default = 0;
options.velocity = velocity;

    acceleration.key = 'Acceleration';
    acceleration.type = 'Boolean';
    acceleration.when = 'After';
    acceleration.default = 0;
options.acceleration = acceleration;

    filter.key = 'Filter';
    filter.type = 'Numeric';
    filter.when = 'After';
    filter.default = 2;
options.filter = filter;

    cutoff.key = 'CutOff';
    cutoff.type = 'Numeric';
    cutoff.when = 'After';
    cutoff.default = .2;
options.cutoff = cutoff;

    norm.key = 'PerSecond';
    norm.type = 'Boolean';
    norm.when = 'After';
    norm.default = 1;
options.norm = norm;

                        
function [d,type] = init(d,option)
if isstruct(d)
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
             disp(['Warning: Missing data for point ',num2str(i),' for ',num2str(size(f,1)),' frames.'])
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
    filename = d.filename;
    d = phy.Point(dat,'Srate',d.freq,'Label',d.markerName,'Missing',missing); % 'NCameras',d.nCameras,
    d.design.files = {filename};
end
type = 'phy.Point';
    

function out = main(x,option)
if iscell(x)
    x = x{1};
end
out = x;


function out = after(obj,option)
if iscell(obj)
    obj = obj{1};
end

if isa(obj,'sig.design')
    obj = obj.eval;
    obj = obj{1};
end

if ~isempty(option.extract)
    obj = obj.extract(option.extract,'sample','saxis','Ydata');
end

if option.fill
    obj = obj.fill;
end

if option.acceleration
    if obj.diffed < 2
        obj = obj.diff(2 - obj.diffed,option.filter,option.cutoff,option.norm);
        obj.diffed = 2;
    end
elseif option.velocity
    if ~obj.diffed
        obj = obj.diff(1,option.filter,option.cutoff,option.norm);
        obj.diffed = 1;
    end
end

connect = option.connect;
if ~isempty(connect)
    if isstruct(connect)
        connect = connect.conn;
    end
    obj.connect = connect;
end

if ~isempty(option.reduce)
    obj.label = option.reduce.markerName;
    l = length(option.reduce.markerNum);
    d = zeros(size(obj.Ydata.content,1),l,3);
    for i = 1:l
        d(:,i,:) = mean(obj.Ydata.content(:,option.reduce.markerNum{i},:),2);
    end
    obj.Ydata.content = d;
end

out = {obj};