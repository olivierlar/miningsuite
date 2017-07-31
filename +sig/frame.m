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
    options = sig.signal.signaloptions();

        frame.key = 'Frame';
        frame.type = 'Boolean';
        frame.default = 0;
        %frame.inner = strcmpi(inner,'inner');
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
%     x = sig.input(x,'FrameSize',frame.size.value,frame.size.unit,...
%                     'FrameHop',frame.hop.value,frame.hop.unit);
    type = 'sig.signal';
end


function x = main(x,frame)
%     sr = x{1}.Srate;
%     [x{1}.Ydata,x{1}.Ssize,x{1}.fnumber] = ...
%         sig.compute(@routine,x{1}.Ydata,frame,sr);
%     x{1}.Frate = sig.compute(@sig.getfrate,sr,frame);
end


% function out = routine(d,frame,sr)
%     d = d.frame(frame,sr);
%     ssize = d.size('sample');
%     fnumber = d.size('frame');
%     out = {d,ssize,fnumber};
% end


function x = after(x,option)
end