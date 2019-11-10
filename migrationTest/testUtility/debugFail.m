function out = debugFail(a, b)


    sizeTest = migrationTestUtility_dimensionTest(a,b);
   
   if  sizeTest == 1
       disp('dimension OK');
        x = a(:);
        y = b(:);
        %res = [x, y,abs(x - y) ];
        maxDiff = (max(abs(x - y)));
        cprintf('*Yellow',['absolute maximum data difference: ', num2str(maxDiff), '\n']);
   else
       disp('dimension fail');   
       cprintf("\tdimension in mirtoolbox \t:") ;
       disp(size((a)));
       cprintf("\tdimension in miningsuite \t:") ;
       disp(size(b));
   end
end