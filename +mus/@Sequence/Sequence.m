classdef Sequence < aud.Sequence
%%
    properties
        scale
        concept
    end
%%
    methods
        function obj = Sequence(varargin)
            obj = obj@aud.Sequence(varargin{:});
        end
%         function res = get(obj,param)
%             c = obj.content;
%             if iscell(obj.files)
%             else
%                 l = length(c);
%                 v = zeros(l,1);
%                 for i = 1:l
%                     p = c{i}.parameter.getfield(param);
%                     v(i) = p.value;
%                 end
%                 d = sig.data(v,{'sample'});
%                 res = sig.Signal(d,param,'','','',0,0,1,0,l,0);
%                 res.design = sig.design('musi','get','','',[],[],[],0,[],[],[],0,0);
%                 res.design.evaluated = 1;
%             end
%         end
         function display(obj,h)
            if nargin < 2
                h = [];
            end
            disp(obj.name)
            if iscell(obj.files)
                for i = 1:length(obj.content)
                    mus.display(obj,h,i);
                end
            else
                mus.display(obj,h);
            end
        end
        function save(obj,name)
            fid = fopen(name,'wt');
            for i = 1:length(obj.content)
                ci = obj.content{i};
                if ~isempty(ci.to)
                    ci = ci.to(1);
                end
                ti = ci.parameter.tabulize;
                for j = 1:length(ti)
                    fprintf(fid,'%f\t',ti(j));
                end
                fprintf(fid,'\n');
            end
            fclose(fid);
            disp(['Data exported to file ',name,'.']);
        end
        function play(obj,N1,N2,pat)
            % Some code from midi2audio
            Fs = 44100;
            endtime = ceil(obj.content{end}.parameter.getfield('offset').value);
            y = zeros(1,ceil(endtime*Fs));
            if nargin > 1
                range = N1:N2;
            else
                range = 1:length(obj.content);
            end
            for i = range
                ci = obj.content{i};
                to = ci;
                if ~isempty(to.to)
                    to = to.to(1);
                end
                f = midi2freq(to.parameter.getfield('chro').value);
                dur = to.parameter.getfield('offset').value - ...
                    to.parameter.getfield('onset').value;
                amp = 64;
                if 1 %nargin > 3 && ismember(pat,ci.property)
                    type = 'saw';
                else
                    type = 'sine';
                end
                yt = synth(f, dur, amp, Fs, type);
                %soundsc(yt,Fs);
                n1 = floor(to.parameter.getfield('onset').value*Fs)+1;
                if i == range(1)
                    n1_1 = n1;
                end
                n1 = n1-n1_1+1;
                N = length(yt); 
                y(n1:n1+N-1) = y(n1:n1+N-1) + reshape(yt,1,[]);
                %pause
            end
            soundsc(y,Fs);%/2);
        end
    end
end