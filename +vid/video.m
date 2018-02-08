% VID.VIDEO simply loads the video stored in a video file and performs
% basic post-processing.
%
% Copyright (C) 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% See also VID.VIDEO class

function varargout = video(varargin)
varargout = vid.operate('vid','video',...
                        vid.Video.videooptions('FrameAuto',.05,.5),...
                        vid.Video.initmethod,vid.Video.mainmethod,...
                        vid.Video.aftermethod,varargin,'concat_sample');