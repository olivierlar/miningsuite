% AUD.ENVELOPE.DISPLAY
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function display(obj)
    if obj.polyfile
        for i = 1:length(obj.Ydata)
            file = obj.selectfile(i);
            display(file);
        end
        return
    end
    
    display@sig.Signal(obj);
    
    on = obj.onsets;
    at = obj.attacks;    
    if ~isempty(on)
        on.apply(@drawattacks,{at,obj.sdata,obj.Ydata},{'sample'},1);
    end
    
    de = obj.decays;
    of = obj.offsets;
    if ~isempty(of)
        de.apply(@drawdecays,{of,obj.sdata,obj.Ydata},{'sample'},1);
    end
end


function drawattacks(on,at,x,y)
    on = on{1};
    at = at{1};
    plot(x(on),y(on),'dm') 
    plot(x(at),y(at),'dm')
    for i = 1:length(on)
        line([x(on(i)),x(at(i))],[y(on(i)),y(at(i))],'Color','m')
    end
end


function drawdecays(de,of,x,y)
    de = de{1};
    of = of{1};
    plot(x(de),y(de),'dm') 
    plot(x(of),y(of),'dm')
    for i = 1:length(de)
        line([x(de(i)),x(of(i))],[y(de(i)),y(of(i))],'Color','m')
    end
end