% SIG.ENVELOPE.DIFF
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
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
        d = d.apply(@diff,{},{'sample'});
    end
    if postoption.diffhwr
        d = d.hwr;
    end
end


% function y = zdiff(x)
%     y = [zeros(1,size(x,2),size(x,3)); diff(x)];
% end
%     