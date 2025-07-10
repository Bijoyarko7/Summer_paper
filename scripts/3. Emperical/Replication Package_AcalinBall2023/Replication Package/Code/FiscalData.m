% "Did the U.S. really grow out of its World War II debt?"
% by Julien Acalin and Laurence Ball

% Step 2: Importing Fiscal Data
% by Kyung Woong Koh
% July 17, 2023

%% PART 1: EXTRACTING FISCAL DATA

% Extracting Fiscal Data: MSPD Block (-1960) and CSPR Block (1960-)

% MSPD Block - Total

% Total Outstanding Debt by Year

TOD_MSPD_Data = readtable(strcat('../Data/MSPD/Output/Output_MSPD_ALL.xls'),sheet='Table1');
TOD_MSPD = table2array(TOD_MSPD_Data);
TOD_MSPD = TOD_MSPD(:,1);

% Debt by Issuing and Outstanding Year

% [**] I have changed the code here such that the full MSPD data
% (from 1911 to 1960) would be imported [**]

Debts_MSPD_Data = readtable(strcat('../Data/MSPD/Output/Output_MSPD_ALL.xls'),sheet='Table2');
Debts_MSPD = table2array(Debts_MSPD_Data);
% Debts_MSPD = Debts_MSPD(1:end,1:end);

% startindex = find(Debts_MSPD==startyear);
% Debts_MSPD = Debts_MSPD(startindex:end,2:end);
% Debts_MSPD(isnan(Debts_MSPD)) = 0;

Debts_MSPD = Debts_MSPD(:,2:end);
Debts_MSPD_cols = width(Debts_MSPD);

Debts_MSPD = [Debts_MSPD(1,:); zeros(4,Debts_MSPD_cols); Debts_MSPD(2:3,:); zeros(1,Debts_MSPD_cols); Debts_MSPD(4,:); zeros(3,Debts_MSPD_cols); Debts_MSPD(5,:); zeros(1,Debts_MSPD_cols); Debts_MSPD(6:8,:); zeros(3,Debts_MSPD_cols); Debts_MSPD(9:10,:); zeros(1,Debts_MSPD_cols); Debts_MSPD(11:end,:)];
Debts_MSPD(isnan(Debts_MSPD)) = 0;

Debts_MSPD_rows = height(Debts_MSPD);


% MSPD Block - Marketable Debt

% Total Outstanding Debt by Year

TOD_MSPD_M_Data = readtable('../Data/MSPD/Output/Output_MSPD_MARKETABLE.xls',sheet='Table1');
TOD_MSPD_M = table2array(TOD_MSPD_M_Data);
TOD_MSPD_M = TOD_MSPD_M(:,1);

% Debt by Issuing and Outstanding Year

% [**] I have changed the code here such that the full MSPD data
% (from 1911 to 1960) would be imported [**]

Debts_MSPD_M_Data = readtable('../Data/MSPD/Output/Output_MSPD_MARKETABLE.xls',sheet='Table2');
Debts_MSPD_M = table2array(Debts_MSPD_M_Data);

% [**] Delete these three lines, which remove all pre-1942 data [**]
% startindex = find(Debts_MSPD_M==startyear);
% Debts_MSPD_M = Debts_MSPD_M(startindex:end,2:end);
% Debts_MSPD_M(isnan(Debts_MSPD_M)) = 0;

% [**] Instead, bring code from RMS.m that fills in missing years 
% for all Debts_MSPD_* data [**]
Debts_MSPD_M = Debts_MSPD_M(:,2:end);
Debts_MSPD_M = [Debts_MSPD_M(1,:); zeros(4,Debts_MSPD_cols); Debts_MSPD_M(2:3,:); zeros(1,Debts_MSPD_cols); Debts_MSPD_M(4,:); zeros(3,Debts_MSPD_cols); Debts_MSPD_M(5,:); zeros(1,Debts_MSPD_cols); Debts_MSPD_M(6:8,:); zeros(3,Debts_MSPD_cols); Debts_MSPD_M(9:10,:); zeros(1,Debts_MSPD_cols); Debts_MSPD_M(11:end,:)];
Debts_MSPD_M(isnan(Debts_MSPD_M)) = 0;


