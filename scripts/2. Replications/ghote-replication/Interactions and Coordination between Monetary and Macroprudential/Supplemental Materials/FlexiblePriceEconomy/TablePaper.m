%% FLEXIBLE PRICE ECONOMY: TABLE 2 IN THE PAPER
% This code generates Table 2 and derives the numerical results in
% Subsection III.A.
 
clear; clc; close all; 

tic 

%% INPUTS

% Parameters 
load parameters.mat
load frictionless.mat

% Equilibria 
load LaissezFaireFigure.mat
load FinanciallyRegulatedFigure.mat 

% Invariant probability measure --- Laissez-faire
m_p_L = zeros(size(x,1),1);
for i_x = 1:size(x,1)
    if i_x == 1
        m_p_L(i_x) = p_x_L(i_x)*x(i_x);
    elseif i_x > 1
        m_p_L(i_x) = p_x_L(i_x)*(x(i_x)-x(i_x-1));
    end
end

% Invariant probability measure --- Socially optimal
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

%Price of Physical Capital
q_L = q_L/((1-alpha)/rho); q_E = q_E/((1-alpha)/rho);

%Rental rates
r_L = (1-alpha)*y_F*a_L.^-alpha; r_E = (1-alpha)*y_F*a_E.^-alpha;

%Dividend yields
R_L = r_L./(((1-alpha)/rho)*y_F*q_L); R_E = r_E./(((1-alpha)/rho)*y_F*q_E);

%Percentage difference --- with respect to min{lambda*v,1/eta}
Delta_E  = abs( ( Phi(xL:xH) - min(lambda*v_E(xL:xH),1./x(xL:xH)) ) ) ./ ( ( Phi(xL:xH) + min(lambda*v_E(xL:xH),1./x(xL:xH)) ) / 2 );

Delta_m  = sum( Delta_E.*m_p_E(xL:xH) / sum(m_p_E(xL:xH)) );
Delta_v  = sum( (Delta_E - Delta_m).^2.*m_p_E(xL:xH) / sum(m_p_E(xL:xH)) );
Delta_vo = sqrt(Delta_v);

%Percentage difference --- with respect to lambda*v
Delta_EA  = abs( ( Phi(xL:xH) - lambda*v_E(xL:xH) ) ) ./ ( ( Phi(xL:xH) + min(lambda*v_E(xL:xH),1./x(xL:xH)) ) / 2 );

Delta_mA  = sum( Delta_EA.*m_p_E(xL:xH) / sum(m_p_E(xL:xH)) );
Delta_vA  = sum( (Delta_EA - Delta_mA).^2.*m_p_E(xL:xH) / sum(m_p_E(xL:xH)) );
Delta_voA = sqrt(Delta_vA);

%% FREQUENCIES & LOWER THRESHOLDS

%LAISSEZ-FAIRE

% Lower threshold
[V_L,I_L] = min(abs(xi_L - 0.899));

BU_L = sum(m_p_L(1:I_L)); TR_L = sum(m_p_L(I_L+1:x_L)); BO_L = sum(m_p_L(x_L+1:end));

FR_L = [BU_L TR_L BO_L];


%SOCIALLY OPTIMAL

% Lower threshold
[V_E,I_E] = min(abs(xi_E - 0.899));

BU_E = sum(m_p_E(1:I_E)); TR_E = sum(m_p_E(I_E+1:xH)); BO_E = sum(m_p_E(xH+1:end)); BIND_E = sum(m_p_E(xL:xH));

FR_E = [BU_E TR_E BO_E];

[V_E,I_E] = min(abs(xi_E - 0.9));

%% MOMENTS --- LAISSEZ-FAIRE

%Variables
vL = [x log(R_L) v_L xi_L r_real_L q_L PL_L]; %vL = [x r_L log(r_L) q_L log(q_L) R_L log(R_L) phi_L a_L PL_L];

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
    
%% MOMENTS --- SOCIALLY OPTIMAL

%Variables
vE = [x log(R_E) v_E xi_E PL_E]; %vE = [x r_E log(r_E) q_E log(q_E) R_E log(R_E) phi_E a_E PL_E];

%Lower threshold
xL = I_E;

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


%% TABLE 2

table = zeros(6,8);

table(1,[1 3 5]) = vL_mB(2:4);  table(3,[1 3 5]) = vL_mT(2:4);  table(5,[1 3 5]) = vL_mS(2:4);
table(1,[2 4 6]) = vL_voB(2:4); table(3,[2 4 6]) = vL_voT(2:4); table(5,[2 4 6]) = vL_voS(2:4);

table(2,[1 3 5]) = vE_mB(2:4);  table(4,[1 3 5 7]) = [vE_mT(2:4)  Delta_m];  table(6,[1 3 5]) = vE_mS(2:4);
table(2,[2 4 6]) = vE_voB(2:4); table(4,[2 4 6 8]) = [vE_voT(2:4) Delta_vo]; table(6,[2 4 6]) = vE_voS(2:4);

table2 = table; table2

frequencies = [FR_L; FR_E]; frequencies

binding = BIND_E; binding

productivitylosses = [vL_mU(end) vE_mU(end); vE_voU(end) vL_voU(end)]; productivitylosses

CE = CE_gain

toc