function [R,ODE_U] = ODE_UG(u_U,x)

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h xmin xmax l_F a_l x_l sigma_x mu_x
 
N = size(x,1);

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

% U and its elasticities
[U,Ux,Uxx] = FF(u_U,x); e_U  = Ux.*x./U; e_U2 = Uxx.*(x.^2)./U;

% Aggregate labor
l = l_F*exp(a_l.*(x-x_l));

% ODE 
ODE_U = ( alpha.*log(l) - chi./(1+psi).*l.^(1+psi) )./U + e_U.*mu_x + .5*e_U2.*sigma_x.^2 - rho;
   
% Project residuals onto Chebyshev polynomials:

w0 = (x-b)/m; %grid for collocation

T0 = chebypol(w0,N-1);
T0 = kron(eye(1),T0);
R  = (ODE_U')*T0;

end





