% MSPD Block - Nonmarketable Debt

% Total Outstanding Debt by Year

TOD_MSPD_NM_Data = readtable('../Data/MSPD/Output/Output_MSPD_NONMARKETABLE.xls',sheet='Table1');
TOD_MSPD_NM = table2array(TOD_MSPD_NM_Data);
TOD_MSPD_NM = TOD_MSPD_NM(:,1);

% Debt by Issuing and Outstanding Year

% [**] I have changed the code here such that the full MSPD data
% (from 1911 to 1960) would be imported [**]

Debts_MSPD_NM_Data = readtable('../Data/MSPD/Output/Output_MSPD_NONMARKETABLE.xls',sheet='Table2');
Debts_MSPD_NM = table2array(Debts_MSPD_NM_Data);
% Debts_MSPD_NM = Debts_MSPD_NM(1:end,1:end);

% [**] Delete these three lines, which remove all pre-1942 data [**]
% startindex = find(Debts_MSPD_NM==startyear);
% Debts_MSPD_NM = Debts_MSPD_NM(startindex:end,2:end);
% Debts_MSPD_NM(isnan(Debts_MSPD_NM)) = 0;

% [**] Instead, bring code from RMS.m that fills in missing years 
% for all Debts_MSPD_* data [**]
Debts_MSPD_NM = Debts_MSPD_NM(:,2:end);
Debts_MSPD_NM = [zeros(24,Debts_MSPD_cols); Debts_MSPD_NM];
Debts_MSPD_NM(isnan(Debts_MSPD_NM)) = 0;

% CRSP Block - Total

% Total Outstanding Debt (TOD) by Year (Moving TQ data to middle)

TOD_CRSP_Data = readtable('../Data/CRSP/Output/Output_CRSP_ALL.xls',sheet='Table1');
TOD_CRSP_Data = table2array(TOD_CRSP_Data);

% [**] If we are extracting CRSP data starting from 1961 (as the MSPD data
% ends in 1960), we run the following command below:
% TOD_CRSP_Data = TOD_CRSP_Data(2:end,:);
% Otherwise, if extracting CRSP data starting from 1960, we don't run the
% command above

TQbreakindex = find(TOD_CRSP_Data(:,1)==TQbreakyear);

% [**] Simplified code on adjusting TOD_CRSP_Data matrix [**]
TOD_CRSP_Data = TOD_CRSP_Data([1:TQbreakindex, end, TQbreakindex+1:end-1],:);

TOD_CRSP = TOD_CRSP_Data(:,2);

% Debt by Issuing Year and Year End (Moving TQ data to middle)

% [**] Simplified code on adjusting Debts_CRSP_Data matrix [**]
% [**] Changed a few lines (up to line 141) to include 
% pre-1942 outstanding debt in CRSP data [**]

Debts_CRSP_Data = readtable('../Data/CRSP/Output/Output_CRSP_ALL.xls',sheet='Table2TQ');
Debts_CRSP = table2array(Debts_CRSP_Data);

TQbreakindex = find(Debts_CRSP(:,1)==TQbreakyear);
Debts_CRSP = Debts_CRSP([1:TQbreakindex, end, TQbreakindex+1:end-1],:);

% [**] Fixed indexing issue that moved Debts_CRSP column for TQ data 
% before FY 1976 instead of before FY 1977
Debts_CRSP = Debts_CRSP(:,[1:TQbreakyear-DBbreakyear+2, end, TQbreakyear+1-DBbreakyear+2:end-1]);

% [**] Adjusting indices to include CRSP data from 1960 [**]
% Debts_CRSP = Debts_CRSP(:,[1:TQbreakyear-DBbreakyear+1+1, end, TQbreakyear+1-DBbreakyear+1+1:end-1]);

