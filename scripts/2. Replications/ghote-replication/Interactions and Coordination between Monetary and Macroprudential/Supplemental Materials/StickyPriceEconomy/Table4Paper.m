%% STICKY PRICE ECONOMY WITH MACRO-PRUDENTIAL POLICY: TABLE 4
% This code generates Table 4 in the paper.
 
clear; clc; close all; 

tic 

%% INPUTS

% Parameters 
load parameters.mat
load frictionless.mat

% Equilibria 
load NeutralMonetaryPolicyFigure.mat
load CoordinatedPolicyFigure.mat  

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
m_p_C = zeros(size(x,1),1);
for i_x = 1:size(x,1)
    if i_x == 1
        m_p_C(i_x) = p_x_C(i_x)*x(i_x);
    elseif i_x > 1
        m_p_C(i_x) = p_x_C(i_x)*(x(i_x)-x(i_x-1));
    end
end

%Endogenous TFP
xi_L = a_L.^(1-alpha); xi_C = a_C.^(1-alpha);

%Productivity losses
PL_L = 1-a_L.^(1-alpha); PL_C = 1-a_C.^(1-alpha);

%Employment gap
gap_L = log(l_L/l_F); gap_C = log(l_C/l_F);

%Price of Physical Capital
q_L = q_L/((1-alpha)/rho); q_C = q_C/((1-alpha)/rho);

%Rental rates
r_L = (1-alpha)*y_F*a_L.^-alpha; r_C = (1-alpha)*y_F*a_C.^-alpha;

%Dividend yields
R_L = r_L./(((1-alpha)/rho)*y_F*q_L); R_C = r_C./(((1-alpha)/rho)*y_F*q_C);

%Percentage difference --- with respect to min{lambda*v,1/eta}
xL = xL_C-2; xH = xH_C+1;

Delta_C  = abs( ( Phi(xL:xH) - min(lambda*v_C(xL:xH),1./x(xL:xH)) ) ) ./ ( ( Phi(xL:xH) + min(lambda*v_C(xL:xH),1./x(xL:xH)) ) / 2 );

Delta_m  = sum( Delta_C.*m_p_C(xL:xH) / sum(m_p_C(xL:xH)) );
Delta_v  = sum( (Delta_C - Delta_m).^2.*m_p_C(xL:xH) / sum(m_p_C(xL:xH)) );
Delta_vo = sqrt(Delta_v);

%Percentage difference --- with respect to lambda*v
Delta_EA  = abs( ( Phi(xL:xH) - lambda*v_C(xL:xH) ) ) ./ ( ( Phi(xL:xH) + min(lambda*v_C(xL:xH),1./x(xL:xH)) ) / 2 );

Delta_mA  = sum( Delta_EA.*m_p_C(xL:xH) / sum(m_p_C(xL:xH)) );
Delta_vA  = sum( (Delta_EA - Delta_mA).^2.*m_p_C(xL:xH) / sum(m_p_C(xL:xH)) );
Delta_voA = sqrt(Delta_vA);

%% FREQUENCIES & LOWER THRESHOLDS

%NULL EMPLOYMENT GAP

% Lower threshold
[V_L,I_L] = min(abs(xi_L - 0.90));

BU_L = sum(m_p_L(1:I_L)); TR_L = sum(m_p_L(I_L+1:x_L)); BO_L = sum(m_p_L(x_L+1:end));

FR_L = [BU_L TR_L BO_L];


%SOCIALLY OPTIMAL EMPLOYMENT GAP

% Thresholds
[V_E,I_C] = min(abs(xi_C - 0.90)); x_C =xH_C;

BU_C = sum(m_p_C(1:I_C)); TR_C = sum(m_p_C(I_C+1:x_C)); BO_C = sum(m_p_C(x_C+1:end)); BIND_C = sum(m_p_C(xL_C+4:xH_C-6));

FR_C = [BU_C TR_C BO_C];


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
vC = [x gap_C log(R_C) xi_C pi_C]; 

%Thresholds
xL = I_C; xH = xH_C;

