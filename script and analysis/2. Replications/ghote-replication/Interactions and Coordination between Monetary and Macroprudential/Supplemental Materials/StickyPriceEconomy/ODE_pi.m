function [R,ODE_re,ODE_mg] = ODE_pi(u_re,u_mg,x)

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital xmin xmax wedge mu_x sigma_x
 
N = size(x,1);

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

% re, mg and their elasticities
[re,rex,rexx] = FF(u_re,x); e_re  = rex.*x./re; e_re2 = rexx.*(x.^2)./re;
[mg,mgx,mgxx] = FF(u_mg,x); e_mg  = mgx.*x./mg; e_mg2 = mgxx.*(x.^2)./mg;

% Inflation 
pi = theta/(epsilon-1)*(1-(mg./re).^-(epsilon-1));

% ODEs 
ODE_re = 1./re        + (epsilon-1)*pi - (rho+theta) + e_re.*mu_x +.5*e_re2.*sigma_x.^2;
ODE_mg = 1./mg.*wedge + epsilon*pi     - (rho+theta) + e_mg.*mu_x +.5*e_mg2.*sigma_x.^2;
   
% Project residuals onto Chebyshev polynomials:

w0 = (x-b)/m; %grid for collocation

T0 = chebypol(w0,N-1);
T0 = kron(eye(2),T0);
R  = [ODE_re;ODE_mg]'*T0;


end