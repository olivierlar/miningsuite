function col = num2col(k);

switch k
    case 1 
        col = [0 0 1];
    case 2 
        col = [1 0 0];
    case 3 
        col = [0 1 0];
    case 4
        col = [0 0 0];
    case 5 
        col = [1 0 1];
    case 6 
        col = [1 1 0];
    case 7 
        col = [0 1 1];
    case 8
        col = [1 0 .5];
    case 9
        col = [.5 1 0];
    case 10
        col = [0 .5 1];
    case 11
        col = [1 .5 0];
    case 12
        col = [.5 0 1];
    case 13
        col = [0 1 .5];
    otherwise
        col = [rand rand rand];
end    