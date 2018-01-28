% SIG.ZEROCROSS
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = zerocross(varargin)
    varargout = sig.operate('sig','zerocross',...
                            initoptions,@init,@main,@after,varargin); 
                        %,'plus'); Chunk works if input is sig.Signal but
                        % not if for instance it is sig.Autocor. Needs to
                        % adapt chunk strategy based on input 
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);

        per.key = 'Per';
        per.type = 'String';
        per.choice = {'Second','Sample'};
        per.default = 'Second';
    options.per = per;

        dir.key = 'Dir';
        dir.type = 'String';
        dir.choice = {'One','Both'};
        dir.default = 'One';
    options.dir = dir;
end


%%
function [x type] = init(x,option,frame)
    if option.frame
        x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                        'FrameHop',option.fhop.value,option.fhop.unit);
    end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    if x.xsampling
        res = sig.compute(@routine,x.Ydata,1/x.xsampling,'element',option);
        x = sig.Signal(res,'Name','Zero-crossing rate');
    elseif x.Srate
        res = sig.compute(@routine,x.Ydata,x.Srate,'sample',option);
        x = sig.Signal(res,'Name','Zero-crossing rate',...
            'Deframe',x);
    else
        warning ('WARNING IN ZEROCROSS: Unrecognized input. Nothing done');
    end
    out = {x};
end


function out = routine(d,rate,dim,option)
    d = d.apply(@algo,{option,rate},{dim},3);
    if strcmp(dim,'sample')
        d = d.deframe;
    end
    out = {d};
end


function y = algo(x,option,sr)
    y = sum(x(2:end,:,:).*x(1:end-1,:,:) < 0);
    if strcmp(option.per,'Second')
        y = y * sr;
    end
    if strcmp(option.dir,'One')
        y = y / 2;
    end
    
    y = y / size(x,1);      % replace afternorm for the moment
end


function x = after(x,option)
%     if iscell(x)
%         x = x{1};
%     end
%     x.Ydata = sig.compute(@routine_norm,x.Ydata,x.Ssize);
%     out = {x};
end


% function d = routine_norm(d,Ssize)
%     d = d.apply(@afternorm,{Ssize},{'element'},Inf);
% end
% 
% 
% function d = afternorm(d,l)
%     d = d/l;
% end