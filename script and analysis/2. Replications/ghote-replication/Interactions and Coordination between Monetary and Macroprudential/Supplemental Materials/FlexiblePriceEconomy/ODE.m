function [R,ODE_q,ODE_v,x_L] = ODE(u_q,u_v,x)

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h xmin xmax
 
N = size(x,1);

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

% q, v and their elasticities
[q,qx,qxx] = FF(u_q,x); e_q  = qx.*x./q; e_q2 = qxx.*(x.^2)./q;
[v,vx,vxx] = FF(u_v,x); e_v  = vx.*x./v; e_v2 = vxx.*(x.^2)./v;

% Leverage ratio
phi = min(lambda.*v,1./x);

% Threshold state
x_L = find( lambda.*v.*x >= 1,1,'first');

if x_L < size(x,1) && x(x_L)*lambda*v(x_L) == 1
    x_L = x_L + 1;
end    

% Aggregate supply of capital services as a share of potential
a = a_h + (1-a_h).*phi.*x;

% Elasticity of a
e_a = (1-a_h)*(1+e_v).*lambda.*v.*x./a;
e_a(x_L:end) = 0*e_a(x_L:end); 

% Diffusion processes
sigma_x = (phi-1)./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a;
sigma_v = e_v.*sigma_x;
sigma_q = e_q.*sigma_x;
sigma_y = 1./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a - sigma_q;

% Drift process
mu_x = 1./(1-e_q.*(phi-1)).*(phi./q.*(1-alpha)./a + .5*(phi-1).*e_q2.*sigma_x.^2 - e_q.*sigma_x.^2 - (phi-1)*rho - gamma + kappa./x);

% ODEs --- Solve for q == Price of physical capital over Aggregate output

%Financially Constrained Region
ODE_qh = a_h./q.*(1-alpha)./a + e_q.*mu_x + .5.*e_q2.*sigma_x.^2 - rho;

ODE_vh = ((1-a_h)./q.*(1-alpha)./a + sigma_v.*(sigma_q+sigma_y)).*phi + gamma./v + e_v.*mu_x +.5*e_v2.*sigma_x.^2 - sigma_y.*sigma_v - gamma;

%Financially Unconstrained Region
ODE_qf = 1./q.*(1-alpha)./a + e_q.*mu_x + .5.*e_q2.*sigma_x.^2 + sigma_v.*(sigma_q+sigma_y) - rho;

ODE_vf = gamma./v + e_v.*mu_x +.5*e_v2.*sigma_x.^2 - sigma_y.*sigma_v - gamma;  

% Equilibrium ODEs

ODE_q = ODE_qh; ODE_v = ODE_vh;

if size(x_L,1) == 0
    
elseif x_L < size(x,1)
    
    ODE_q(x_L:end) = ODE_qf(x_L:end);
    ODE_v(x_L:end) = ODE_vf(x_L:end);
        
else
    
    ODE_q = ODE_qf;
    ODE_v = ODE_vf;

end    
   
% Project residuals onto Chebyshev polynomials:

w0 = (x-b)/m; %grid for collocation

T0 = chebypol(w0,N-1);
T0 = kron(eye(2),T0);
R  = [ODE_q;ODE_v]'*T0;


end