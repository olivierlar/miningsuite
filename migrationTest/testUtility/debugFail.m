function out = debugFail(a, b)


    sizeTest = migrationTestUtility_dimensionTest(a,b);

    if  sizeTest == 1
       disp('dimension OK');
        x = a(:);
        y = b(:);
        %res = [x, y,abs(x - y) ];
        maxDiff = (max(abs(x - y)));
        %cprintf('*Yellow',['absolute maximum data difference: ', num2str(maxDiff), '\n']);

        maxDiffOverMiningSuitePercent = (maxDiff/y)*100;
        maxDiffPercentMiningSuite = max(maxDiffOverMiningSuitePercent);

        maxDiffOverMirtoolbox = (maxDiff/x)*100;
        maxDiffPercentMirtoolbox = max(maxDiffOverMirtoolbox);
        
        
        cprintf('*Yellow',['absolute maximum data difference percent (wrt MiningSuite): ', num2str(maxDiffPercentMiningSuite), '%%\n']);
        cprintf('*Yellow',['absolute maximum data difference percent (wrt Mirtoolbox): ', num2str(maxDiffPercentMirtoolbox), '%%\n']);
        if(maxDiffPercentMiningSuite < 1  && maxDiffPercentMirtoolbox < 1)
           cprintf('*green', 'test SUCCESS with insignificant differences!\n');  
        else
            cprintf('*red', 'test FAIL! with significant differences\n');
        end

    else
       cprintf('*red', 'test FAIL! with differences in data structure\n')
       disp('dimension fail');   
       cprintf("\tdimension in mirtoolbox \t:") ;
       disp(size((a)));
       cprintf("\tdimension in miningsuite \t:") ;
       disp(size(b));
    end





   
end