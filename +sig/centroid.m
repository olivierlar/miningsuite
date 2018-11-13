% SIG.CENTROID
%
% Copyright (C) 2017-2018 Olivier Lartillot
% Copyright (C) 2007-2009 Olivier Lartillot & University of Jyvaskyla
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = centroid(varargin)
    varargout = sig.operate('sig','centroid',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.Signal.signaloptions('FrameAuto',.05,.5);
    
        input.type = 'String';
        input.choice = {'Direct','Distribution','Spectrum'};
        input.default = 'Direct';
    options.input = input;
    
        dim.key = 'Across';
        dim.type = 'String';
        dim.default = '';
    options.dim = dim;

end


%%
function [x,type] = init(x,option)
%     if x.istype('sig.Signal')
        if option.frame
            x = sig.frame(x,'FrameSize',option.fsize.value,option.fsize.unit,...
                          'FrameHop',option.fhop.value,option.fhop.unit);
        end
        if strcmpi(option.input,'Spectrum')
            x = sig.spectrum(x);
        end
%     end
    type = 'sig.Signal';
end


function out = main(in,option)
    x = in{1};
    distrib = strcmpi(option.input,'Distribution');
    res = sig.compute(@routine,x.Ydata,x.xdata,x.sdata,distrib,option.dim);
    name = 'Centroid';
    if strcmpi(option.input,'Spectrum')
        name = ['Spectral ', name];
    elseif distrib
        name = ['Distribution ', name];
    elseif strcmpi(option.input,'Waveform')
        %name = ['Waveform ', name];
    end
    x = sig.Signal(res,'Name',name,...
        'Srate',x.Srate,'Sstart',x.Sstart,'Send',x.Send,...
        'Ssize',x.Ssize,'FbChannels',x.fbchannels);
    out = {x};
end


function out = routine(d,f,s,distrib,dim)
    if isempty(dim)
        if max(strcmp('element',d.dims))
            dim = 'element';
            x = f;
        else
            dim = 'sample';
            x = s;
        end
    end
    if strcmp(dim,'element')
        x = f;
    elseif strcmp(dim,'sample')
        x = s;
    end
    if distrib
        e = d.apply(@mean,{},{dim},1);
    else
        e = d.apply(@sig.centroid.algo,{x},{dim},1);
    end
    out = {e};
end


function x = after(x,option)
end