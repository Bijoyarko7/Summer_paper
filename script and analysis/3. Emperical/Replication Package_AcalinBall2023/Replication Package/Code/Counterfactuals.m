% "Did the U.S. really grow its way out of its WWII debt?"
% by Julien Acalin and Laurence Ball

% Step 3: Code for Computing Counterfactuals
% by Kyung Woong Koh
% June 16, 2023

% Equations (6) (A.2): Calculate Adjustment Term x_j1_t_ALL for ALL debt
x_j1_t_ALL = zeros(length(year),length(year));

z_j1_t_ALL = zeros(length(year),length(year));

% [**] removed code on booleans (rpeg_boolean, nopeg_boolean, PB_hat_boolean) 
% entirely, 
% Here, we just keep the default case of rpeg_boolean == false
% and nopeg_boolean == true


% % Robustness assuming ex ante real rate was a constant during the peg
% % period (0,1,2%)
% if rpeg_boolean == true
%     for t = (2:1:length(year))
%         for j = (0:1:t-2)
%             if year(t-1-j,1) <= startyear
% 			    x_j1_t_ALL(t-1-j,t) = 0;
% 		    elseif year(t-1-j,1) < expyear
% 			    x_j1_t_ALL(t-1-j,t) = pi_gdp(t,1) + rpeg - i_j(t-1-j,t);
% 		    elseif year(t-1-j,1) == expyear
%                 if j == 0
% 				    x_j1_t_ALL(t-1-j,t) = (1-s(t-1,1))*(pi_gdp(t,1) + rpeg - i_j(t-1-j,t));
%                 else
% 				    x_j1_t_ALL(t-1-j,t) = pi_gdp(t,1) + rpeg - i_j(t-1-j,t);
%                 end
%             elseif year(t-1-j,1) < TIPSbreakyear
%                 if j == 0
% 				    x_j1_t_ALL(t-1-j,t) = (1-s(t-1,1))*pi_error_Q(t-1-j,t);
%                 else
% 				    x_j1_t_ALL(t-1-j,t) = pi_error_Q(t-1-j,t);
%                 end
%             elseif year(t-1-j,1) >= TIPSbreakyear
%                 if j == 0
%                     x_j1_t_ALL(t-1-j,t) = (1 - s(t-1,1) - w_j_TIPS(t-1-j,t-1) * z(t-1,1) / w_j(t-1-j,t-1)) * pi_error_Q(t-1-j,t);
%                 else
%                     x_j1_t_ALL(t-1-j,t) = (1 - w_j_TIPS(t-1-j,t-1) * z(t-1,1) / w_j(t-1-j,t-1)) * pi_error_Q(t-1-j,t);
%                 end
%             end
%         end
%     end
% %Baseline using term structure of ex ante real interest rates
% elseif (rpeg_boolean == false) && (nopeg_boolean == false)
    for t = (2:1:length(year))
        for j = (0:1:t-2)
            if year(t-1-j,1) <= startyear
			    x_j1_t_ALL(t-1-j,t) = 0;
		    elseif year(t-1-j,1) < expyear
			    x_j1_t_ALL(t-1-j,t) = pi_gdp(t,1) + rtilde_j(t-1-j,t) - i_j(t-1-j,t);
		    elseif year(t-1-j,1) == expyear
                if j == 0
				    x_j1_t_ALL(t-1-j,t) = (1-s(t-1,1))*(pi_gdp(t,1) + rtilde_j(t-1-j,t) - i_j(t-1-j,t));
                else
				    x_j1_t_ALL(t-1-j,t) = pi_gdp(t,1) + rtilde_j(t-1-j,t) - i_j(t-1-j,t);
                end
            elseif year(t-1-j,1) < TIPSbreakyear
                if j == 0
				    x_j1_t_ALL(t-1-j,t) = (1-s(t-1,1))*pi_error_Q(t-1-j,t);
                else
				    x_j1_t_ALL(t-1-j,t) = pi_error_Q(t-1-j,t);
                end
            elseif year(t-1-j,1) >= TIPSbreakyear
                if j == 0
                    z_j1_t_ALL(t-1-j,t-1) = w_j_TIPS(t-1-j,t-1) * z(t-1,1) / w_j(t-1-j,t-1);
                    x_j1_t_ALL(t-1-j,t) = (1 - s(t-1,1) - z_j1_t_ALL(t-1-j,t-1)) * pi_error_Q(t-1-j,t);
                else
                    z_j1_t_ALL(t-1-j,t-1) = w_j_TIPS(t-1-j,t-1) * z(t-1,1) / w_j(t-1-j,t-1);
                    if z_j1_t_ALL(t-1-j,t-1) > 1
                        z_j1_t_ALL(t-1-j,t-1) = 1;
                    end
                    x_j1_t_ALL(t-1-j,t) = (1 - z_j1_t_ALL(t-1-j,t-1)) * pi_error_Q(t-1-j,t);
                end
            end
        end
    end
