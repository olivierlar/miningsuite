classdef scale < abst.concept
	properties %(SetAccess = private)
        subscale
        newpitch
        degree
    end
    
	methods
		function obj = scale(subscale,newpitch,reso)
            if nargin<1
                subscale = [];
            end
            if nargin<2
                newpitch = [];
            end
            obj = obj@abst.concept;
            obj.subscale = subscale;
            obj.newpitch = newpitch;
            if ~isempty(newpitch)
                if isempty(subscale.degree)
                    obj.degree = 0;
                else
                    [f s] = subscale.list;
                    mt = find(mod(s,1));
                    f(:,mt) = [];
                    s(mt) = [];
                    ref = mean(f(1,:)-s*100);
                    obj.degree = round((newpitch - ref)/reso)*reso/100;
                end
            end
        end
        
        
        function [f s] = list(obj,order)
            if nargin<2
                order = 1;
            end
            if isempty(obj.newpitch)
                f = [];
                s = [];
            	return
            end
            [f s] = obj.subscale.list(0);
            f = [f obj.newpitch];
            s = [s obj.degree];
            if order
                [unused indx] = sort(f);
                f = f(:,indx);
                s = s(:,indx);
            end
        end
        
        
        %function d = find(obj,pitch)
        %    if isequal(pitch,obj.newpitch)
        %        d = obj.degree;
        %    else
        %        d = find(obj.subscale,pitch);
        %    end
        %end
            
        
        function [obj degr] = integrate(obj,freq,stb,reso)
            if isempty(freq)
                degr = [];
                return
            end
            
            [f d] = obj.list;
            if ~isempty(f)
                [df best] = min(abs(f-freq));

                if df < reso
                    best = best(1);
                    degr = d(best);
                    return
                end

                if ~stb
                    [mindist minidx] = min(min(abs(freq - f)));
                    if mindist < reso
                        degr = d(minidx);
                        return
                    end
                end
            end

            obj = mus.scale(obj,freq,reso);
            degr = obj.degree;
        end
        
        %function obj = activate(obj,note)
        %    obj.discriminate(note.pitch - obj.scale, note.dur);
        %end
    end
end