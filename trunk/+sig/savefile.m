function savefile(synth,d,name,rate,ext,unifile,varargin)

requext = 0;    % Specified new extension
if isempty(ext)
    ext = '.mir';
elseif length(ext)>3 && strcmpi(ext(end-3:end),'.wav')
    requext = '.wav';
    if length(ext)==4
        ext = '.mir';
    end
elseif length(ext)>2 && strcmpi(ext(end-2:end),'.au')
    requext = '.au';
    if length(ext)==3
        ext = '.mir';
    end
end

d = synth(d);

m = d.max.max('frame').max('channel');
s = sig.data(.9999,{'element'});
d = d.divide(m).times(s);

d = d.format({'element','channel'});

name = name{1};
%Let's remove the extension from the original files
if length(name)>3 && strcmpi(name(end-3:end),'.wav')
    name(end-3:end) = [];
elseif length(name)>2 && strcmpi(name(end-2:end),'.au')
    name(end-2:end) = [];
end

if ~unifile || strcmp(ext(1),'.')
    %Let's add the new suffix
    n = [name ext];
else
    n = f;
end
if not(ischar(requext)) || strcmp(requext,'.wav')
    if length(n)<4 || not(strcmpi(n(end-3:end),'.wav'))
        n = [n '.wav'];
    end
    wavwrite(d.content,rate,32,n)
elseif strcmp(requext,'.au')
    if length(n)<3 || not(strcmpi(n(end-2:end),'.au'))
        n = [n '.au'];
    end
    auwrite(out,rate,32,'linear',n)
end
disp([n,' saved.']);