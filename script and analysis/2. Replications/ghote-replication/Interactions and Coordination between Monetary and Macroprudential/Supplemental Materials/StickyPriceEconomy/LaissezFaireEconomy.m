%% FLEXIBLE PRICE ECONOMY WITHOUT MACRO-PRUDENTIAL POLICY
% This code computes (and saves) the Markov equilibrium in the laissez-faire economy with flexible prices.

clear; clc; close all;  

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h l_F x_l a_l

tic 

%Parameters
load parameters.mat
load frictionless.mat 

% Employment Gap 
a_l = 0; x_l = .174;  

%% ODE, Chebyshev Solver

global xmin xmax

% Grid for the state variable x \in [0,1] 
N   = 190;                           
gc  = sort(cos(pi*(0:N)/N),2)';      %chebyshev collocation
gs  = cos(pi/2*(2*N+1:-2:1)/(N+1))'; %alternative collocation

xmin = 0;
xmax = 1;

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

xc    =  m*gc  + b;  %grid with chebyshev collocation
x     =  m*gs  + b;  %grid with alternative collocation

% ODE
% Optimization options:
opt = optimset('Display','iter','MaxFunEvals',1e6,'MaxIter',100);

% Initial guess: equilibrium outcome in the frictionless economy
u_q0 = [q_F/y_F;zeros(N,1)]; 
u_v0 = [1;zeros(N,1)];

% Solve the ODEs:
z = fsolve(@(z) ODE(z(1:N+1),z(N+2:2*N+2),x),[u_q0; u_v0],opt);
u_q = z(1:N+1);
u_v = z(N+2:2*N+2);
[~,ODE_q,ODE_v,x_L] = ODE(u_q,u_v,x);

%% MARKOV EQUILIBRIUM

global wedge phi sigma_x mu_x

% Detrended price of physical capital (and its elasticities w.r.t. state)
[q,qx,qxx] = FF(u_q,x); e_q  = qx.*x./q; e_q2 = qxx.*(x.^2)./q;

% Tobin's Q (and its elasticities w.r.t. state)
[v,vx,vxx] = FF(u_v,x); e_v  = vx.*x./v; e_v2 = vxx.*(x.^2)./v;

% Leverage ratio 
phi = min(lambda*v,1./x); 

% Aggregate labor
l = exp(a_l.*(x-x_l)); e_l = a_l*x;
wedge = l.^(1+psi);

% Threshold state
x_L = find( lambda.*v.*x >= 1,1,'first');

if x_L < size(x,1) & x(x_L)*lambda*v(x_L) == 1
    x_L = x_L + 1;
end  

% Aggregate supply of capital services as a share of potential
a = a_h + (1-a_h).*phi.*x;

% Elasticity of a
e_a = (1-a_h)*(1+e_v).*lambda.*v.*x./a;
e_a(x_L:end) = 0*e_a(x_L:end);

% Endogenous TFP
zeta = a.^(1-alpha);

% Diffusion processes
sigma_x = (phi-1)./(1-(e_q+alpha.*e_l+(1-alpha).*e_a).*(phi-1)).*sigma_a;
sigma_v = e_v.*sigma_x;
sigma_q = e_q.*sigma_x;
sigma_y = 1./(1-(e_q+alpha.*e_l+(1-alpha).*e_a).*(phi-1)).*sigma_a - sigma_q;

% Drift process
mu_x = 1./(1-e_q.*(phi-1)).*(phi.*wedge./q.*(1-alpha)./a + .5*(phi-1).*e_q2.*sigma_x.^2 - e_q.*sigma_x.^2 - (phi-1)*rho - gamma + kappa./x);

% Return on Capital
r_k = wedge.*(1-alpha).*y_F.*l.^alpha.*a.^-alpha;

% Sharpe Ratio
sharpe = sigma_y + ( 1./q.*(1-a_h).*(1-alpha)./a )./(sigma_q + sigma_y);
sharpe(x_L:end) = sigma_y(x_L:end) - e_v(x_L:end).*sigma_x(x_L:end);

% Real Interest Rate
mu_aa = 1./a.*(1-a_h).*(x.*lambda.*vx + lambda.*v).*mu_x.*x + .5.*1./a.*(1-a_h).*(2.*lambda.*vx + x.*lambda.*vxx).*sigma_x.^2.*x.^2;
mu_aa(x_L:end) = 0*mu_aa(x_L:end); 

sigma_aa = 1./a.*(1-a_h).*(x.*lambda.*vx + lambda.*v).*sigma_x.*x;
sigma_aa(x_L:end) = 0*sigma_aa(x_L:end); 

