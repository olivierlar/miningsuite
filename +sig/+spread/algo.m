function [s,c] = algo(d,f)
    c = sig.centroid.algo(d,f);
    s = sqrt( sum((f'-c).^2 .* (d/sum(d)) ) );
end