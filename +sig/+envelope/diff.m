function d = diff(e,postoption)

    d = e.Ydata;
    if (postoption.diffhwr || postoption.diff) && ~e.diff
        order = max(postoption.diffhwr,postoption.diff);
        if postoption.complex
            dph = diff(ph{k}{i},2);
            dph = dph/(2*pi);% - round(dph/(2*pi));
            ddki = sqrt(d{k}{i}(3:end,:,:).^2 + d{k}{i}(2:end-1,:,:).^2 ...
                                      - 2.*d{k}{i}(3:end,:,:)...
                                         .*d{k}{i}(2:end-1,:,:)...
                                         .*cos(dph));
            d{k}{i} = d{k}{i}(2:end,:,:); 
            tp{k}{i} = tp{k}{i}(2:end,:,:);
        elseif order == 1
            d = d.apply(@zdiff,{},{'sample'});
        else
            b = firls(order,[0 0.9],[0 0.9*pi],'differentiator');
            ddki = filter(b,1,...
                [repmat(d{k}{i}(1,:,:),[order,1,1]);...
                 d{k}{i};...
                 repmat(d{k}{i}(end,:,:),[order,1,1])]);
            ddki = ddki(order+1:end-order-1,:,:);
        end
        if postoption.diffhwr
            d = d.apply(@hwr,{},{'sample'});
        end
    end
end


function y = hwr(x)
    % Half-Wave Rectifier
    y = 0.5 * (x + abs(x));
end


function y = zdiff(x)
    y = [zeros(1,size(x,2),size(x,3)); diff(x)];
end
    