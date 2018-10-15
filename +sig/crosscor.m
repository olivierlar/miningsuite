% SIG.CROSSCOR
%
% Copyright (C) 2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = crosscor(varargin)
    varargout = sig.operate('sig','crosscor',options,...
                            @init,@main,@after,...
                            varargin,@combinechunks);
end


function options = options    
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);

        max.key = 'Max';
        max.type = 'Unit';
        max.unit = {'s','Hz'};
        max.default = [];
        max.opposite = 'min';
        max.when = 'Both';
    options.max = max;
        
        scaleopt.type = 'String';
        scaleopt.choice = {'biased','unbiased','coeff','none'};
        scaleopt.default = 'coeff';
    options.scaleopt = scaleopt;

        hwr.key = 'Halfwave';
        hwr.type = 'Boolean';
        hwr.when = 'After';
        hwr.default = 0;
    options.hwr = hwr;
end


function [x,type] = init(x,option)
    if option.frame
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
    end
    type = 'sig.Crosscor';
end


function out = main(x,option)
    if iscell(x)
        x = x{1};
    end
    
    if isa(x,'sig.Crosscor')
        out = {x};
        return
    end
    
    if option.frame
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
    end
    
    if isempty(option.max)
        option.max.value = Inf;
        option.max.unit = 's';
    end

    [d,xstart,maxlag] = sig.compute(@routine,x.Ydata,x.Srate,option);
    y = sig.Crosscor(d,'xsampling',1./x.Srate,'Deframe',x,'maxlag',maxlag,'fbchannels',x.fbchannels);
    y.Xaxis.start = xstart;

    out = {y};
end


function out = routine(in,sampling,option)
    l = in.size('sample');
    
    if isstruct(option.max)
        maxt = ceil(option.max.value*sampling)+1;
    else
        maxt = Inf;
    end
    maxt = min(maxt,ceil(l/2));
    
    in = in.center('sample');
    x = in.content;
    N = size(x,2);
    %c = x.apply(@compute,{maxt-1,option.scaleopt},{'sample','freqband'},2);
    for h = 1:size(x,3)
        for i = 1:N
            for j = i:N
                y(:,i,j,h) = xcorr(x(:,N-i+1,h),x(:,N-j+1,h),maxt-1,option.scaleopt);
            end
        end
    end
    in.content = y;
    in.dims{3} = 'channel';
    if size(x,3) > 1
        in.dims{4} = 'frame';
    end
    in = in.deframe;
    out = {in -maxt+2 (maxt-1)/sampling};
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    
    if isfield(option,'tmp')
        tmp = option.tmp;
    else
        tmp = [];
    end

    if ~x.isempty
        if isstruct(option.max)
            if ~isstruct(option.max)
                option.max.value = Inf;
                option.max.unit = 's';
            end
            x = x.extract(option.max,'element','Xaxis','Ydata','window');
        end
        
        if option.hwr
            x = x.halfwave;
        end
    end
    
    out = {x,tmp};
end