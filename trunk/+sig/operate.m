% SIG.OPERATE
% performs the techniques underlying the MiningSuite, such as efficient
% memory management, in a transparent way.
% Internally called by all operators available to users in SigMinr,
% AudMinr, VocMinr and audio-based approaches in MusMinr.
%
% Copyright (C) 2014, Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = operate(pack,name,options,init,main,argin,combine,extensive)
arg = argin{1};
if nargin<7
    combine = [];
end
if nargin<8
    extensive = 0;
else
    extensive = strcmpi(extensive,'extensive');
end

[during,after,frame,extract] = sig.options(options,argin,name);
if ~isempty(frame) && ~frame.toggle && ...
        ~ischar(arg) && isa(arg,'sig.design')
    frame = arg.frame;
end

[arg type] = init(arg,during);

if ischar(arg) || isa(arg,'sig.design')
    if isempty(extract) && ~ischar(arg)
        extract = arg.extract;
    end
    if extensive
        nochunk = 1;
    elseif ischar(arg)
        nochunk = 0;
    else
        nochunk = arg.nochunk;
    end
    design = sig.design(pack,name,arg,type,main,during,after,frame,...
                        combine,argin(2:end),extract,extensive,nochunk);
    
    if ischar(arg)
        filename = arg;
    else
        filename = arg.files;
    end
    
    if strcmpi(filename,'Design') || ~strcmp(name,'play')
        design.evaluate = 1;
        out = {design};
    else
        out = design.eval(filename);
    end
elseif isa(arg,'sig.Signal')
    if ~isempty(frame) && frame.toggle
        frate = sig.compute(@sig.getfrate,arg.Srate,frame);
        arg.Ydata = arg.Ydata.frame(frame,arg.Srate);
        arg.Frate = frate;
        %y = {sig.signal(data,'Xsampling',1/sr,'Name','audio',...
        %                'Sstart',(window(1)-1)/sr,'Srate',sr,...
        %                'Ssize',data.size('sample'),...
        %                'Frate',frate)};
    end
        
    if arg.design.evaluated
        out = main({arg},during,after);
    else
        out = {arg.design.main({arg},during,after)};
    end
    
    out{1}.design = sig.design(pack,name,arg,type,main,during,after,...
                               frame,combine,argin(2:end),[],0,0);
    out{1}.design.evaluated = 1;
elseif isa(arg,'mus.Sequence')
    out = main(arg,during,after);
else
    out = {arg};
end