% "Did the U.S. really grow out of its World War II debt?"
% by Julien Acalin and Laurence Ball

% Run file for Executing all MATLAB code files
% by Kyung Woong Koh
% June 16, 2023

% This file runs the MATLAB code files necessary to recreate all the
% figures in the main paper, as well as additional figures in the appendix.

clear; clc;

% [**] removed booleans (rpeg_boolean, nopeg_boolean, PB_hat_boolean) 
% and divindex entirely. In 'Counterfactuals.m' and 'Figures.m', we only 
% keep the default case of rpeg_boolean = false and nopeg_boolean = false [**]

% % BOOLEANS (and counterfactual interest rate peg)
% 
% % rpeg_boolean: Boolean that, if set to "true", computes counterfactuals
% % under the assumption that the interest rate peg was fixed at a particular
% % value before the Federal Reserve-Treasury Accord in 1951. The interest
% % rate peg itself is set under "rpeg" below.
% % rpeg_boolean is set to "false" by default.
% rpeg_boolean = false;
% 
% if rpeg_boolean == true
%     % rpeg: Activated if rpeg_boolean == true. rpeg is the assumed interest 
%     % rate peg before the Federal Reserve-Treasury Accord of 1951.
%     % rpeg can take the values of 0, 1, or 2.
%     % rpeg is set to 2% by default.
%     rpeg = 2;
% end
% 
% % nopeg_boolean: Boolean that, if set to "true", computes counterfactuals
% % under the assumption that there were no interest rate peg before the
% % Federal Reserve-Treasury Accord in 1951.
% % nopeg_boolean is set to "false" by default.
% nopeg_boolean = false;
% 
% % divindex: Year of divergence for which the counterfactual time series
% % begins. For now, the available options are divindex = 5 (corresponding to
% % FY 1946), divindex = 7 (FY 1948), divindex = 11 (FY 1952), 
% % and divindex = 41 (FY 1981).
% % divindex is set to 5 (FY 1946) by default.
% divindex = 5;
% 
% % PB_hat_boolean: Boolean that, if set to "true", sets the counterfactual
% % primary balance time series as equal to the actual primary balance 
% % time series.
% % If set to "false", the counterfactual primary balance time series is set
% % to equal a counterfactual time series based on the CBO's projection of
% % primary balances from 2021 to 2095 (75 fiscal years).
% % PB_hat_boolean is set to "true" by default.
% PB_hat_boolean = true;

%%
% EXECUTION

% 1. Calculate inflation expectations
ExpQ
Exp
fprintf("Computed Inflation Expectations \n");

% 2. Import fiscal debt (and reverse maturity structure) data
FiscalData
fprintf("Imported Fiscal Data \n");

% 3. Compute counterfactuals
Counterfactuals
fprintf("Computed Counterfactuals \n");

% 4. Reproduce graphs in main text and additional graphs
Figures
fprintf("Reproduced Graphs \n");
