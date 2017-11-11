% mus.Chromagram class
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

classdef Chromagram < sig.Signal
    properties (Constant)
    end
    properties   
        plabel = 1;
        wrap = 0;
        chromaclass = {};
        chromafreq = {};
        register = {};
    end
    methods
        function c = Chromagram(varargin)
            i = 1;
            plabel = 1;
            wrap = 0;
            chromaclass = {};
            chromafreq = {};
            register = {};
            while i < length(varargin)
                if strcmpi(varargin{i},'PLabel')
                    varargin(i) = [];
                    plabel = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Wrap')
                    varargin(i) = [];
                    wrap = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'ChromaClass')
                    varargin(i) = [];
                    chromaclass = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'ChromaFreq')
                    varargin(i) = [];
                    chromafreq = varargin{i};
                    varargin(i) = [];
                elseif strcmpi(varargin{i},'Register')
                    varargin(i) = [];
                    register = varargin{i};
                    varargin(i) = [];
                else
                    i = i+1;
                end
            end
            c = c@sig.Signal(varargin{:});
            if strcmp(c.yname,'Signal')
                c.yname = 'Chromagram';
            end
            c.xname = 'Chroma';    
            c.xsampling = 1;
            
            c.plabel = plabel;
            c.wrap = wrap;
            c.chromaclass = chromaclass;
            c.chromafreq = chromafreq;
            c.register = register;
        end
    end
end