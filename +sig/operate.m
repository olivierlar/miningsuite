% SIG.OPERATE
% performs the techniques underlying the MiningSuite, such as efficient
% memory management, in a transparent way.
% Internally called by all operators available to users in SigMinr,
% AudMinr, VocMinr and audio-based approaches in MusMinr.
%
% Copyright (C) 2014, 2017-2018 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.
%
% For any reuse of the code below, please mention the following
% publication:
% Olivier Lartillot, "The MiningSuite: ?MIRtoolbox 2.0? + ?MIDItoolbox 2.0?
% + pattern mining + ...", AES 53RD INTERNATIONAL CONFERENCE, London, UK,
% 2014

function out = operate(pack,name,options,init,main,after,argin,combine,extensive)
arg = argin{1};
if iscell(arg)
    arg = arg{1};
end
if nargin<8
    combine = 'no';    
end
if nargin<9
    extensive = 0;
else
    extensive = strcmpi(extensive,'extensive');
end

[options,extract] = sig.options(options,argin,[pack,'.',name]);

if ischar(arg)
    filename = arg;
    optionmix = struct('mix',options.mix);
    arg = sig.design('sig','signal',arg,'sig.Signal',[],[],optionmix);
elseif isa(arg,'sig.design')
    filename = arg.files;
end

[arg,type] = init(arg,options);
if ~iscell(arg)
    arg = {arg};
end

if isa(arg{1},'sig.design')
    if isempty(extract) && ~ischar(arg{1})
        extract = arg{1}.extract;
    end
    if arg{1}.extensive || arg{1}.nochunk
        nochunk = 1;
    %elseif ischar(arg)
    %    nochunk = 0;
    else
        nochunk = arg{1}.nochunk;
    end
    if length(arg) == 1
        argin1 = arg{1};
    else
        argin1 = arg;
    end
    design = sig.design(pack,name,argin1,type,main,after,options,...
                        combine,argin(2:end),extract,extensive,nochunk);
    
    %if ischar(arg)
    %    filename = arg;
    %else
    %    filename = arg.files;
    %end
    
    design.overlap = arg{1}.overlap;
    
    if strcmpi(filename,'Design') || ~strcmp(name,'play')
        design.evaluate = 1;
        out = {design};
    else
        out = design.eval(filename);
    end
elseif isa(arg{1},'sig.Signal')
    if iscell(main)
        main = main{1};
    end
    out = main(arg(1),options);
    out = after(out,options);
    if ~iscell(out)
        out = {out};
    end
    out{1}.design = sig.design(pack,name,arg{1},type,main,after,options,...
                               combine,argin(2:end),[],0,0);
    out{1}.design.evaluated = 1;
elseif isa(arg{1},'mus.Sequence')
    out = main(arg{1},options);
    out = after(out,options);
elseif isa(arg{1},'aud.Sequence')
    out = main(arg{1},options,frame);
    out = after(out,options);
else
    out = {arg};
end