% %Robustness: Assuming ex ante real rate during the peg were not distorted    
% elseif (rpeg_boolean == false) && (nopeg_boolean == true)
%     for t = (2:1:length(year))
%         for j = (0:1:t-2)
%             if year(t-1-j,1) <= startyear
% 			    x_j1_t_ALL(t-1-j,t) = 0;
% 		    elseif year(t-1-j,1) < expyear
% 			    x_j1_t_ALL(t-1-j,t) = 0;
% 		    elseif year(t-1-j,1) == expyear
%                 if j == 0
% 				    x_j1_t_ALL(t-1-j,t) = 0;
%                 else
% 				    x_j1_t_ALL(t-1-j,t) = 0;
%                 end
%             elseif year(t-1-j,1) < TIPSbreakyear
%                 if j == 0
% 				    x_j1_t_ALL(t-1-j,t) = (1-s(t-1,1))*pi_error_Q(t-1-j,t);
%                 else
% 				    x_j1_t_ALL(t-1-j,t) = pi_error_Q(t-1-j,t);
%                 end
%             elseif year(t-1-j,1) >= TIPSbreakyear
%                 if j == 0
%                     x_j1_t_ALL(t-1-j,t) = (1 - s(t-1,1) - w_j_TIPS(t-1-j,t-1) * z(t-1,1) / w_j(t-1-j,t-1)) * pi_error_Q(t-1-j,t);
%                 else
%                     x_j1_t_ALL(t-1-j,t) = (1 - w_j_TIPS(t-1-j,t-1) * z(t-1,1) / w_j(t-1-j,t-1)) * pi_error_Q(t-1-j,t);
%                 end
%             end
%         end
%     end
% end

x_j1_t_ALL(isnan(x_j1_t_ALL)) = 0;

% Equation (5): Creating Weighted Adjustment Term
% and computing Counterfactual Interest Rate Time Series (ihat_ALL)
xw_ALL = zeros(length(year),length(year));
xw_sum_ALL = zeros(length(year),1);

for t = (2:1:length(year))
    for j = (0:1:t-2)
        xw_ALL(t-1-j,t) = x_j1_t_ALL(t-1-j,t) * w_j(t-1-j,t-1);
    end
    xw_sum_ALL(t,1) = sum(xw_ALL(:,t));
end

% Counterfactual Interest Rate Time Series (ihat_ALL)
i_hat_ALL = i_actual + xw_sum_ALL;

% Counterfactual Debt Series
D_hat = zeros(length(D_actual),1);
D_hat_NDRR = zeros(length(D_actual),1);
D_hat_NDRR_ZeroPB = zeros(length(D_actual),1);
D_hat_ZeroPB = zeros(length(D_actual),1);
D_hat_PBhat = zeros(length(D_actual),1);
D_hat_NDRR_ZeroPB_ZeroE = zeros(length(D_actual),1);

DYratio_hat = zeros(length(D_actual),1); %Replication
DYratio_hat_NDRR = zeros(length(D_actual),1); %Adjusted Interest Rate
DYratio_hat_NDRR_ZeroPB = zeros(length(D_actual),1); %Combined Counterfactual
DYratio_hat_ZeroPB = zeros(length(D_actual),1); %Primary Balance
DYratio_hat_PBhat = zeros(length(D_actual),1);
DYratio_hat_NDRR_ZeroPB_ZeroE = zeros(length(D_actual),1); %Combined Counterfactual with epsilon=0

