% SIG.SEGMENT
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function varargout = segment(varargin)
    varargout = sig.operate('sig','segment',initoptions,...
                     @init,@main,@after,varargin); %,'concat_sample');
%     if isa(s{1},'sig.design')
%         s = s{1}.eval;
%         s = s{1};
%     end
end
                    
                    
%%
function options = initoptions
    options = sig.signal.signaloptions();
    
        pos.type = 'Numeric';
    options.pos = pos;
end


%%
function [x type] = init(x,option,frame)
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    pos = option.pos;
    if isa(pos,'sig.design')
        pos = pos.eval;
        if iscell(pos)
            pos = pos{1};
        end
    end
    if isa(pos,'sig.signal')
        pos = sort(pos.peakpos.content{1});
    end
    
%     if 0 %strcmp(type,'sp')
%         pos(pos > x.Ssize) = [];
%         if pos(1) > 1
%             pos = [1 pos];
%         end
%         %if pos(end) < x.Ydata.size('sample')
%             pos(end+1) = x.Ydata.size('sample')+1;
%         %end
%         s = cell(1,length(pos)-1);
%         Sstart = zeros(1,length(pos)-1);
%         for i = 1:length(pos)-1
%             s{i} = x.Ydata.content(pos(i):pos(i+1)-1);
%             Sstart(i) = unit.generate(pos(i));
%         end
%    elseif strcmp(type,'s')
        s = {};
        Sstart = x.Sstart;
        si1 = 0;
        pos(end+1) = Inf;
        for i = 1:length(pos)
            si2 = find(x.sdata > pos(i),1);
            if isempty(si2)
                if si1
                    if si1 < x.Ssize
                        s{end+1} = x.Ydata.view('sample',[si1,x.Ydata.size('sample')]);
                    end
                else
                    s{end+1} = x.Ydata.content;
                end
                break
            end
            if si1
                s{end+1} = x.Ydata.view('sample',[si1,si2-1]);
            elseif si2 > 1
                s{end+1} = x.Ydata.view('sample',[1,si2-1]);
            end
            si1 = si2;
            if i < length(pos)
                Sstart(end+1) = pos(i);
            end
        end
%    end
    x.Ydata.content = s;
    x.Ydata.layers = 2;
    x.Sstart = Sstart;
    out = {x};
end


function x = after(x,option)
end