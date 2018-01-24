% AUD.ENVELOPE
% auditory modeling of envelope extraction
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = envelope(varargin)
    varargout = sig.operate('aud','envelope',initoptions,...
                            @init,@main,@after,...
                            varargin,'concat','extensive');
end


function options = initoptions
    options = sig.envelope.options;
    
        presel.type = 'String';
        presel.choice = {'Klapuri06'};
        presel.default = 0;
    options.presel = presel;
    
        mu.key = 'Mu';
        mu.type = 'Numeric';
        mu.default = 0;
        mu.keydefault = 100;
    options.mu = mu;
    
        lambda.key = 'Lambda';
        lambda.type = 'Numeric';
        lambda.default = 0;
        lambda.keydefault = .8;
    options.lambda = lambda;
end


function [x,type] = init(x,option)
    if ischar(option.presel) && strcmpi(option.presel,'Klapuri06')
        option.method = 'Spectro';
    end
    [x,type] = sig.envelope.init(x,option);
end


function out = main(x,option)
    if isfield(option,'presel') && ischar(option.presel) && ...
            strcmpi(option.presel,'Klapuri06')
        option.method = 'Spectro';
        option.up = 2;
        option.mu = 100;
        option.diffhwr = 1;
        option.lambda = .8;
    end
    out = sig.envelope.main(x,option);
end


function out = after(x,option)
    if isfield(option,'presel') && ischar(option.presel) && ...
            strcmpi(option.presel,'Klapuri06')
        option.method = 'Spectro';
        option.up = 2;
        option.mu = 100;
        option.diffhwr = 1;
        option.lambda = .8;
    end
    if iscell(x)
        x = x{1};
    end
    if ~x.processed
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
        x.processed = 1;
    end

    if (option.diffhwr || option.diff) && ~x.diff
        if isfield(option,'lambda') && not(option.lambda)
            option.lambda = 1;
        end
        x = sig.envelope.diff(x,option);
        
        x.Ydata = sig.compute(@routine_lambda,x.Ydata,...
                              option.lambda,x.Srate);
    end
    
    x = sig.envelope.after(x,option);
    
    if isfield(option,'presel') && ischar(option.presel) && ...
            strcmpi(option.presel,'Klapuri06')
        x = sig.sum(x,'Adjacent',10);
    end
    
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