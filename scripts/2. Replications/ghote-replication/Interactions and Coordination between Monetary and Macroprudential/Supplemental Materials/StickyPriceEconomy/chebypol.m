function [Y,Y1,Y2] = chebypol(x,N)
% Evaluates Chebyshev polynomials of type 1 up to degree N at the points x.
% N is the highest polynomial degree. The code computes N+1 polynomials
% x is an Kx1 vector of datapoints.
% Y is an Kx(N+1) matrix. Each row is for a datapoint in x and each column
% is the Chebyshev polynomial of the respective degree evaluated at that
% datapoint.
% Y1 is the first derivative of Y w.r.t x.
% Y2 is the second derivative of Y w.r.t x.

K = size(x,1);

t0m2 = ones(K,1);
t0m1 = x;
t1m1 = ones(K,1);
t1m2 = zeros(K,1);
t2m1 = zeros(K,1);
t2m2 = zeros(K,1);

Y  = [t0m2 t0m1 zeros(K,N-1)];
if nargout>1
    Y1 = [t1m2 t1m1 zeros(K,N-2)];
    Y2 = [t2m2 t2m1 zeros(K,N-2)];
end

for i=2:N
    t0 = 2*x.*t0m1-t0m2;

    Y(:,i+1) = t0;
    if nargout>1
        t1 = 2*t0m1+2*x.*t1m1-t1m2;
        t2 = 4*t1m1+2*x.*t2m1-t2m2;
        t1m2 = t1m1;
        t1m1 = t1;
        t2m2 = t2m1;
        t2m1 = t2;

        Y1(:,i+1) = t1;
        Y2(:,i+1) = t2;
    end
    t0m2 = t0m1;
    t0m1 = t0;
end