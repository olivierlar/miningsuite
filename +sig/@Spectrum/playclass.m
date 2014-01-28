function playclass(obj,options)
    if iscell(obj.design)
        filenames = obj.design;
    else
        filenames = obj.design.files;
    end
    sig.compute(@main,obj.Data,filenames,obj.SamplingRate,...
                sig.Temporal.synth);
end
    
   
function out = main(d,name,rate,synth)
    sig.playfile(synth,d,name,rate)
    
    out = {};
end