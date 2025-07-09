function [R,ODE_q,ODE_v] = ODE_CE(u_q,u_v,x)

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h a_l xL xH coeff K xmin xmax
 
N = size(x,1);

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

% q, v and their elasticities
[q,qx,qxx] = FF(u_q,x); e_q  = qx.*x./q; e_q2 = qxx.*(x.^2)./q;
[v,vx,vxx] = FF(u_v,x); e_v  = vx.*x./v; e_v2 = vxx.*(x.^2)./v;

% Capital Requirement
[Phi, Phix, PPhi] = CapRequirement(xL,xH,coeff,K,u_v,x);

%Aggregate labor
l = exp(a_l*x); e_l = a_l*x;
wedge = l.^(1+psi);

% Elasticity of Capital Requirement
e_P = Phix.*x./Phi;

% Leverage ratio
phi = lambda*v; phi(xL:xH) = Phi(xL:xH); phi(xH+1:end) = 1./x(xH+1:end);  

% Endogenous TFP
a = a_h + (1-a_h).*phi.*x;

% Elasticity of a
e_a = (1-a_h)*(1+e_v).*lambda.*v.*x./a;
e_a(xL:xH) = (1-a_h)*(1+e_P(xL:xH)).*Phi(xL:xH).*x(xL:xH)./a(xL:xH);
e_a(xH+1:end) = 0*e_a(xH+1:end); 

% Diffusion processes
sigma_x = (phi-1)./(1-(e_q+alpha.*e_l+(1-alpha).*e_a).*(phi-1)).*sigma_a;
sigma_v = e_v.*sigma_x;
sigma_q = e_q.*sigma_x;
sigma_y = 1./(1-(e_q+alpha.*e_l+(1-alpha).*e_a).*(phi-1)).*sigma_a - sigma_q;

% Drift process
mu_x = 1./(1-e_q.*(phi-1)).*(phi.*wedge./q.*(1-alpha)./a + .5*(phi-1).*e_q2.*sigma_x.^2 - e_q.*sigma_x.^2 - (phi-1)*rho - gamma + kappa./x);

% ODEs 

%Financially Constrained Region
ODE_qh = wedge.*a_h./q.*(1-alpha)./a + e_q.*mu_x + .5.*e_q2.*sigma_x.^2 - rho;

ODE_vh = (wedge.*(1-a_h)./q.*(1-alpha)./a + sigma_v.*(sigma_q+sigma_y)).*phi + gamma./v + e_v.*mu_x +.5*e_v2.*sigma_x.^2 - sigma_y.*sigma_v - gamma;

%Financially Unconstrained Region
ODE_qf = wedge./q.*(1-alpha)./a + e_q.*mu_x + .5.*e_q2.*sigma_x.^2 + sigma_v.*(sigma_q+sigma_y) - rho;

ODE_vf = gamma./v + e_v.*mu_x +.5*e_v2.*sigma_x.^2 - sigma_y.*sigma_v - gamma;  

% Equilibrium ODEs

ODE_q = ODE_qh; ODE_v = ODE_vh;

ODE_q(xH+1:end) = ODE_qf(xH+1:end);
ODE_v(xH+1:end) = ODE_vf(xH+1:end);  
   
% Project residuals onto Chebyshev polynomials:

w0 = (x-b)/m; %grid for collocation

T0 = chebypol(w0,N-1);
T0 = kron(eye(2),T0);
R  = [ODE_q;ODE_v]'*T0;


end