%Means, Variances, Volatilities, Correlations
vC_mU  = zeros(1,size(vC,2)); vC_mB  = zeros(1,size(vC,2)); vC_mT  = zeros(1,size(vC,2)); vC_mS  = zeros(1,size(vC,2));
vC_vU  = zeros(1,size(vC,2)); vC_vB  = zeros(1,size(vC,2)); vC_vT  = zeros(1,size(vC,2)); vC_vS  = zeros(1,size(vC,2));
vC_voU = zeros(1,size(vC,2)); vC_voB = zeros(1,size(vC,2)); vC_voT = zeros(1,size(vC,2)); vC_voS = zeros(1,size(vC,2));
vC_cU  = zeros(1,size(vC,2)); vC_cB  = zeros(1,size(vC,2)); vC_cT  = zeros(1,size(vC,2)); vC_cS  = zeros(1,size(vC,2));

for j =1:size(vC,2)
    
    %Means -- Unconditional, Conditional on Bust, Transtion and Boom
    vC_mU(j) = sum(vC(:,j).*m_p_C);
    vC_mB(j) = sum(vC(1:xL,j)  .*m_p_C(1:xL)  /sum(m_p_C(1:xL)));
    vC_mT(j) = sum(vC(xL:xH,j) .*m_p_C(xL:xH) /sum(m_p_C(xL:xH)));
    vC_mS(j) = sum(vC(xH:end,j).*m_p_C(xH:end)/sum(m_p_C(xH:end)));
    
    %Variances -- Unconditional, Conditional on Bust, Transtion and Boom
    vC_vU(j) = sum((vC(:,j)     -vC_mU(j)).^2.*m_p_C);
    vC_vB(j) = sum((vC(1:xL,j)  -vC_mB(j)).^2.*m_p_C(1:xL)  /sum(m_p_C(1:xL)));
    vC_vT(j) = sum((vC(xL:xH,j) -vC_mT(j)).^2.*m_p_C(xL:xH) /sum(m_p_C(xL:xH)));
    vC_vS(j) = sum((vC(xH:end,j)-vC_mS(j)).^2.*m_p_C(xH:end)/sum(m_p_C(xH:end)));
    
    %Volatilities -- Unconditional, Conditional on Bust, Transtion and Boom
    vC_voU(j) = sqrt(vC_vU(j));
    vC_voB(j) = sqrt(vC_vB(j));
    vC_voT(j) = sqrt(vC_vT(j));
    vC_voS(j) = sqrt(vC_vS(j));

    %Correlations -- Unconditional, Conditional on Bust, Transtion and Boom
    vC_cU(j) = sum((vC(:,1)     -vC_mU(1)).*(vC(:,j)     -vC_mU(j)).*m_p_C)                           ./(vC_voU(1).*vC_voU(j));
    vC_cB(j) = sum((vC(1:xL,1)  -vC_mB(1)).*(vC(1:xL,j)  -vC_mB(j)).*m_p_C(1:xL)  /sum(m_p_C(1:xL)))  ./(vC_voB(1).*vC_voB(j));
    vC_cT(j) = sum((vC(xL:xH,1) -vC_mT(1)).*(vC(xL:xH,j) -vC_mT(j)).*m_p_C(xL:xH) /sum(m_p_C(xL:xH))) ./(vC_voT(1).*vC_voT(j));
    vC_cS(j) = sum((vC(xH:end,1)-vC_mS(1)).*(vC(xH:end,j)-vC_mS(j)).*m_p_C(xH:end)/sum(m_p_C(xH:end)))./(vC_voS(1).*vC_voS(j));  
    
end  

%% TABLE 4

table = zeros(3,8);

table(1,[1 3 5]) = vC_mB(3:5);  table(2,[1 3 5]) = vC_mT(3:5);  table(2,7) = Delta_m;  table(3,[1 3 5]) = vC_mS(3:5);
table(1,[2 4 6]) = vC_voB(3:5); table(2,[2 4 6]) = vC_voT(3:5); table(2,8) = Delta_vo; table(3,[2 4 6]) = vC_voS(3:5);


table4 = table; table4


toc