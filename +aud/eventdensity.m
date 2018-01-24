% AUD.EVENTDENSITY 
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = eventdensity(varargin)
    varargout = sig.operate('aud','eventdensity',initoptions,@init,@main,...
                            @after,varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameManual',5,.2,'After');
end


%%
function [x type] = init(x,option)
    if isa(x,'sig.design')
        x = x.eval;
        if iscell(x)
            x = x{1};
        end
    end
    if ~isa(x,'aud.Sequence')
        x = aud.score(x);
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    if isempty(in.content)
        d = sig.data([],{'sample'});
    else
        t1 = in.content{1}.parameter.getfield('onset').value;
        tend = in.content{end}.parameter.getfield('onset').value;
        if option.frame
            if strcmpi(option.fsize.unit,'s')
                fsize = option.fsize.value;
            elseif strcmpi(option.fsize.unit,'sp')
                error('Error: ''sp'' not adequate for symbolic data');
            end
            if strcmpi(option.fhop.unit,'/1')
                fhop = option.fhop.value*fsize;
            elseif strcmpi(option.fhop.unit,'%')
                fhop = option.fhop.value*fsize*.01;
            elseif strcmpi(option.fhop.unit,'s')
                fhop = option.fhop.value;
            elseif strcmpi(option.fhop.unit,'sp')
                error('Error: ''sp'' not adequate for symbolic data');
            elseif strcmpi(option.fhop.unit,'Hz')
                fhop = 1/option.fhop.value;
            end
            nbframes = max(1,floor((tend-fsize)/fhop)+1); % Number of frames
        else
            nbframes = 1;
            fsize = tend-t1;
            fhop = 0;
        end
        
        t = zeros(1,nbframes);
        ed = zeros(1,nbframes);
        i1 = 1;
        for i = 1:nbframes
            t(i) = t1 + (i-1) * fhop;
            i2 = i1;
            while in.content{i2}.parameter.getfield('onset').value < t(i)+fsize
                i2 = i2+1;
                if i2 > length(in.content)
                    break
                end
            end
            ed(i) = (i2 - i1) / fsize;
            while in.content{i1}.parameter.getfield('onset').value < t(i)+fhop
                i1 = i1+1;
                if i1 > length(in.content)
                    break
                end
            end
        end
        d = sig.data(ed',{'sample'});
    end
    ed = sig.Signal(d,'Name','Event density','Srate',1/fhop); %'FbChannels',x.fbchannels??
    out = {ed};
end


function x = after(x,option)
end