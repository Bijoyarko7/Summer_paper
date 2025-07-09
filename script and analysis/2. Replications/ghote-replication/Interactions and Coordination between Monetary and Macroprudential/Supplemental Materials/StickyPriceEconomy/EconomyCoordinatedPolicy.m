%% STICKY PRICE ECONOMY WITH MACRO-PRUDENTIAL POLICY
% This code compute (and saves) the Markov equilibrium in the sticky price economy with macro-prudential policy.
 
clear; clc; close all; 

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h l_F x_l a_l xL xH coeff K

tic 

%Parameters
load parameters.mat
load frictionless.mat 

load laissezfaire.mat

% Employment Gap 
a_l = -.025; x_l = .185; 

% Macro-prudential policy
xL = 60; xH = 90; coeff = [-.01 .01]; K = 3; 

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
u_q0 = u_q; %[q_F/y_F;zeros(N,1)]; %
u_v0 = u_v; %[1;zeros(N,1)]; %

% Solve the ODEs:
z = fsolve(@(z) ODE_CE(z(1:N+1),z(N+2:2*N+2),x),[u_q0; u_v0],opt);
u_q = z(1:N+1);
u_v = z(N+2:2*N+2);
[~,ODE_q,ODE_v] = ODE_CE(u_q,u_v,x);

%% MARKOV EQUILIBRIUM

global wedge phi sigma_x mu_x

% q, v and their elasticities
[q,qx,qxx] = FF(u_q,x); e_q  = qx.*x./q; e_q2 = qxx.*(x.^2)./q;
[v,vx,vxx] = FF(u_v,x); e_v  = vx.*x./v; e_v2 = vxx.*(x.^2)./v;

% Capital Requirement
[Phi, Phix, PPhi] = CapRequirement(xL,xH,coeff,K,u_v,x);

% Aggregate labor
l = exp(a_l.*(x-x_l)); e_l = a_l*x;
wedge = l.^(1+psi);

% Elasticity of Capital Requirement
e_P = Phix.*x./Phi;

% Leverage ratio
phi = lambda*v; phi(xL:xH) = Phi(xL:xH); phi(xH+1:end) = 1./x(xH+1:end);  

% Endogenous TFP
a = a_h + (1-a_h).*phi.*x;

% Elasticity of Endogenous TFP
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

% Return on Capital
r_k = wedge.*(1-alpha).*y_F.*l.^alpha.*a.^-alpha;


%% INFLATION -- ODE

% Initial guess: equilibrium outcome in the frictionless economy
u_re0 = [1/(rho+theta);zeros(N,1)]; %u_re; %
u_mg0 = [1/(rho+theta);zeros(N,1)]; %u_mg; %

% Optimization options:
opt = optimset('Display','iter','MaxFunEvals',1e6,'MaxIter',50);

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
u_Ua0 = [-1;zeros(N,1)]; %normalization of U to -1

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

% Present Discounted Value of employment gap
SW_G = sum(U_G.*m_p) - (alpha*log(l_F) - chi/(1+psi)*l_F^(1+psi))/rho;


% Certainty Equivalent gains relative to the Laissez-faire economy in
% percentage terms

CE_gain = (CE - CE_LF)/CE_LF * 100;

%% SAVE EQUILIBRIUM OUTCOME
    
phi_C = phi; a_C = a; q_C = (l/l_F).^alpha.*a.^(1-alpha).*q; mu_x_C = mu_x; sigma_x_C = sigma_x;  sigma_q_C = sigma_q; p_x_C = p_x; cdf_a_C = cdf_a; v_C = v;
wedge_C = wedge; l_C = l; r_C = r_k; pi_C = pi; xL_C = xL; xH_C = xH; CE_C = CE; CE_gain_C = CE_gain;

save CoordinatedPolicyFigure x x_L a_C phi_C Phi q_C mu_x_C sigma_x_C sigma_q_C p_x_C cdf_a_C v_C wedge_C l_C r_C pi_C xL_C xH_C CE_C CE_gain_C SW_A SW_G mu_x sigma_x pi a


toc