% [**] As we remove booleans, we also remove the CBO's counterfactual 
% path of primary balances and all the code that we would otherwise import [**]

% % If PB_hat_boolean is true, the primary balance is same as actual
% % If false then we replace it with the CBO forecast from 2022 (not used in
% % main text)

% if PB_hat_boolean == true
    PB_hat = PB_actual;
% elseif PB_hat_boolean == false
%     % [**] I could move this code to 'FiscalData.m', and then just refer
%     % the CBO's counterfactual PB here. See 'FiscalData.m', Part 4 
%     % for the corresponding code [**]
%     PBYratio_hat = readtable(strcat('Input_Counterfactual.xlsx'),sheet='CBO_pb',VariableNamingRule='preserve');
%     PBYratio_hat = table2array(PBYratio_hat);
%     PBYratio_hat = PBYratio_hat(1:end,3);
%     PBYratio_hat = [PBYratio_actual(1:5,1); PBYratio_hat];
%     PB_hat = PBYratio_hat .* GDP_actual / 100;
% end

% NDRR: No Distorted Real Rates
% ZeroPB: Zero Primary Balances
% NDRR_ZeroPB: No Distorted Real Rates AND Zero Primary Balances
% PBhat: Actual interest rates, CBO PB Forecasts
% NDRR_ZeroPB_ZeroE: No Distorted Real Rates AND Zero Primary
% Balances AND epsilon=0


for t = (1:1:length(year))
    if t <= 1947-startyear
        D_hat(t,1) = D_actual(t,1);
        D_hat_NDRR(t,1) = D_actual(t,1);
        D_hat_NDRR_ZeroPB(t,1) = D_actual(t,1);
        D_hat_ZeroPB(t,1) = D_actual(t,1);
        D_hat_PBhat(t,1) = D_actual(t,1);
        D_hat_NDRR_ZeroPB_ZeroE(t,1) = D_actual(t,1);
    else
        D_hat(t,1) = D_hat(t-1,1)*(1+i_actual(t,1)/100) - PB_actual(t,1) + residual(t,1);
        D_hat_NDRR(t,1) = D_hat_NDRR(t-1,1)*(1+i_hat_ALL(t,1)/100) - PB_hat(t,1) + residual(t,1);
        D_hat_NDRR_ZeroPB(t,1) = D_hat_NDRR_ZeroPB(t-1,1)*(1+i_hat_ALL(t,1)/100) + residual(t,1);
        D_hat_ZeroPB(t,1) = D_hat_ZeroPB(t-1,1)*(1+i_actual(t,1)/100) + residual(t,1);
        D_hat_PBhat(t,1) = D_hat_PBhat(t-1,1)*(1+i_actual(t,1)/100) - PB_hat(t,1) + residual(t,1);
        D_hat_NDRR_ZeroPB_ZeroE(t,1) = D_hat_NDRR_ZeroPB_ZeroE(t-1,1)*(1+i_hat_ALL(t,1)/100);
    end
    DYratio_hat(t,1) = D_hat(t,1) / GDP_actual(t,1) * 100;
    DYratio_hat_NDRR(t,1) = D_hat_NDRR(t,1) / GDP_actual(t,1) * 100;
    DYratio_hat_NDRR_ZeroPB(t,1) = D_hat_NDRR_ZeroPB(t,1) / GDP_actual(t,1) * 100;
    DYratio_hat_ZeroPB(t,1) = D_hat_ZeroPB(t,1) / GDP_actual(t,1) * 100;
    DYratio_hat_PBhat(t,1) = D_hat_PBhat(t,1) / GDP_actual(t,1) * 100;
    DYratio_hat_NDRR_ZeroPB_ZeroE(t,1) = D_hat_NDRR_ZeroPB_ZeroE(t,1) / GDP_actual(t,1) * 100;
end

save('../Results/Counterfactuals.mat');

cd ../Code