break1index = find(Debts_CRSP(:,1)==break1year);
break2index = find(Debts_CRSP(:,1)==break2year);
Debts_CRSP_1_row = Debts_CRSP(1+2:break1index,:);
Debts_CRSP_2_row = Debts_CRSP(break2index:end,:);
Debts_CRSP = [zeros(1926-firstyear,length(Debts_CRSP(1,:))); Debts_CRSP(1,:);...
    zeros(1939-1926-1,length(Debts_CRSP(1,:))); Debts_CRSP(2,:);...
    zeros(startyear-1939-1,length(Debts_CRSP(1,:))); ...
    Debts_CRSP_1_row; zeros(break2year-break1year-1,length(Debts_CRSP(1,:))); Debts_CRSP_2_row];
Debts_CRSP(break1year-startyear+1+1:break2year-startyear+1-1,1) = [break1year+1:1:break2year-1]';
Debts_CRSP(isnan(Debts_CRSP)) = 0;

% [**] Adjusting indices to include CRSP data from 1960 [**]
% Debts_CRSP = Debts_CRSP(:,3:end);
Debts_CRSP = Debts_CRSP(:,2:end);

% [**] Changed how year vector (1942 - 2022) is generated
year = [1942:1976, 1976.5, 1977:2022]';

clear Debts_CRSP_1_col Debts_CRSP_1_row Debts_CRSP_2_col Debts_CRSP_2_row Debts_CRSP_TQ_col Debts_CRSP_TQ_row TOD_CRSP_1_row TOD_CRSP_2_row TOD_CRSP_TQ_row;

% [**] I delete lines relating to Debts_CRSP_EXCLTIPS [**]

[Debts_CRSP_rows, Debts_CRSP_cols] = size(Debts_CRSP);

% CRSP Block - TIPS

% Total Outstanding Debt (TOD) by Year (Moving TQ data to middle)

TOD_CRSP_TIPS_Data = readtable('../Data/CRSP/Output/Output_CRSP_TIPS.xls',sheet='Table1');
TOD_CRSP_TIPS = table2array(TOD_CRSP_TIPS_Data);

% [**] This may have been a bug that removes CRSP TIPS data for 1997 [**]
% TOD_CRSP_TIPS = TOD_CRSP_TIPS(2:end,2);
% [**] This is fixed in the next line as such: [**]
TOD_CRSP_TIPS = TOD_CRSP_TIPS(:,2);

TOD_CRSP_TIPS = [zeros(length(TOD_CRSP)-length(TOD_CRSP_TIPS),1); TOD_CRSP_TIPS];

Debts_CRSP_TIPS_Data = readtable('../Data/CRSP/Output/Output_CRSP_TIPS.xls',sheet='Table2TQ');
Debts_CRSP_TIPS = table2array(Debts_CRSP_TIPS_Data);
Debts_CRSP_TIPS = Debts_CRSP_TIPS(:,2:end);
Debts_CRSP_TIPS(isnan(Debts_CRSP_TIPS)) = 0;

[Debts_CRSP_TIPS_rows, Debts_CRSP_TIPS_cols] = size(Debts_CRSP_TIPS);
Z4 = zeros(size(Debts_CRSP));
Z4(Debts_CRSP_rows-Debts_CRSP_TIPS_rows+1:end,Debts_CRSP_cols-Debts_CRSP_TIPS_cols+1:end) = Debts_CRSP_TIPS;
Debts_CRSP_TIPS = Z4;

% T-Bills Data
% Tbills_Data(1:end,2) includes Fed holdings
% Tbills_Data(1:end,5) excludes Fed holdings

Tbills_Data = readtable('../Data/Input_Counterfactual.xlsx',sheet='Tbills',VariableNamingRule='preserve');
Tbills_Data = table2array(Tbills_Data);
Tbills = Tbills_Data(1:end,2);
%Tbills = Tbills_Data(1:end,5);
Tbillsall = Tbills_Data(1:end,2);
TIPS_Total = Tbills_Data(1:end,11);
TIPS_Total(isnan(TIPS_Total)) = 0;

%% PART 2: COMPUTING VARIABLES (Equations (3), (A.3), (A.4), (A.5), (A.6))

