% SIG.ENVELOPE.DIFF
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.


function e = diff(e,postoption)
    if (postoption.diffhwr || postoption.diff) && ~e.diff
        e.Ydata = sig.compute(@main,e.Ydata,postoption);
        e.diff = 1;
    end
end


function d = main(d,postoption)
    if postoption.complex
        error('Option not available yet.')
    else
        d = d.apply(@zdiff,{},{'sample'});
    end
    if postoption.diffhwr
        d = d.apply(@hwr,{},{'sample'});
    end
end


function y = hwr(x)
    % Half-Wave Rectifier
    y = 0.5 * (x + abs(x));
end


function y = zdiff(x)
    y = [zeros(1,size(x,2),size(x,3)); diff(x)];
end
    