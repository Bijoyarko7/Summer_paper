%% STICKY PRICE ECONOMY
% The code computes the steady states.

clear;  
clc; 
global mu_a sigma_a alpha theta epsilon rho psi chi mm omega_l omega_h rho_w delta kappa exp_kappa lambda capital  v_max

tic 

%Parameters
load parameters.mat
load frictionless.mat 


%% STEADY STATES

% Grid for the state variable x \in [0,1] 
N   = 1000;                          %degree of polynomial
gc  = sort(cos(pi*(0:N)/N),2)';      %chebyshev collocation
gs  = cos(pi/2*(2*N+1:-2:1)/(N+1))'; %savov collocation

% Inflation 
xmin = -0.03;
xmax =  0.03;%.95*theta/epsilon;

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

ppic    =  m*gc  + b;  %grid with chebyshev col
ppi     =  m*gs  + b;  %grid with savov col

labor   = l_F.*( (rho + theta - epsilon.*ppi)./(theta - epsilon.*ppi).*(theta - (epsilon-1).*ppi)./(rho + theta - (epsilon-1).*ppi) ).^(1/(1+psi));

varphi  = theta./(theta - epsilon.*ppi).*(1 - (epsilon-1)/theta.*ppi).^(epsilon/(epsilon-1));


%% FIGURES 

figure(1)
subplot(1,2,2)
plot(ppi,varphi,'LineWidth',2.5); set(gca,'FontSize',18)
title('Price Dispersion','FontSize',20); xlabel('Inflation','FontSize',18)
xlim([xmin xmax])
grid on
subplot(1,2,1)
plot(ppi,log(labor/l_F),'LineWidth',2.5); set(gca,'FontSize',18)
title('Employment Gap','FontSize',20); xlabel('Inflation','FontSize',18)
xlim([xmin xmax])
grid on