% Adding T-Bills to diagonal of CRSP data matrix

% [**] I delete lines relating to Debts_CRSP_EXCLTIPS [**]
% [**] Indexing issue of adding up T-bills fixed [**] 

% [**] I replaced Tbills with Tbillsall when adding onto the 
% diagonal elements of Debts_CRSP (starting from the 51st row and 1st column 
% for FY 1960, 52nd row and 2nd column for FY 1961, and so on) [**]


% [**] Now that I comment this out, the Debts_CRSP matrix used to generate
% the weights / reverse maturity structure (w_j_CRSP) for CRSP data should
% not contain Tbills at all [**]

% for i = (1:1:length(year)-(DBbreakyear-startyear+1))
%     Debts_CRSP(DBbreakyear-firstyear+1+i,i) = Debts_CRSP(DBbreakyear-firstyear+1+i,i) + Tbills(DBbreakyear-startyear+1+i,1);
%     TOD_CRSP(i,1) = TOD_CRSP(i,1) + Tbills(DBbreakyear-startyear+1+i,1);
% end


% Equations (3), (A.3): Share of outstanding debt at end of year t-1 which was
% first issued at t-1-j

[Debts_MSPD_rows, Debts_MSPD_cols] = size(Debts_MSPD);
w_j_MSPD = zeros(size(Debts_MSPD));
for i = (1:1:Debts_MSPD_rows)
    for j = (1:1:Debts_MSPD_cols)
        w_j_MSPD(i,j) = Debts_MSPD(i,j) / TOD_MSPD(j,1);
    end
end

% [**] I delete lines relating to Debts_CRSP_EXCLTIPS [**]

% [**] I compute the final weights for marketable debt here [**]

% [**] First, I compute the weights using only CRSP data. The results are 
% in the w_j_CRSPonly matrix [**]

w_j_CRSPonly = zeros(size(Debts_CRSP));
w_j_CRSP = zeros(size(Debts_CRSP));

% [**] This code may be superseded by later code computing w_j_TIPS, which
% generates an identical matrix to w_j_CRSP_TIPS [**]
% w_j_CRSP_TIPS = zeros(size(Debts_CRSP_TIPS));

for i = (1:1:Debts_CRSP_rows)
    for j = (1:1:Debts_CRSP_cols)
        w_j_CRSPonly(i,j) = Debts_CRSP(i,j) / TOD_CRSP(j,1);
        % [**] This code may be superseded by later code computing w_j_TIPS, which
        % generates an identical matrix to w_j_CRSP_TIPS [**]
        % w_j_CRSP_TIPS(i,j) = Debts_CRSP_TIPS(i,j) / TOD_CRSP_TIPS(j,1);
    end
end

% [**] Second, I multiply the weights from the previous step, in the 
% w_j_CRSPonly matrix, by (1-smt) here,
% and add smt back in only for the case where j = 0 (see MATLAB indexing below)
% Note: Previously we did not import data from 'Federal Debt Held by 
% the Public - Marketable' (Column F, Debt sheet, Input_Counterfactual.xlsx) 
% necessary to compute smt. I import that here as Debts_M_Public: [**]

Debt_Data= readtable(strcat('../Data/Input_Counterfactual.xlsx'),sheet='Debt',VariableNamingRule='preserve');
Debt_Data = table2array(Debt_Data);

Debts_M_Public = Debt_Data(1:end,6);

smt = Tbills ./ Debts_M_Public;

% [**] Fixed issue with index of smt to begin adding terms to w_j_CRSP 
% at FY 1960, which means that we have to start adding the weights 
% corresponding to FY 1960 in w_j_CRSPonly (column 1) with the smt value
% corresponding to FY 1960 (smt(DBbreakyear-startyear+1) = smt(19)), 
% and so on [**]

