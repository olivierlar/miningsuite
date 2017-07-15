% AUD.ENVELOPE
% auditory modeling of envelope extraction
%
% Copyright (C) 2014, Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = envelope(varargin)
    varargout = sig.operate('aud','envelope',initoptions,...
                            @sig.envelope.init,@sig.envelope.main,@after,...
                            varargin,'concat','extensive');
end


function options = initoptions
    options = sig.envelope.options;
    %options.method.default = 'Spectro';
    options.diffhwr.default = 1;
    options.up.default = 2;
    
        mu.key = 'Mu';
        mu.type = 'Numeric';
        mu.default = 100;
    options.mu = mu;
    
        lambda.key = 'Lambda';
        lambda.type = 'Numeric';
        lambda.default = .8;
    options.lambda = lambda;
end


function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    if strcmpi(option.method,'Spectro')
        option.trim = 0;
        option.ds = 0;
    elseif strcmpi(option.method,'Filter')        
        option.ds = option.ds(1);
        if isnan(option.ds)
            if option.decim
                option.ds = 0;
            else
                option.ds = 16;
            end
        end
    end
    x = sig.envelope.resample(x,option);
    
    if option.mu
        x.Ydata = sig.compute(@routine_rescale,x.Ydata,option.mu);
    end
    x = sig.envelope.rescale(x,option);
    
    x = sig.envelope.upsample(x,option);

    if (option.diffhwr || option.diff) && ~x.diff
        if isfield(option,'lambda') && not(option.lambda)
            option.lambda = 1;
        end
        x.Ydata = sig.envelope.diff(x,option);
        
        x.Ydata = sig.compute(@routine_lambda,x.Ydata,...
                              option.lambda,x.Srate);
    end
    
    x = sig.envelope.after(x,option);
    
    out = {x};
end


function d = routine_rescale(d,mu)
    d = d.apply(@rescale,{mu},{'sample'});
end


function x = rescale(x,mu)
    x = max(0,x);
    x = log(1+mu*x)/log(1+mu);
    x(~isfinite(x)) = NaN;
end


function d = routine_lambda(d,lambda,Srate)
    d = d.times(1-lambda).plus(d.times(lambda*Srate/10));
end