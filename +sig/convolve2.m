function y = convolve2(x, m, shape, tol)
%CONVOLVE2 Two dimensional convolution.
%   Y = CONVOLVE2(X, M) performs the 2-D convolution of matrices X and
%   M. If [mx,nx] = size(X) and [mm,nm] = size(M), then size(Y) =
%   [mx+mm-1,nx+nm-1]. Values near the boundaries of the output array are
%   calculated as if X was surrounded by a border of zero values.
%
%   Y = CONVOLVE2(X, M, SHAPE) where SHAPE is a string returns a
%   subsection of the 2-D convolution with size specified by SHAPE:
%
%       'full'    - (default) returns the full 2-D convolution,
%       'same'    - returns the central part of the convolution
%                   that is the same size as A (using zero padding),
%       'valid'   - returns only those parts of the convolution
%                   that are computed without the zero-padded
%                   edges, size(Y) = [mx-mm+1,nx-nm+1] when
%                   size(X) > size(M),
%       'wrap'    - as for 'same' except that instead of using
%                   zero-padding the input A is taken to wrap round as
%                   on a toroid.
%       'reflect' - as for 'same' except that instead of using
%                   zero-padding the input A is taken to be reflected
%                   at its boundaries.
%
%   CONVOLVE2 is fastest when mx > mm and nx > nm - i.e. the first
%   argument is the input and the second is the mask.
%
%   If the rank of the mask M is low, CONVOLVE2 will decompose it into a
%   sum of outer product masks, each of which is applied efficiently as
%   convolution with a row vector and a column vector, by calling CONV2.
%   The function will often be faster than CONV2 or FILTER2 (in some
%   cases much faster) and will produce the same results as CONV2 to
%   within a small tolerance.
%
%   Y = CONVOLVE2(... , TOL) where TOL is a number in the range 0.0 to
%   1.0 computes the convolution using a reduced-rank approximation to
%   M, provided this will speed up the computation. TOL limits the
%   relative sum-squared error in the effective mask; that is, if the
%   effective mask is E, the error is controlled such that
%
%       sum(sum( (M-E) .* (M-E) ))
%       --------------------------    <=  TOL
%            sum(sum( M .* M ))
%
%   See also CONV2, FILTER2.

% David Young, Department of Informatics, University of Sussex, February 2002,
%   revised January 2005.

% Deal with optional arguments
if nargin < 3
    shape = 'full';    % shape default as for CONV2
    tol = 0;
elseif nargin < 4
    if isnumeric(shape)
        tol = shape;
        shape = 'full';
    else
        tol = 0;
    end
end;

% Set up to do the wrap & reflect operations, not handled by conv2
if strcmp(shape, 'wrap')
    x = wraparound(x, m);
    shape = 'valid';
elseif strcmp(shape, 'reflect')
    x = reflectborders(x, m);
    shape = 'valid';
end

% do the convolution itself
y = doconv(x, m, shape, tol);

%-----------------------------------------------------------------------

function y = doconv(x, m, shape, tol);
% Carry out convolution
[mx, nx] = size(x);
[mm, nm] = size(m);

% If the mask is bigger than the input, or it is 1-D already,
% just let CONV2 handle it.
if mm > mx | nm > nx | mm == 1 | nm == 1
    y = conv2(x, m, shape);
else
    % Get svd of mask
    if mm < nm; m = m'; end        % svd(..,0) wants m > n
    [u,s,v] = svd(m, 0);
    s = diag(s);
    rank = trank(m, s, tol);
    if rank*(mm+nm) < mm*nm         % take advantage of low rank
        if mm < nm;  t = u; u = v; v = t; end  % reverse earlier transpose
        vp = v';
        % For some reason, CONV2(H,C,X) is very slow, so use the normal call
        y = conv2(conv2(x, u(:,1)*s(1), shape), vp(1,:), shape);
        for r = 2:rank
            y = y + conv2(conv2(x, u(:,r)*s(r), shape), vp(r,:), shape);
        end
    else
        if mm < nm; m = m'; end     % reverse earlier transpose
        y = conv2(x, m, shape);
    end
end

%-----------------------------------------------------------------------

