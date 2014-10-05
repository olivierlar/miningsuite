function obj = median(obj,field,order,offset)
    obj = obj.apply(@routine,{order,offset},{field},1);
end


function y = routine(x,order,offset)
    y = x;
    sz = length(x);
    for i = 1:sz
        y(i) = x(i) - offset * median(x(max(1,i-order):min(sz,i+order)));
    end
end