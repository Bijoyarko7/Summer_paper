%% FRICTIONLESS ECONOMY
% This code computes (and saves) the Markov equilibrium in the frictionless economy.

clear; clc; close all

global mu_a sigma_a alpha theta epsilon rho psi chi gamma kappa lambda capital a_h 

% Parameters
load parameters


%% Equilibrium Outcome

l_F = (alpha/chi)^(1/(1+psi));

y_F = l_F^alpha*capital^(1-alpha);

r_F = (1-alpha)*y_F/capital;

w_F = alpha*y_F/l_F;

q_F = r_F/rho;

R_F = rho + mu_a - sigma_a^2;

W_F = ( (mu_a - .5*sigma_a^2)/rho + alpha/(1+psi)*log(alpha/chi) + (1-alpha)*log(capital) - alpha/(1+psi) )/rho;


save frictionless l_F y_F r_F w_F q_F R_F W_F  