mu_l    = a_l.*mu_x.*x + .5.*a_l.^2.*sigma_x.^2.*x.^2;
sigma_l = a_l.*sigma_x.*x;

mu_y = mu_a + (1-alpha).*mu_aa + alpha.*mu_l - 0 + (1-alpha).*sigma_aa.*sigma_a + alpha.*sigma_l.*sigma_a...
    + (1-alpha).*alpha.*sigma_aa.*sigma_l - .5.*(1-alpha).*alpha.*sigma_aa.^2 - .5.*(1-alpha).*alpha.*sigma_l.^2;

sigma_y = sigma_a + (1-alpha).*sigma_aa + alpha.*sigma_l;

r = rho + mu_y - sigma_y.^2;

%% INFLATION -- ODE

% Initial guess: equilibrium outcome in the frictionless economy
u_re0 = [1/(rho+theta);zeros(N,1)]; 
u_mg0 = [1/(rho+theta);zeros(N,1)]; 

% Optimization options:
opt = optimset('Display','iter','MaxFunEvals',1e6,'MaxIter',30);

% Solve the ODEs:
z = fsolve(@(z) ODE_pi(z(1:N+1),z(N+2:2*N+2),x),[u_re0; u_mg0],opt);
u_re = z(1:N+1);
u_mg = z(N+2:2*N+2);
[~,ODE_re,ODE_mg] = ODE_pi(u_re,u_mg,x);

% re, mg and their elasticities
[re,rex,rexx] = FF(u_re,x); [mg,mgx,mgxx] = FF(u_mg,x);

% Inflation 
pi = theta/(epsilon-1)*(1-(mg./re).^-(epsilon-1));


%% ODEs for Social Welfare Values, Chebyshev Solver

% Costs from Financial Distermediation
% Initial guess
u_Ua0 = [-1;zeros(N,1)]; 

% Solve the ODEs:
z = fsolve(@(z) ODE_UA(z,x),u_Ua0,opt);
u_Ua = z;
[~,ODE_UA] = ODE_UA(u_Ua,x);

U_A = FF(u_Ua,x) + 1/rho;

% Aggregate labor
l = l_F*exp(a_l.*(x-x_l));

% Costs from Employment Gaps
% Initial guess
u_Ug0 = (alpha.*log(l_F) - chi./(1+psi).*l_F.^(1+psi))/rho;
u_Ug0 = [u_Ug0;zeros(N,1)];

% Solve the ODEs:
z = fsolve(@(z) ODE_UG(z,x),u_Ug0,opt);
u_Ug = z;
[~,ODE_UG] = ODE_UG(u_Ug,x);

U_G = FF(u_Ug,x);


%% INVARIANT DISTRIBUTION

% Invariant density function
p_x = invdist(x,mu_x,sigma_x);

% Invariant cumulative function
cdf_x = zeros(size(x,1),1);

for i_x = 1:size(x,1)
    if i_x == 1
        cdf_x(i_x) = p_x(i_x)*x(i_x);
    elseif i_x > 1
        cdf_x(i_x) = p_x(i_x)*(x(i_x)-x(i_x-1)) + cdf_x(i_x-1);
    end
end

% Invariant probability measure
m_p = zeros(size(x,1),1);
for i_x = 1:size(x,1)
    if i_x == 1
        m_p(i_x) = p_x(i_x)*x(i_x);
    elseif i_x > 1
        m_p(i_x) = p_x(i_x)*(x(i_x)-x(i_x-1));
    end
end

% Invariant cumulative function for Endogenous TFP
cdf_a = cdf_x; cdf_a(x_L:size(x,1)) = 1 + 0*(x_L:size(x,1));

%% SOCIAL WELFARE

% Present Discounted Value of financial disintermediation
SW_A = (1-alpha).*sum(U_A.*m_p);

% Certainty Equivalent 
CE = exp(rho*SW_A);

%% SAVE EQUILIBRIUM OUTCOME

phi_L = phi; a_L = a; q_L = (l/l_F).^alpha.*a.^(1-alpha).*q; mu_x_L = mu_x; sigma_x_L = sigma_x;  sigma_y_L = sigma_y;  sigma_q_L = sigma_q; p_x_L = p_x; cdf_a_L = cdf_a; v_L = v;
wedge_L = wedge; l_L = l; r_L = r_k; pi_L = pi; CE_LF = CE; SW_A_LF = SW_A;

save NeutralMonetaryPolicyFigure x x_L a_L phi_L q_L mu_x_L sigma_x_L sigma_y_L sigma_q_L p_x_L cdf_a_L v_L wedge_L l_L r_L pi_L x_L
save laissezfaire u_q u_v u_re u_mg u_Ua u_Ug x_L sigma_x SW_A_LF CE_LF
    
toc