for i = (1:1:Debts_CRSP_rows)
    for j = (1:1:Debts_CRSP_cols)
        if i == j + (DBbreakyear-firstyear)
            % [**] in the case where, in the paper's notation, j = 0 [**]
            w_j_CRSP(i,j) = w_j_CRSPonly(i,j) * (1-smt(DBbreakyear-startyear+j,1)) + smt(DBbreakyear-startyear+j,1);
        elseif i < j + (DBbreakyear-firstyear)
            % [**] in the case where, in the paper's notation, j > 0 [**]
            w_j_CRSP(i,j) = w_j_CRSPonly(i,j) * (1-smt(DBbreakyear-startyear+j,1));
        end
    end
end



% Equation (A.4): Marketable and Non-marketable shares

[Debts_MSPD_M_rows, Debts_MSPD_M_cols] = size(Debts_MSPD_M);
w_j_MSPD_M = zeros(size(Debts_MSPD_M));
w_j_MSPD_NM = zeros(size(Debts_MSPD_NM));
for i = (1:1:Debts_MSPD_M_rows)
    for j = (1:1:Debts_MSPD_M_cols)
        w_j_MSPD_M(i,j) = Debts_MSPD_M(i,j) / TOD_MSPD_M(j,1);
        w_j_MSPD_NM(i,j) = Debts_MSPD_NM(i,j) / TOD_MSPD_NM(j,1);
    end
end

% Equation (A.5): Post-1960, non-marketable debt weights by issuing year are the same as in 1960

% [**] Indexing here is updated to accommodate for the fact that Debts_CRSP now
% includes data from FY 1960 as well, and is right now a 113 x 64 matrix [**]

w_j_CRSP_NM = zeros(size(Debts_CRSP));
for i = (1:1:Debts_CRSP_cols)
    w_j_CRSP_NM(i:i+Debts_MSPD_rows-1,i) = w_j_MSPD_NM(:,end);
end


% Combining MSPD and CRSP matrices

% [**] I have changed the code here that computes the full 113 x 82 matrix
% (from 1911 to 2022, from 1942 to 2022) [**]

% [**] This is now adjusted to accommodate for the fact that Debts_CRSP now
% includes data from FY 1960 as well, and is right now a 113 x 64 matrix.
% The fixes below allow MSPD data up to 1960 to be combined with CRSP data
% starting from 1961 [**]

Z1 = zeros(Debts_CRSP_cols-1, Debts_MSPD_cols);
Z2 = zeros(Debts_CRSP_rows, Debts_CRSP_rows-Debts_CRSP_cols-1);
Z3 = zeros((Debts_CRSP_rows - Debts_MSPD_cols),Debts_CRSP_cols-1);

w_j_M = [w_j_MSPD_M; Z1];
w_j_M = [w_j_M w_j_CRSP(:,2:end)];

% Nonmarketable Debt: w_j_MSPD_NM and w_j_CRSP_NM
w_j_NM = [w_j_MSPD_NM; Z1];
w_j_NM = [w_j_NM w_j_CRSP_NM(:,2:end)];


% [**] Moved code on weight of TIPS shares to here [**]
% Compute the weight of TIPS shares outstanding at end of year t-1
% first issued at t-1-j
% Again, use data from CRSP_TIPS file
w_j_TIPS = zeros(size(Debts_CRSP));
for i = (Debts_CRSP_rows-year(end)+TIPSbreakyear:1:Debts_CRSP_rows)
    for j = (Debts_CRSP_cols-year(end)+TIPSbreakyear:1:Debts_CRSP_cols)
        w_j_TIPS(i,j) = Debts_CRSP_TIPS(i,j) / sum(Debts_CRSP_TIPS(:,j));
    end
end
w_j_TIPS(isnan(w_j_TIPS)) = 0;
% [**] Edited line below for w_j_TIPS to fit into size of w_j (113 x 82 matrix) [**]
w_j_TIPS = [zeros(Debts_CRSP_rows,Debts_MSPD_cols-1) w_j_TIPS];

% [**] This code may be superseded by later code computing w_j_TIPS, which
% generates an identical matrix to w_j_CRSP_TIPS [**]
% clear w_j_CRSP_TIPS



% Computing the share of outstanding marketable debt within 
% total outstanding debt

% [**] I import the same 'Debt' sheet from 'Inputs_Counterfactual.xlsx'
% twice, so I consolidate that into one extraction [**]
m = Debt_Data(1:end,10);

