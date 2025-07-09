%% STICKY PRICE ECONOMY WITHOUT MACRO-PRUDENTIAL POLICY: TABLE 3
% This code generates Table 3 in the paper.
 
clear; clc; close all;  

tic 

%% INPUTS

% Parameters 
load parameters.mat
load frictionless.mat

% Equilibria 
load NeutralMonetaryPolicyFigure.mat
load SociallyOptimalMonetaryPolicyFigure.mat

% Invariant probability measure --- Null employment gap
m_p_L = zeros(size(x,1),1);
for i_x = 1:size(x,1)
    if i_x == 1
        m_p_L(i_x) = p_x_L(i_x)*x(i_x);
    elseif i_x > 1
        m_p_L(i_x) = p_x_L(i_x)*(x(i_x)-x(i_x-1));
    end
end

% Invariant probability measure --- Socially optimal employment gap
m_p_E = zeros(size(x,1),1);
for i_x = 1:size(x,1)
    if i_x == 1
        m_p_E(i_x) = p_x_E(i_x)*x(i_x);
    elseif i_x > 1
        m_p_E(i_x) = p_x_E(i_x)*(x(i_x)-x(i_x-1));
    end
end

%Endogenous TFP
xi_L = a_L.^(1-alpha); xi_E = a_E.^(1-alpha);

%Productivity losses
PL_L = 1-a_L.^(1-alpha); PL_E = 1-a_E.^(1-alpha);

%Employment gap
gap_L = log(l_L/l_F); gap_E = log(l_E/l_F);

%Price of Physical Capital
q_L = q_L/((1-alpha)/rho); q_E = q_E/((1-alpha)/rho);

%Rental rates
r_L = (1-alpha)*y_F*a_L.^-alpha; r_E = (1-alpha)*y_F*a_E.^-alpha;

%Dividend yields
R_L = r_L./(((1-alpha)/rho)*y_F*q_L); R_E = r_E./(((1-alpha)/rho)*y_F*q_E);


%% FREQUENCIES & LOWER THRESHOLDS

%NULL EMPLOYMENT GAP

% Lower threshold
[V_L,I_L] = min(abs(xi_L - 0.90));

BU_L = sum(m_p_L(1:I_L)); TR_L = sum(m_p_L(I_L+1:x_L)); BO_L = sum(m_p_L(x_L+1:end));

FR_L = [BU_L TR_L BO_L];


%SOCIALLY OPTIMAL EMPLOYMENT GAP

% Lower threshold
[V_E,I_E] = min(abs(xi_E - 0.90));

BU_E = sum(m_p_E(1:I_E)); TR_E = sum(m_p_E(I_E+1:x_E)); BO_E = sum(m_p_E(x_E+1:end));

FR_E = [BU_E TR_E BO_E];


%% MOMENTS --- NULL EMPLOYMENT GAP

%Variables
vL = [x gap_L log(R_L) xi_L pi_L]; 

%Lower threshold
xL = I_L;

%Means, Variances, Volatilities, Correlations
vL_mU  = zeros(1,size(vL,2)); vL_mB  = zeros(1,size(vL,2)); vL_mT  = zeros(1,size(vL,2)); vL_mS  = zeros(1,size(vL,2));
vL_vU  = zeros(1,size(vL,2)); vL_vB  = zeros(1,size(vL,2)); vL_vT  = zeros(1,size(vL,2)); vL_vS  = zeros(1,size(vL,2));
vL_voU = zeros(1,size(vL,2)); vL_voB = zeros(1,size(vL,2)); vL_voT = zeros(1,size(vL,2)); vL_voS = zeros(1,size(vL,2));
vL_cU  = zeros(1,size(vL,2)); vL_cB  = zeros(1,size(vL,2)); vL_cT  = zeros(1,size(vL,2)); vL_cS  = zeros(1,size(vL,2));

for j =1:size(vL,2)
    
    %Means -- Unconditional, Conditional on Bust, Transtion and Boom
    vL_mU(j) = sum(vL(:,j).*m_p_L);
    vL_mB(j) = sum(vL(1:xL,j)   .*m_p_L(1:xL)   /sum(m_p_L(1:xL)));
    vL_mT(j) = sum(vL(xL:x_L,j) .*m_p_L(xL:x_L) /sum(m_p_L(xL:x_L)));
    vL_mS(j) = sum(vL(x_L:end,j).*m_p_L(x_L:end)/sum(m_p_L(x_L:end)));
    
    %Variances -- Unconditional, Conditional on Bust, Transtion and Boom
    vL_vU(j) = sum((vL(:,j)      -vL_mU(j)).^2.*m_p_L);
    vL_vB(j) = sum((vL(1:xL,j)   -vL_mB(j)).^2.*m_p_L(1:xL)/sum(m_p_L(1:xL)));
    vL_vT(j) = sum((vL(xL:x_L,j) -vL_mT(j)).^2.*m_p_L(xL:x_L)/sum(m_p_L(xL:x_L)));
    vL_vS(j) = sum((vL(x_L:end,j)-vL_mS(j)).^2.*m_p_L(x_L:end)/sum(m_p_L(x_L:end)));
    
    %Volatilities -- Unconditional, Conditional on Bust, Transtion and Boom
    vL_voU(j) = sqrt(vL_vU(j));
    vL_voB(j) = sqrt(vL_vB(j));
    vL_voT(j) = sqrt(vL_vT(j));
    vL_voS(j) = sqrt(vL_vS(j));

    %Correlations -- Unconditional, Conditional on Bust, Transtion and Boom
    vL_cU(j) = sum((vL(:,1)      -vL_mU(1)).*(vL(:,j)      -vL_mU(j)).*m_p_L)                             ./(vL_voU(1).*vL_voU(j));
    vL_cB(j) = sum((vL(1:xL,1)   -vL_mB(1)).*(vL(1:xL,j)   -vL_mB(j)).*m_p_L(1:xL)/sum(m_p_L(1:xL)))      ./(vL_voB(1).*vL_voB(j));
    vL_cT(j) = sum((vL(xL:x_L,1) -vL_mT(1)).*(vL(xL:x_L,j) -vL_mT(j)).*m_p_L(xL:x_L)/sum(m_p_L(xL:x_L)))  ./(vL_voT(1).*vL_voT(j));
    vL_cS(j) = sum((vL(x_L:end,1)-vL_mS(1)).*(vL(x_L:end,j)-vL_mS(j)).*m_p_L(x_L:end)/sum(m_p_L(x_L:end)))./(vL_voS(1).*vL_voS(j));  
    
