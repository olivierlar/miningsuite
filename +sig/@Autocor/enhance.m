function obj = enhance(obj,e)
    p = sig.peak(obj,'NoBegin','NoEnd','Contrast',.01,...
                  'Normalize','Local');
    v = sig.peak(obj,'Valleys','Contrast',.01,'Normalize','Local');
    res = sig.compute(@main,obj.Ydata,p.peakpos,v.peakpos,e,obj.xdata);
    obj.Ydata = res{1};
end


function out = main(d,p,v,e,t)
    %if size(d,'frame') > 1
    d = d.apply(@routine,{p,v,e,t},{'element'},1);
    %end
    out = {d};
end


function y = routine(x,p,v,e,t)
    t = t(:);
    mv = [];
    if not(isempty(p))
        mp = min(p); %Lowest peak
        mv = v(find(v<mp,1,'last'));
            %Highest valley below the lowest peak

        if not(isempty(mv))
            x = x-mv;
        end
    end
    y = x;
    coef = x(2)-x(1); % initial slope of the autocor curve
    tcoef = t(2)-t(1);
    deter = 0;
    inter = 0;

    repet = find(not(diff(t)));  % Avoid bug if repeated x-values
    if repet
        warning('WARNING in MIRAUTOCOR: Two successive samples have exactly same temporal position.');
        t(repet+1) = t(repet)+1e-12;
    end

    if coef < 0
        % initial descending slope removed
        deter = find(diff(y)>0,1)-1;
            % number of removed points
        if isempty(deter)
            deter = 0;
        end
        y(1:deter) = [];
        t(1:deter) = [];
        coef = y(2)-y(1);
    end

    if coef > 0
        % initial ascending slope prolonged to the left
        % until it reaches the x-axis
        while y(1) > 0
            coef = coef*1.1;
                % the further to the left, ...
                % the more ascending is the slope
                % (not sure it always works, though...)
            inter = inter+1;
                % number of added points
            y = [y(1)-coef; y];
            t = [t(1)-tcoef; t];
        end
        y(1) = 0;
    end
    
    debug = 0;
    for i = e  % Enhancing procedure
        % option.e is the list of scaling factors
        % i is the scaling factor
        if i
            be = find(t & t/i >= t(1),1);
                % starting point of the substraction
                % on the X-axis

            if not(isempty(be))
                ic = interp1(t,y,t/i);
                    % The scaled autocorrelation
                ic(1:be-1) = 0;
                ic(find(isnan(ic))) = Inf;
                    % All the NaN values are changed
                    % into 0 in the resulting curve
                ic = max(ic,0);

                if debug
                   hold off,plot(t,y)
                end

                y = y - ic;       
                    % The scaled autocorrelation
                    % is substracted to the initial one

                y = max(y,0);
                    % Half-wave rectification

                if debug
                   hold on,plot(t,ic,'r')
                   hold on,plot(t,y,'g')
                   drawnow
                   figure
                end
            end
        end
    end

    % The  temporary modifications are
    % removed from the final curve
    if inter>=deter
        y = y(inter-deter+1:end);
        if not(isempty(mv))
            y = y + mv;
        end
    elseif size(y,1) > 1
        y = [zeros(deter-inter,1);y];
    elseif size(y,2) > 1
        y = [zeros(1,deter-inter),y];
    end
end