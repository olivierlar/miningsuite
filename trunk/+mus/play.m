function play(seq,scal)

notes = seq{1}.content;
synth = [];
for i = 1:length(notes)
    t = notes{i}.parameter.fields{2}.value;
    f = notes{i}.parameter.fields{1}.fields(1).value;
    p = notes{i}.parameter.fields{1}.fields(2).value;
    if isempty(p)
        %pause(diff(t));
    else
        f = f(1);
        p = p(1);
        if nargin>1
            k = find(p == [scal.deg]);
        	f = 2^(scal(k).freq(1)/1200);
        end
        d = floor((diff(t)*44100)+1/10);
        synth = [synth sin(2*pi*f*(0:d)/44100).*hann(d+1)'];
    end
end
soundsc(synth,44100);