% AUD.EVENTDENSITY 
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = eventdensity(varargin)
    varargout = sig.operate('aud','eventdensity',initoptions,@init,@main,...
                            varargin);
end


%%
function options = initoptions
        frame.key = 'Frame';
        frame.type = 'Boolean';
        frame.default = 1;
    options.frame = frame;
    
        fsize.key = 'FrameSize';
        fsize.type = 'Unit';
        fsize.default.unit = 's';
        fsize.default.value = 5;
        fsize.unit = {'s'};
    options.fsize = fsize;

        fhop.key = 'FrameHop';
        fhop.type = 'Unit';
        fhop.default.unit = '/1';
        fhop.default.value = .2;
        fhop.unit = {'s','Hz','/1'};
    options.fhop = fhop;
end


%%
function [x type] = init(x,option,frame)
    if ~isa(x,'aud.Sequence')
        x = aud.minr(x);
    end
    type = 'sig.signal';
end


function out = main(in,option,frame)
    in.content;
    
    fsize = frame.size.value;
    fhop = frame.hop.value; % Check unit..
    fhop = fsize * fhop;

    t1 = in.content{1}.parameter.getfield('onset').value;
    tend = in.content{end}.parameter.getfield('onset').value;
    nbframes = ceil((tend - t1) / fhop);
    
    t = zeros(1,nbframes);
    ed = zeros(1,nbframes);
    i1 = 1;
    i2 = 1;
    for i = 1:nbframes
        t(i) = t1 + (i-1) * fhop;
        while in.content{i2}.parameter.getfield('onset').value < t(i)+fhop
            i2 = i2+1;
            if i2 > length(in.content)
                break
            end
        end
        ed(i) = i2 - i1;
    end
        
    d = sig.data(ed',{'sample'});
    ed = sig.signal(d,'Name','Event density','Srate',1/fhop);
    out = {ed};
end