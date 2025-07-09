%% FLEXIBLE PRICE ECONOMY
% This code computes (and saves) the Markov equilibrium in the financially regulated economy.

clear; clc; close all; 

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h xL xH coeff K 

tic 

%Parameters
load parameters.mat
load frictionless.mat 

load laissezfaire.mat 
u_qLF = u_q; u_vLF = u_v; sigma_xLF = sigma_x; CE_LF = CE;

%Macro-prudential policy
xL = 60; xH = 87; coeff = [-.01 .01]; K = 3;

%% ODE, Chebyshev Solver

global xmin xmax

% Grid for the state variable x \in [0,1] 
N   = 190;                           
gc  = sort(cos(pi*(0:N)/N),2)';      %chebyshev collocation
gs  = cos(pi/2*(2*N+1:-2:1)/(N+1))'; %savov collocation

xmin = 0;
xmax = 1;

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

xc    =  m*gc  + b;  %grid with chebyshev col
x     =  m*gs  + b;  %grid with savov col

% ODE
% Optimization options:
opt = optimset('Display','iter','MaxFunEvals',1e6,'MaxIter',100);

% Initial guess: equilibrium outcome in the frictionless economy
u_q0 = u_q; 
u_v0 = u_v; 

% Solve the ODEs:
z = fsolve(@(z) ODE_CE(z(1:N+1),z(N+2:2*N+2),x),[u_q0; u_v0],opt);
u_q = z(1:N+1);
u_v = z(N+2:2*N+2);
[~,ODE_q,ODE_v] = ODE_CE(u_q,u_v,x);


%% MARKOV EQUILIBRIUM

global phi sigma_x mu_x

% Detrended price of physical capital (and its elasticities w.r.t. state)
[q,qx,qxx] = FF(u_q,x); e_q  = qx.*x./q; e_q2 = qxx.*(x.^2)./q;

% Tobin's Q (and its elasticities w.r.t. state)
[v,vx,vxx] = FF(u_v,x); e_v  = vx.*x./v; e_v2 = vxx.*(x.^2)./v;

% Capital requirement
[Phi, Phix, Phixx, Phii, xH] = CapRequirement(xL,xH,coeff,K,u_v,x);

% Elasticity of capital requirement
e_P = Phix.*x./Phi; e_P2 = Phixx.*(x.^2)./Phi;

% Leverage ratio
phi = lambda*v; phi(xL:xH) = Phi(xL:xH); phi(xH+1:end) = 1./x(xH+1:end); 

% Endogenous productivity
a = a_h + (1-a_h).*phi.*x;

% Elasticity of endogenous productivity
e_a = (1-a_h)*(1+e_v).*lambda.*v.*x./a;
e_a(xL:xH) = (1-a_h)*(1+e_P(xL:xH)).*Phi(xL:xH).*x(xL:xH)./a(xL:xH);
e_a(xH+1:end) = 0*e_a(xH+1:end); 

% Diffusion processes
sigma_x = (phi-1)./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a; % sigma_x = sigma_xLF; %CEE = .0940
sigma_v = e_v.*sigma_x;
sigma_q = e_q.*sigma_x;
sigma_y = 1./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a - sigma_q;

% Drift process
mu_x = 1./(1-e_q.*(phi-1)).*(phi./q.*(1-alpha)./a + .5*(phi-1).*e_q2.*sigma_x.^2 - e_q.*sigma_x.^2 - (phi-1)*rho - gamma + kappa./x);

% Return on Capital
r_k = (1-alpha)*y_F*a.^-alpha;

% Sharpe ratio
sharpe = sigma_y + ( 1./q.*(1-a_h).*(1-alpha)./a )./(sigma_q + sigma_y);
sharpe(x_L:end) = sigma_y(x_L:end) - e_v(x_L:end).*sigma_x(x_L:end);

% Second-order elasticity of endogenous productivity
e_a2           = (1-a_h).*(lambda.*vxx.*x + 2.*lambda.*vx).*(x.^2)./a;
e_a2(xL:xH)    = (1-a_h).*(Phixx(xL:xH).*x(xL:xH) + 2.*Phix(xL:xH)).*(x(xL:xH).^2)./a(xL:xH);
e_a2(xH+1:end) = 0*e_a(xH+1:end); 

% Drift and diffusion of endogenous productivity
mu_A    = e_a.*mu_x + .5*e_a2.*sigma_x.^2;
sigma_A = e_a.*sigma_x;

% Drift and diffusion of endogenous TFP
mu_psi    = (1-alpha).*mu_A + .5.*(-alpha).*(1-alpha).*(x.^2)./a.^2.*sigma_A.^2;
sigma_psi = (1-alpha).*sigma_A;

% Real rate of return
r_real = rho + mu_a + mu_psi + sigma_a.*sigma_psi - (sigma_a+sigma_psi).^2;


%% ODEs for the Value of Households, Chebyshev Solver

% Initial guess: equilibrium outcome in the frictionless economy
u_U0 = u_U; 

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
cdf_a = cdf_x; cdf_a(xH:size(x,1)) = 1 + 0*(xH:size(x,1));

%% CERTAINTY EQUIVALENT

% Social Welfare
SW = (1-alpha).*sum(U.*m_p);

% Certainty Equivalent 
CE = exp(rho*SW); 

% Certainty Equivalent gains relative to the Laissez-faire economy in
% percentage terms

CE_gain = (CE - CE_LF)/CE_LF * 105;


%% SAVE EQUILIBRIUM OUTCOME

save financiallyregulated u_q u_v u_U xL xH sigma_x CE

%% SAVE EQUILIBRIUM OUTCOME FOR FIGURES

qx2  = diff(q)./diff(x);   qx2  = [qx(1); qx2];   e_q  = qx2.*x./q; 
sigma_x = (phi-1)./(1-(e_q+(1-alpha).*e_a).*(phi-1)).*sigma_a;
 
phi_E = phi; a_E = a; q_E = q.*a.^(1-alpha); mu_x_E = mu_x; sigma_x_E = sigma_x;
sigma_q_E = sigma_q; sigma_y_E = sigma_y; p_x_E = p_x; cdf_a_E = cdf_a; v_E = v; cdf_x_E = cdf_x;

save FinanciallyRegulatedFigure x xL xH Phi phi_E a_E q_E mu_x_E sigma_x_E sigma_q_E sigma_y_E p_x_E cdf_x_E cdf_a_E v_E r_real CE_gain

toc