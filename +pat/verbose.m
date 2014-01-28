function v = verbose(b)

persistent verbose

if nargin
    if not(isnumeric(b))
        error('ERROR IN PAT.VERBOSE: The argument should be a number.')
    end
    verbose = b;
else
    if isempty(verbose)
        verbose = 0;
    end
end

v = verbose;