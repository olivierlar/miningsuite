% MUS.SCALE
%
% Copyright (C) 2014 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef scale < abst.concept
	properties %(SetAccess = private)
        subscales
        superscales
        pitches
        tonic
        modes = zeros(0,2)
        active = 1
        lastcall = 0
        lastcall2
    end
    properties (Dependent)
        length
    end
    methods
		function obj = scale(pitches)
            obj = obj@abst.concept;
            obj.pitches = pitches;
        end
        function connect(sub,super)
            subs = [sub]; % sub.subscales];
            if ismember(subs,super.subscales)
                return
            end
            if isempty(super.subscales)
                super.subscales = subs;
            else
                super.subscales(end+1:end+length(subs)) = subs;
            end
            for i = 1:length(subs)
                if ismember(super,subs(i).superscales)
                    continue
                end
                if isempty(subs(i).superscales)
                    subs(i).superscales = super;
                else
                    subs(i).superscales(end+1) = super;
                end
            end
        end
        function d = degrees(obj,n)
            if nargin < 2
                n = 1;
            end
            d = obj.pitches - obj.tonic{n};
        end
        function [modes,dominant,newdominant] = assign(obj,modes,address,...
                                        predominant,dominant,newdominant)
            if isempty(obj.modes)
                deg = obj.degrees;
                for i = 1:length(modes)
                    for j = 1:length(modes(i).pivot)
                        modscal = modes(i).scale - ...
                                  modes(i).scale(modes(i).pivot(j));
                        found = 0;
                        for k = 1:length(deg)
                            if ~ismember(deg(k),modscal)
                                found = 1;
                                break;
                            end
                        end
                        if found
                            continue
                        end
                        obj.modes(end+1,:) = [i,j];
                    end
                end
            end
            for h = 1:size(obj.modes,1)
                i = obj.modes(h,1);
                j = obj.modes(h,2);
                f = find(obj.tonic{1} == modes(i).origins,1);
                score = obj.length;
                if isempty(f)
                    modes(i).origins(end+1) = obj.tonic{1};
                    modes(i).timescore(address,j,end+1) = score;
                    inc = 1;
                else
                    if size(modes(i).timescore,2) < j || ...
                            size(modes(i).timescore,1) < address
                        old = 0;
                    else
                        old = modes(i).timescore(end,j,f);
                    end
                    inc = score > old;
                    if inc
                        modes(i).timescore(address,j,f) = score;
                    end
                end
                if inc
                    origsub = obj.tonic{1} - ...
                              modes(i).scale(modes(i).pivot(j));
                    for k = 1:length(modes(i).supermode)
                        sk = modes(i).supermode(k);
                        origsup = origsub - ...
                            sk.mode.scale(sk.degree);
                        f = find(origsup == sk.mode.origins,1);
                        score = score / length(modes(i).scale);
                        if isempty(f)
                            if i ~= 4 %% Only main jins can infer mode detection
                                continue
                            end
                            sk.mode.origins(end+1) = origsup;
                            if isempty(sk.mode.timescore)
                                f = 1;
                            else
                                f = size(sk.mode.timescore,3) + 1;
                            end
                        end
                        sk.mode.timescore(address,sk.index,f) = score;
                        
                        if 0
                        if size(sk.mode.timescore2,1) < address || ...
                                size(sk.mode.timescore2,2) < sk.index || ...
                                size(sk.mode.timescore2,3) < f
                            if address > 1 && ...
                                    size(sk.mode.timescore2,1) >= address - 1 && ...
                                    size(sk.mode.timescore2,2) >= sk.index && ...
                                    size(sk.mode.timescore2,2) >= f
                                old = sk.mode.timescore2(address,sk.index,f);
                            else
                                old = 0;
                            end
                            sk.mode.timescore2(address,sk.index,f) = ...
                                old + obj.timescore(address);
                        else
                            sk.mode.timescore2(address,sk.index,f) = ...
                                sk.mode.timescore2(address,sk.index,f) + ...
                                obj.timescore(address);
                        end
                        end
                        
                        found = 0;
                        for l = 1:length(dominant)
                            if dominant{l}{1} == sk.mode && ...
                                    dominant{l}{2} == origsup
                                found = 1;
                                break
                            end
                        end
                        if ~found
                            for l = 1:length(newdominant)
                                if newdominant{l}{1} == sk.mode && ...
                                        newdominant{l}{2} == origsup
                                    found = 1;
                                    break
                                end
                            end
                        end
                        if ~found
                            for l = 1:length(predominant)
                                if predominant{l}{1} == sk.mode && ...
                                        predominant{l}{2} == origsup
                                    found = l;
                                    break
                                end
                            end
                            if found
                                dominant{end+1} = {sk.mode,origsup};
                            elseif sk.degree == 2 %% Only main jins can infer mode detection
                                newdominant{end+1} = {sk.mode,...
                                                      origsup};
                            end
                        end
                    end
                end
            end
        end
        %function traverse(obj,func,varargin)
        %    for i = 1:length(obj.superscales)
        %        func(obj.superscales(i),varargin{:});
        %        %obj.superscales(i).traverse(func,varargin{:});
        %    end
        %end
        function l = get.length(obj)
            l = length(obj.pitches);
        end
        function display(obj,lvl,id)
            if nargin < 2
                lvl = 0;
                id = rand;
            end
            fprintf([blanks(lvl),num2str(obj.pitches)]);
            if isequal(obj.lastcall,id)
                fprintf(' ...\n');
                return
            end
            fprintf('\n');
            obj.lastcall = id;
            for i = 1:length(obj.superscales)
                obj.superscales(i).display(lvl+1,id);
            end
        end
    end
end