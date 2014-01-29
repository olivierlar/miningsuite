function playclass(obj,options)
    if iscell(obj.design)
        filenames = obj.design;
    else
        filenames = obj.design.files;
    end
    sig.compute(@main,obj.Ydata,filenames,obj.Srate,sig.Signal.sonify);
end
    
   
function out = main(d,name,rate,sonify)
    sig.playfile(sonify,d.content,name,rate)
    
    out = {};
end