% Equation (A.6):  Computing the share of outstanding debt at FY t-1 first
% issued in FY t-1-j
% [**] Changed indexing here so that we generate the w_j (113 x 82) matrix 
% using the full 1911-2022 data [**]
w_j = zeros(size(endyear-firstyear+2,endyear-startyear+2));
w = zeros(endyear-firstyear+2,1);

for i = (1:1:endyear-firstyear+2)
    for j = (1:1:endyear-startyear+2)
        w_j(i,j) = w_j_M(i,j) * m(j,1) + w_j_NM(i,j) * (1-m(j,1));
    end
    w(i,1) = sum(w_j(i,:));
end

% [**] Duplicate large (113x82 for data from 1911 to 2022) weights tables,
% then extract just data from 1942 to 2022
w_start = w;
w_j_start = w_j;
w_j_M_start = w_j_M;
w_j_NM_start = w_j_NM;
% [**] Extract just data from 1942 to 2022 for w_j_TIPS array as well [**]
w_j_TIPS_start = w_j_TIPS;

w = w_start(startyear-firstyear+1:end,:);
w_j = w_j_start(startyear-firstyear+1:end,:);
w_j_M = w_j_M_start(startyear-firstyear+1:end,:);
w_j_NM = w_j_NM_start(startyear-firstyear+1:end,:);
% [**] Extract just data from 1942 to 2022 for w_j_TIPS array as well [**]
w_j_TIPS = w_j_TIPS_start(startyear-firstyear+1:end,:);

% [**] I switch the order of getting the data for RMS (PART 3) and 



%% PART 3: DATA FOR RMS GRAPHS (Figures 4, A.2, and A.3)

% [**] This entire section is adapted from the code in RMS.m 
% to generate data for the RMS figures [**]

% [**] I have switched the order such that the data for Figure 4 
% gets generated first over Figures A.2 and A.3 [**]

% Reverse Maturity Structure for Total Debt
% This section uses data from 1911 to 2022 (hence, the larger matrix
% size) to compute weights of marketable/non-marketable debt in total 
% outstanding debt

% [**] w_RMS_total_5 has been renamed to RMS, both in this file and in Figures_Koh.m [**]
RMS = zeros(length(year),5);

% Figure 4: Compute weights for reverse maturity structure of total debt 
% into five categories: less than 1 year, 1 year, 2 to 5 years, 
% 6 to 10 years, and more than 10 years

for i = (1:1:length(year))
    RMS(i,1) = w_j_start(i+31,i);
    RMS(i,2) = w_j_start(i+31-1,i);
    RMS(i,3) = sum(w_j_start(i+31-5:i+31-2,i));
    RMS(i,4) = sum(w_j_start(i+31-10:i+31-6,i));
    RMS(i,5) = sum(w_j_start(1:i+31-11,i));
end

% Figure A.2: Compute weights for reverse maturity structure of all marketable debt 
% into five categories: less than 1 year, 1 year, 2 to 5 years, 
% 6 to 10 years, and more than 10 years

RMS_M = zeros(length(year),5);

for i = (1:1:length(year))
    RMS_M(i,1) = w_j_M_start(i+31,i);
    RMS_M(i,2) = w_j_M_start(i+31-1,i);
    RMS_M(i,3) = sum(w_j_M_start(i+31-5:i+31-2,i));
    RMS_M(i,4) = sum(w_j_M_start(i+31-10:i+31-6,i));
    RMS_M(i,5) = sum(w_j_M_start(1:i+31-11,i));
end

% Figure A.3: Compute weights for reverse maturity structure of all non-marketable debt 
% into five categories: less than 1 year, 1 year, 2 to 5 years, 
% 6 to 10 years, and more than 10 years

RMS_NM = zeros(DBbreakyear-startyear+1,5);

