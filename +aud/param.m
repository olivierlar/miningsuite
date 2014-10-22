function p = param(as,ons,off,channel)

p = as.type2val;
        
p = p.setfield('onset',seq.paramval(as.getfield('onset'),ons));

p = p.setfield('offset',seq.paramval(as.getfield('offset'),off));