function r = trank(m, s, tol)
% Approximate rank function - returns rank of matrix that fits given
% matrix to within given relative rms error. Expects original matrix
% and vector of singular values.
if tol < 0 | tol > 1
    error('Tolerance must be in range 0 to 1');
end
if tol == 0             % return estimate of actual rank
    tol = length(m) * max(s) * eps;
    r = sum(s > tol);
else
    ss = s .* s;
    t = (1 - tol) * sum(ss);
    r = 0;
    sm = 0;
    while sm < t
        r = r + 1;
        sm = sm + ss(r);
    end
end

%-----------------------------------------------------------------------

function y = wraparound(x, m)
% Extend x so as to wrap around on both axes, sufficient to allow a
% "valid" convolution with m to return the cyclical convolution.
% We assume mask origin near centre of mask for compatibility with
% "same" option.
[mx, nx] = size(x);
[mm, nm] = size(m);
if mm > mx | nm > nx
    error('Mask does not fit inside array')
end

mo = floor((1+mm)/2); no = floor((1+nm)/2);  % reflected mask origin
ml = mo-1;            nl = no-1;             % mask left/above origin
mr = mm-mo;           nr = nm-no;            % mask right/below origin
me = mx-ml+1;         ne = nx-nl+1;          % reflected margin in input
mt = mx+ml;           nt = nx+nl;            % top of image in output
my = mx+mm-1;         ny = nx+nm-1;          % output size

y = zeros(my, ny);
y(mo:mt, no:nt) = x;      % central region
if ml > 0
    y(1:ml, no:nt) = x(me:mx, :);                   % top side
    if nl > 0
        y(1:ml, 1:nl) = x(me:mx, ne:nx);            % top left corner
    end
    if nr > 0
        y(1:ml, nt+1:ny) = x(me:mx, 1:nr);          % top right corner
    end
end
if mr > 0
    y(mt+1:my, no:nt) = x(1:mr, :);                 % bottom side
    if nl > 0
        y(mt+1:my, 1:nl) = x(1:mr, ne:nx);          % bottom left corner
    end
    if nr > 0
        y(mt+1:my, nt+1:ny) = x(1:mr, 1:nr);        % bottom right corner
    end
end
if nl > 0
    y(mo:mt, 1:nl) = x(:, ne:nx);                   % left side
end
if nr > 0
    y(mo:mt, nt+1:ny) = x(:, 1:nr);                 % right side
end

%-----------------------------------------------------------------------

function y = reflectborders(x, m)
% Extend x so as to reflect at each boundary, sufficient to allow a
% "valid" convolution with m to return a matrix the same size as
% the orginal.
% We assume mask origin near centre of mask for compatibility with
% "same" option.
[mx, nx] = size(x);
[mm, nm] = size(m);
if mm > mx | nm > nx
    error('Mask does not fit inside array')
end

mo = floor((1+mm)/2); no = floor((1+nm)/2);  % reflected mask origin
ml = mo-1;            nl = no-1;             % mask left/above origin
mr = mm-mo;           nr = nm-no;            % mask right/below origin
me = mx-mr+1;         ne = nx-nr+1;          % translated margin in input
mt = mx+ml;           nt = nx+nl;            % top/right of image in output
my = mx+mm-1;         ny = nx+nm-1;          % output size

y = zeros(my, ny);
y(mo:mt, no:nt) = x;      % central region
if ml > 0
    y(1:ml, no:nt) = x(ml:-1:1, :);                   % top side
    if nl > 0
        y(1:ml, 1:nl) = x(ml:-1:1, nl:-1:1);          % top left corner
    end
    if nr > 0
        y(1:ml, nt+1:ny) = x(ml:-1:1, nx:-1:ne);      % top right corner
    end
end
if mr > 0
    y(mt+1:my, no:nt) = x(mx:-1:me, :);               % bottom side
    if nl > 0
        y(mt+1:my, 1:nl) = x(mx:-1:me, nl:-1:1);      % bottom left corner
    end
    if nr > 0
        y(mt+1:my, nt+1:ny) = x(mx:-1:me, nx:-1:ne);  % bottom right corner
    end
end
if nl > 0
    y(mo:mt, 1:nl) = x(:, nl:-1:1);                   % left side
end
if nr > 0
    y(mo:mt, nt+1:ny) = x(:, nx:-1:ne);               % right side
end
