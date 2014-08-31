function obj = enhance(obj)
    res = sig.compute(@main,obj.Ydata);
    obj.Ydata = res{1};
end


function out = main(d)
    d = d.apply(@routine,{},{'frame'},Inf);
    out = {d};
end


function y = routine(x)
    if size(x,'frame')<=1
        y = x;
        return
    end
    pvk = pv{k}{l}{1,g,h};
    mv = [];
    if not(isempty(pvk))
        mp = min(pv{k}{l}{1,g,h}); %Lowest peak
        vvv = vv{k}{l}{1,g,h}; %Valleys
        mv = vvv(find(vvv<mp,1,'last'));
            %Highest valley below the lowest peak

        if not(isempty(mv))
            cgh = cgh-mv;
        end
    end
    cgh2 = cgh;
    tgh2 = t(:,g,1);
    coef = cgh(2)-cgh(1); % initial slope of the autocor curve
    tcoef = tgh2(2)-tgh2(1);
    deter = 0;
    inter = 0;

    repet = find(not(diff(tgh2)));  % Avoid bug if repeated x-values
    if repet
        warning('WARNING in MIRAUTOCOR: Two successive samples have exactly same temporal position.');
        tgh2(repet+1) = tgh2(repet)+1e-12;
    end

    if coef < 0
        % initial descending slope removed
        deter = find(diff(cgh2)>0,1)-1;
            % number of removed points
        if isempty(deter)
            deter = 0;
        end
        cgh2(1:deter) = [];
        tgh2(1:deter) = [];
        coef = cgh2(2)-cgh2(1);
    end

    if coef > 0
        % initial ascending slope prolonged to the left
        % until it reaches the x-axis
        while cgh2(1) > 0
            coef = coef*1.1;
                % the further to the left, ...
                % the more ascending is the slope
                % (not sure it always works, though...)
            inter = inter+1;
                % number of added points
            cgh2 = [cgh2(1)-coef; cgh2];
            tgh2 = [tgh2(1)-tcoef; tgh2];
        end
        cgh2(1) = 0;
    end

    for i = option.e  % Enhancing procedure
        % option.e is the list of scaling factors
        % i is the scaling factor
        if i
            be = find(tgh2 & tgh2/i >= tgh2(1),1);
                % starting point of the substraction
                % on the X-axis

            if not(isempty(be))
                ic = interp1(tgh2,cgh2,tgh2/i);
                    % The scaled autocorrelation
                ic(1:be-1) = 0;
                ic(find(isnan(ic))) = Inf;
                    % All the NaN values are changed
                    % into 0 in the resulting curve
                ic = max(ic,0);

                if debug
                   hold off,plot(tgh2,cgh2)
                end

                cgh2 = cgh2 - ic;       
                    % The scaled autocorrelation
                    % is substracted to the initial one

                cgh2 = max(cgh2,0);
                    % Half-wave rectification

                if debug
                   hold on,plot(tgh2,ic,'r')
                   hold on,plot(tgh2,cgh2,'g')
                   drawnow
                   figure
                end
            end
        end
    end

    % The  temporary modifications are
    % removed from the final curve
    if inter>=deter
        c(:,g,h) = cgh2(inter-deter+1:end);
        if not(isempty(mv))
            c(:,g,h) = c(:,g,h) + mv;
        end
    else
        c(:,g,h) = [zeros(deter-inter,1);cgh2];
    end
end