function saveclass(obj,options)
    if iscell(obj.design)
        filenames = obj.design;
    else
        filenames = obj.design.files;
    end
    sig.compute(@main,obj.Data,filenames,obj.Srate,...
                sig.Temporal.synth,options.extension,length(filenames)==1);
end
    
   
function out = main(d,name,rate,synth,extension,unifile)
    sig.savefile(synth,d,name,rate,extension,unifile)
    
    out = {};
end