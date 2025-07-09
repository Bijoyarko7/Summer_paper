%% PARAMETER VALUES
% This code specifies the parameter values.

clear; clc; close all

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h

%% Parameters

mu_a    = .04;  % expected growth rate of aggregate productivity 
sigma_a = .07;  % volatility of growth rate of aggregate productivity 
alpha   = .55;  % labor share of output

theta   = (12/24)*log(2); % arrival rate of opportunity to reset nominal price
epsilon = 2;              % elasticity of subsitution across intermediate goods

rho = .02;             % subjective time discount rate
psi = 1/3;             % Frisch elasticity of labor supply (inverse)
chi = alpha*3^(1+psi); % relative weight to disutility from labor supply

a_h = .70;             % productivity of households at providing capital services to firms  

lambda = 2.5;  % fraction of divertable funds (inverse)
gamma  = .1;   % frequency of dividend payout (inverse)
kappa  = .01;  % aggregate endowment of starting intermediaries 

capital = 1;   % aggregate stock of physical capital

save parameters