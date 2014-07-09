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
                            @sig.envelope.init,@main,varargin,'concat'); %,'extensive');
end


function options = initoptions
    options = sig.envelope.options;
    %options.method.default = 'Spectro';
    options.diffhwr.default = 1;
    
        mu.key = 'Mu';
        mu.type = 'Numeric';
        mu.default = 100;
        mu.when = 'After';
    options.mu = mu;
    
        lambda.key = 'Lambda';
        lambda.type = 'Numeric';
        lambda.default = .8;
        lambda.when = 'After';
    options.lambda = lambda;
end


function out = main(x,option,postoption)    
    [out,postoption,tmp] = sig.envelope.main(x,option,postoption);
    if isempty(postoption)
        out = {out tmp};
    else
        out = {after(out,postoption) tmp};
    end
end


function x = after(x,postoption)
    x = sig.envelope.resample(x,postoption);
    
    if postoption.mu
        x.Ydata = x.Ydata.apply(@rescale,{postoption.mu},{'sample'});
    end
    x = sig.envelope.rescale(x,postoption);
    
    x = sig.envelope.upsample(x,postoption);

    if (postoption.diffhwr || postoption.diff) && ~x.diff
        if isfield(postoption,'lambda') && not(postoption.lambda)
            postoption.lambda = 1;
        end
        d = sig.envelope.diff(x,postoption);
        x.Ydata = x.Ydata.times(1-postoption.lambda)...
                  .plus(d.times(postoption.lambda*x.Srate/10));
    end
    
    x = sig.envelope.after(x,postoption);
end


function x = rescale(x,mu)
    x = max(0,x);
    x = log(1+mu*x)/log(1+mu);
    x(~isfinite(x)) = NaN;
end