end    
    
%% MOMENTS --- SOCIALLY OPTIMAL EMPLOYMENT GAP

%Variables
vE = [x gap_E log(R_E) xi_E pi_E]; 

%Thresholds
xL = I_E; xH = x_E;

%Means, Variances, Volatilities, Correlations
vE_mU  = zeros(1,size(vE,2)); vE_mB  = zeros(1,size(vE,2)); vE_mT  = zeros(1,size(vE,2)); vE_mS  = zeros(1,size(vE,2));
vE_vU  = zeros(1,size(vE,2)); vE_vB  = zeros(1,size(vE,2)); vE_vT  = zeros(1,size(vE,2)); vE_vS  = zeros(1,size(vE,2));
vE_voU = zeros(1,size(vE,2)); vE_voB = zeros(1,size(vE,2)); vE_voT = zeros(1,size(vE,2)); vE_voS = zeros(1,size(vE,2));
vE_cU  = zeros(1,size(vE,2)); vE_cB  = zeros(1,size(vE,2)); vE_cT  = zeros(1,size(vE,2)); vE_cS  = zeros(1,size(vE,2));

for j =1:size(vE,2)
    
    %Means -- Unconditional, Conditional on Bust, Transtion and Boom
    vE_mU(j) = sum(vE(:,j).*m_p_E);
    vE_mB(j) = sum(vE(1:xL,j)  .*m_p_E(1:xL)  /sum(m_p_E(1:xL)));
    vE_mT(j) = sum(vE(xL:xH,j) .*m_p_E(xL:xH) /sum(m_p_E(xL:xH)));
    vE_mS(j) = sum(vE(xH:end,j).*m_p_E(xH:end)/sum(m_p_E(xH:end)));
    
    %Variances -- Unconditional, Conditional on Bust, Transtion and Boom
    vE_vU(j) = sum((vE(:,j)     -vE_mU(j)).^2.*m_p_E);
    vE_vB(j) = sum((vE(1:xL,j)  -vE_mB(j)).^2.*m_p_E(1:xL)  /sum(m_p_E(1:xL)));
    vE_vT(j) = sum((vE(xL:xH,j) -vE_mT(j)).^2.*m_p_E(xL:xH) /sum(m_p_E(xL:xH)));
    vE_vS(j) = sum((vE(xH:end,j)-vE_mS(j)).^2.*m_p_E(xH:end)/sum(m_p_E(xH:end)));
    
    %Volatilities -- Unconditional, Conditional on Bust, Transtion and Boom
    vE_voU(j) = sqrt(vE_vU(j));
    vE_voB(j) = sqrt(vE_vB(j));
    vE_voT(j) = sqrt(vE_vT(j));
    vE_voS(j) = sqrt(vE_vS(j));

    %Correlations -- Unconditional, Conditional on Bust, Transtion and Boom
    vE_cU(j) = sum((vE(:,1)     -vE_mU(1)).*(vE(:,j)     -vE_mU(j)).*m_p_E)                           ./(vE_voU(1).*vE_voU(j));
    vE_cB(j) = sum((vE(1:xL,1)  -vE_mB(1)).*(vE(1:xL,j)  -vE_mB(j)).*m_p_E(1:xL)  /sum(m_p_E(1:xL)))  ./(vE_voB(1).*vE_voB(j));
    vE_cT(j) = sum((vE(xL:xH,1) -vE_mT(1)).*(vE(xL:xH,j) -vE_mT(j)).*m_p_E(xL:xH) /sum(m_p_E(xL:xH))) ./(vE_voT(1).*vE_voT(j));
    vE_cS(j) = sum((vE(xH:end,1)-vE_mS(1)).*(vE(xH:end,j)-vE_mS(j)).*m_p_E(xH:end)/sum(m_p_E(xH:end)))./(vE_voS(1).*vE_voS(j));  
    
end  

%% TABLE 3

table = zeros(3,6);

table(1,[1 3 5]) = vE_mB(3:5);  table(2,[1 3 5]) = vE_mT(3:5);  table(3,[1 3 5]) = vE_mS(3:5);
table(1,[2 4 6]) = vE_voB(3:5); table(2,[2 4 6]) = vE_voT(3:5); table(3,[2 4 6]) = vE_voS(3:5);


table3 = table; table3


toc