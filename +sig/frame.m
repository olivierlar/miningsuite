% SIG.FRAME
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = frame(varargin)
    out = sig.operate('sig','frame',options,@init,@main,@after,varargin);
    if isa(out{1},'sig.design')
        out{1}.options = out{1}.frame;
    end
    varargout = out;
end


function options = options
    options = sig.Signal.signaloptions();

        frame.key = 'Frame';
        frame.type = 'Boolean';
        frame.default = 1;
    options.frame = frame;
    
        fsize.key = 'FrameSize';
        fsize.type = 'Unit';
        fsize.default.unit = 's';
        fsize.default.value = .05;
        fsize.unit = {'s','sp'};
    options.fsize = fsize;

        fhop.key = 'FrameHop';
        fhop.type = 'Unit';
        fhop.default.unit = '/1';
        fhop.default.value = .5;
        fhop.unit = {'s','sp','Hz','/1'};
    options.fhop = fhop;
end


function [x type] = init(x,option,frame)
    type = 'sig.Signal';
end


function out = main(x,frame)
    x = sig.framenow(x,frame);
    out = {x};
end


function x = after(x,option)
end