for i = (1:1:DBbreakyear-startyear+1)
    RMS_NM(i,1) = w_j_NM_start(i+31,i);
    RMS_NM(i,2) = w_j_NM_start(i+31-1,i);
    RMS_NM(i,3) = sum(w_j_NM_start(i+31-5:i+31-2,i));
    RMS_NM(i,4) = sum(w_j_NM_start(i+31-10:i+31-6,i));
    RMS_NM(i,5) = sum(w_j_NM_start(1:i+31-11,i));
end


%% PART 4: OTHER FISCAL VARIABLES  (Equation (A.7), (A.8), 

% Equation (A.7): Compute the share of T-bills within diagonal elements for 
% all years
% divide bills_t-1 by D^0_{t-1} according to the OMB
% [**] Fixed indexing issue [**]
TOD_OMB = Debt_Data(1:end,2);
s = zeros(length(year),1);
for i = (1:1:length(year))
    s(i,1) = Tbills(i,1) / (TOD_OMB(i,1) * w_j(i,i));
end

% Equation (A.8): Compute the TIPS as share of total outstanding debt (z)
% [**] Fixed indexing issue [**]
z = zeros(length(year),1);
for i = (1:1:length(year))
    z(i,1) = TIPS_Total(i,1) / TOD_OMB(i,1);
end

% [**] Moved code on weight of TIPS shares to here from what is now Part 4 [**]

% Import r^{*,j+1}_t, denoted here rtilde^j+1 
% obtained from GFD data and own term structure for inflation expectations
% (see section 4.4)

rtilde_j_MSPD_Data = readtable(strcat('../Data/MSPD/Output/Output_GFD_PEG.xls'),sheet='ExAnteRealRatePeg');
rtilde_j_MSPD = table2array(rtilde_j_MSPD_Data);

startindex = find(rtilde_j_MSPD==startyear);
rtilde_j_MSPD = rtilde_j_MSPD(startindex:end,2:end);
rtilde_j_MSPD(isnan(rtilde_j_MSPD)) = 0;

% Import actual interest rates i^j+1 from MSPD 

i_j_MSPD_Data = readtable(strcat('../Data/MSPD/Output/Output_MSPD_ALL.xls'),sheet='Table7');
i_j_MSPD = table2array(i_j_MSPD_Data);

startindex = find(i_j_MSPD==startyear);
i_j_MSPD = i_j_MSPD(startindex:end,2:end);
i_j_MSPD(isnan(i_j_MSPD)) = 0;

i_j_MSPD_M_Data = readtable(strcat('../Data/MSPD/Output/Output_MSPD_MARKETABLE.xls'),sheet='Table7');
i_j_MSPD_M = table2array(i_j_MSPD_M_Data);

startindex = find(i_j_MSPD_M==startyear);
i_j_MSPD_M = i_j_MSPD_M(startindex:end,2:end);
i_j_MSPD_M(isnan(i_j_MSPD_M)) = 0;

i_j_MSPD_NM_Data = readtable(strcat('../Data/MSPD/Output/Output_MSPD_NONMARKETABLE.xls'),sheet='Table7');
i_j_MSPD_NM = table2array(i_j_MSPD_NM_Data);

startindex = find(i_j_MSPD_NM==startyear);
i_j_MSPD_NM = i_j_MSPD_NM(startindex:end,2:end);
i_j_MSPD_NM(isnan(i_j_MSPD_NM)) = 0;


% Interest rates by Issuing Year and Year End (Moving TQ data to middle)
% Note: We use FY 1976 interests in the TQ as well

i_j_CRSP_Data = readtable('../Data/CRSP/Output/Output_CRSP_ALL.xls',sheet='Table7');
i_j_CRSP = table2array(i_j_CRSP_Data);
startindex = find(i_j_CRSP==startyear);
i_j_CRSP = i_j_CRSP(startindex:end,1:end);

% [**] Simplified code on rearranging TQ row and column in i_j_CRSP [**]
TQbreakindex = find(i_j_CRSP(:,1)==TQbreakyear);
i_j_CRSP = i_j_CRSP([1:TQbreakindex, end, TQbreakindex+1:end-1],:);
i_j_CRSP = i_j_CRSP(:,[1:TQbreakyear-DBbreakyear+1+1, end, TQbreakyear+1-DBbreakyear+1+1:end-1]);

break1index = find(i_j_CRSP(:,1)==break1year);
break2index = find(i_j_CRSP(:,1)==break2year);
i_j_CRSP_1_row = i_j_CRSP(1:break1index,:);
i_j_CRSP_2_row = i_j_CRSP(break2index:end,:);
i_j_CRSP = [i_j_CRSP_1_row; zeros(break2year-break1year-1,length(i_j_CRSP(1,:))); i_j_CRSP_2_row];
i_j_CRSP(break1year-startyear+1+1:break2year-startyear+1-1,1) = [break1year+1:1:break2year-1]';
i_j_CRSP(isnan(i_j_CRSP)) = 0;
year = i_j_CRSP(:,1);
year(year==9999) = 1976.5;
i_j_CRSP = i_j_CRSP(:,3:end);

clear i_j_CRSP_1_col i_j_CRSP_1_row i_j_CRSP_2_col i_j_CRSP_2_row i_j_CRSP_cols i_j_CRSP_rows i_j_CRSP_TQ_col i_j_CRSP_TQ_row TOD_CRSP_1_row TOD_CRSP_2_row TOD_CRSP_TQ_row;

% Import interest rates from MSPD dataset (i_j_MSPD) and CRSP dataset
% (i_j_CRSP)
i_j = [i_j_MSPD; Z1];
i_j = [i_j i_j_CRSP];


% Import real rates
rtilde_j = zeros(length(year));
[rtilde_j_MSPD_rows, rtilde_j_MSPD_cols] = size(rtilde_j_MSPD);
rtilde_j(1:rtilde_j_MSPD_rows, 1:rtilde_j_MSPD_cols) = rtilde_j_MSPD;

for i = rtilde_j_MSPD_cols+1:1:length(year)
    rtilde_j(:,i) = rtilde_j(:,rtilde_j_MSPD_cols);
end


% Import inflation expectations data resulting from "Exp.m" file
load('../Results/Exp.mat');

% Import actual debt data

% [**] I import the same 'Debt' sheet from 'Inputs_Counterfactual.xlsx'
% twice, so I consolidate that into one extraction [**]

% D_actual_Data= readtable(strcat('../Data/Input_Counterfactual.xlsx'),sheet='Debt',VariableNamingRule='preserve');
% D_actual_Data = table2array(D_actual_Data);
D_actual = Debt_Data(1:end,2);
DYratio_actual_OMB = Debt_Data(1:end,3);

% Import actual aggregate interest rate data
i_actual_Data= readtable(strcat('../Data/Input_Counterfactual.xlsx'),sheet='i',VariableNamingRule='preserve');
i_actual = table2array(i_actual_Data);
i_actual = i_actual(1:end,2);

% Import actual primary balance data
PB_actual_Data= readtable(strcat('../Data/Input_Counterfactual.xlsx'),sheet='PB',VariableNamingRule='preserve');
PB_actual_Data = table2array(PB_actual_Data);
PB_actual = PB_actual_Data(1:end,2);
PBYratio_actual = PB_actual_Data(1:end,3);
PB_actual_interest = PB_actual_Data(1:end,4);

% Import actual GDP data
GDP_actual_Data= readtable(strcat('../Data/Input_Counterfactual.xlsx'),sheet='GDP',VariableNamingRule='preserve');
GDP_actual = table2array(GDP_actual_Data);
GDP_actual = GDP_actual(1:end,2);

% Import residual \epsilon
OMF_actual_Data= readtable(strcat('../Data/Input_Counterfactual.xlsx'),sheet='OMF',VariableNamingRule='preserve');
residual = table2array(OMF_actual_Data);
residual = residual(1:end,2);

% Figure A.11: Import data from Blanchard (2019)
Data_Blanchard = readtable('../Data/Input_Counterfactual.xlsx',sheet="Blanchard",VariableNamingRule='preserve');
Data_Blanchard = table2array(Data_Blanchard);


save('../Results/FiscalData.mat');

cd ../Code