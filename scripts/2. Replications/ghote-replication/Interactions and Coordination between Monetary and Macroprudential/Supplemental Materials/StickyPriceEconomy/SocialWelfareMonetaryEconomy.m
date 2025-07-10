%% STICKY PRICE ECONOMY WITHOUT MACRO-PRUDENTIAL POLICY // SOCIAL WELFARE
% This code computes social welfare in the sticky price economy without macro-prudential policy.

clear; clc; close all;  

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital

tic

% Parameters
load parameters.mat
load frictionless.mat

% Equilibria
load laissezfaire.mat
load SociallyOptimalMonetaryPolicyFigure.mat

% State
N = size(x,1);

% Time Interval 
dt = .001; T  = 15000; t  = 0:dt:T;

% Brownian Shock
dz = normrnd(0,1,1,size(t,2));

% Initial State
[~,i_ss] = min(abs(mu_x));

%Dynamics
i_t      = 0*t; i_t(1) = i_ss;    %grid of state \eta
x_t      = 0*t; x_t(1) = x(i_ss); %\eta
y_t      = 0*t; y_t(1) = 1;       %\omega
pi_t     = 0*t;                   %inflation
mu_y_t   = 0*t;                   %drift of \eta
p_star_t = 0*t; p_star_t(1) = 1;  %optimal real price  
a_t      = 0*t; a_t(1) = a(i_ss); %productivity losses from financial disintermediation

for i_s = 2:size(t,2)
    
    x_t(i_s) = x_t(i_s-1) + mu_x(i_t(i_s-1))*x_t(i_s-1)*dt + sigma_x(i_t(i_s-1))*x_t(i_s-1)*sqrt(dt)*dz(i_s-1); % law of motion of \eta
    y_t(i_s) = y_t(i_s-1) + mu_y_t(i_s-1)   *y_t(i_s-1)*dt;                                                     % law of motion of \omega
    
    [~,I] = min(abs(x-x_t(i_s))); i_t(i_s) = I;
    pi_t(i_s)   = pi(i_t(i_s)); p_star_t(i_s) = ( 1 - (epsilon-1)/theta*pi_t(i_s) )^(-1/(epsilon-1));
    mu_y_t(i_s) = theta*(p_star_t(i_s)^(-epsilon)/y_t(i_s)-1) + epsilon*pi_t(i_s);
    a_t(i_s)    = a(i_t(i_s));
    
end  

y_tt = y_t(150000:end); a_tt = a_t(150000:end); 

SW_D  = sum(-log(y_tt))/size(y_tt,2);

SW_AA = (1-alpha)*sum(log(a_tt))/size(a_tt,2);

%% SOCIAL WELFARE GAINS

% Financial Disintermediation 
CE_A  = exp(rho*SW_A);  CEA_gain  = (CE_A - CE_LF)/CE_LF * 100;  

CE_AA = exp(SW_AA);     CEAA_gain = (CE_AA - CE_LF)/CE_LF * 100;

% Employment Gap 
CE_G = exp(rho*SW_G); CEG_gain = (CE_G - 1) * 100;

% Price Dispersion 
CE_D = exp(SW_D); CED_gain = (CE_D - 1) * 100;

CE_gain_FinInteremdiation = CEA_gain; CE_gain_FinInteremdiation

CE_gain_Inflation = CEG_gain + CED_gain; CE_gain_Inflation

CE_gain_SocialWelfare = CE_gain_FinInteremdiation + CE_gain_Inflation; CE_gain_SocialWelfare 

toc
