%% LAISSEZ-FAIRE ECONOMY
% This code computes (and saves) the Markov equilibrium in the laissez-faire economy.

clear; clc; close all; 

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h

tic 

%Parameters
load parameters.mat
load frictionless.mat 


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

global phi sigma_x mu_x

% Detrended price of physical capital (and its elasticities w.r.t. state)
[q,qx,qxx] = FF(u_q,x); e_q  = qx.*x./q; e_q2 = qxx.*(x.^2)./q;

% Tobin's Q (and its elasticities w.r.t. state)
[v,vx,vxx] = FF(u_v,x); e_v  = vx.*x./v; e_v2 = vxx.*(x.^2)./v;

% Leverage ratio 
phi = min(lambda*v,1./x); 

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

% Endogenous TFP
zeta = a.^(1-alpha);

% Diffusion processes
sigma_x = (phi-1)./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a;
sigma_v = e_v.*sigma_x;
sigma_q = e_q.*sigma_x;
sigma_y = 1./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a - sigma_q;

% Drift process
mu_x = 1./(1-e_q.*(phi-1)).*(phi./q.*(1-alpha)./a + .5*(phi-1).*e_q2.*sigma_x.^2 - e_q.*sigma_x.^2 - (phi-1)*rho - gamma + kappa./x);

% Aggregate output
y = y_F*a.^(1-alpha);

% Return on physical capital
r_k = (1-alpha)*y_F*a.^-alpha;

% Price of physical capital
Q = q.*y;

% Sharpe Ratio
sharpe = sigma_y + ( 1./q.*(1-a_h).*(1-alpha)./a )./(sigma_q + sigma_y);
sharpe(x_L:end) = sigma_y(x_L:end) - e_v(x_L:end).*sigma_x(x_L:end);

% Second-order elasticity of endogenous productivity
e_a2           = (1-a_h).*(lambda.*vxx.*x + 2.*lambda.*vx).*(x.^2)./a;
e_a2(x_L:end)  = 0*e_a(x_L:end); 

% Drift and Diffusion of endogenous productivity
mu_A    = e_a.*mu_x + .5*e_a2.*sigma_x.^2;
sigma_A = e_a.*sigma_x;

% Drift and Diffusion of Endogenous TFP
mu_psi    = (1-alpha).*mu_A + .5.*(-alpha).*(1-alpha).*(x.^2)./a.^2.*sigma_A.^2;
sigma_psi = (1-alpha).*sigma_A;

% Real rate of return
r_real = rho + mu_a + mu_psi + sigma_a.*sigma_psi - (sigma_a+sigma_psi).^2;


%% ODEs for the Value of Households, Chebyshev Solver

% Initial guess: equilibrium outcome in the frictionless economy
u_U0 = [-1;zeros(N,1)];

% Solve the ODEs:
z = fsolve(@(z) ODE_HU(z,x),u_U0,opt);
u_U = z;
[~,ODE_U] = ODE_HU(u_U,x);

U = FF(u_U,x) + 1/rho;


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


%% TARGETS 

% Average Sharpe Ratio
sharpe_av = sum(sharpe.*m_p);

% Average Leverage Multiple
phi_av = sum(phi.*m_p);

% Average Wealth Share of Financial Intermediaries
wealth_av = sum(x.*m_p);

%% CERTAINTY EQUIVALENT

% Social Welfare
SW = (1-alpha).*sum(U.*m_p);

% Certainty Equivalent 
CE = exp(rho*SW);


%% SAVE EQUILIBRIUM OUTCOME

save laissezfaire u_q u_v u_U x_L sigma_x CE
 
%% SAVE EQUILIBRIUM OUTCOME FOR FIGURES

phi_L = phi; a_L = a; q_L = q.*a.^(1-alpha); mu_x_L = mu_x; sigma_x_L = sigma_x;  sigma_y_L = sigma_y;  sigma_q_L = sigma_q;
p_x_L = p_x; cdf_a_L = cdf_a; v_L = v; r_real_L = r_real; cdf_x_L = cdf_x;

save LaissezFaireFigure x x_L a_L phi_L q_L mu_x_L sigma_x_L sigma_y_L sigma_q_L p_x_L cdf_x_L cdf_a_L v_L r_real_L

toc