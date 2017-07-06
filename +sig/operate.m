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
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function out = operate(pack,name,options,init,main,argin,combine,extensive)
arg = argin{1};
if iscell(arg)
    arg = arg{1};
end
if nargin<7
    combine = [];    
    nochunk = 0;
else
    nochunk = strcmpi(combine,'nochunk');
end
if nargin<8
    extensive = 0;
else
    extensive = strcmpi(extensive,'extensive');
end

[during,after,frame,extract] = sig.options(options,argin,[pack,'.',name]);
if ~isempty(frame) && ~frame.toggle && ...
        ~ischar(arg) && isa(arg,'sig.design') && ~isempty(arg.frame)
    frame = arg.frame;
end

if ischar(arg)
    filename = arg;
    arg = sig.design('sig','input',arg,'sig.signal',[],during); %%%% why during???
elseif isa(arg,'sig.design')
    filename = arg.files;
end

[arg type] = init(arg,during,frame);

if isempty(frame) && ~ischar(arg) && isa(arg,'sig.design')
    frame = arg.frame;
end

if isa(arg,'sig.design')
    if isempty(extract) && ~ischar(arg)
        extract = arg(1).extract;
    end
    if (~extensive && arg(1).extensive) || nochunk
        nochunk = 1;
    %elseif ischar(arg)
    %    nochunk = 0;
    else
        nochunk = arg(1).nochunk;
    end
    design = sig.design(pack,name,arg,type,main,during,after,frame,...
                        combine,argin(2:end),extract,extensive,nochunk);
    
    %if ischar(arg)
    %    filename = arg;
    %else
    %    filename = arg.files;
    %end
    
    design.overlap = arg.overlap;
    
    if strcmpi(filename,'Design') || ~strcmp(name,'play')
        design.evaluate = 1;
        out = {design};
    else
        out = design.eval(filename);
    end
elseif isa(arg,'sig.signal')
    if ~isempty(frame) && frame.toggle
        frate = sig.compute(@sig.getfrate,arg.Srate,frame);
        arg.Ydata = arg.Ydata.frame(frame,arg.Srate);
        arg.Frate = frate;
    end
    if iscell(main)
        main = main{1};
    end
    out = main({arg},during,after);
    
    out{1}.design = sig.design(pack,name,arg,type,main,during,after,...
                               frame,combine,argin(2:end),[],0,0);
    out{1}.design.evaluated = 1;
elseif isa(arg,'mus.Sequence')
    out = main(arg,during);
elseif isa(arg,'aud.Sequence')
    out = main(arg,during,frame);
else
    out = {arg};
end