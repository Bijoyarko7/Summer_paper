% "Did the U.S. really grow out of its World War II debt?"
% by Julien Acalin and Laurence Ball

% Step 1b: Code for Computing Entire Inflation Expectations
% by Kyung Woong Koh
% June 12, 2023

% See Appendix A.3 for full details on computation of inflation
% expectations

load ('../Results/ExpQ.mat');

% KEY FISCAL YEARS FOR COMPUTATIONS

% firstyear: FY 1911, when our earliest fiscal debt data begins
firstyear = 1911;
% startyear: FY 1942, the year where the counterfactual analysis begins
startyear = 1942;
% expyear: FY 1951, when the Federal Reserve-Treasury Accord was signed and
% therefore the interest rate peg ends
expyear = 1951;
% break1year: FY 1946, for counterfactual analysis where the point of
% divergence is in 1946
break1year = 1946;
% break1year: FY 1953, for counterfactual analysis where the point of
% divergence is in 1953
break2year = 1953;
% DBbreakyear: FY 1960, when the fiscal debt data from MSPD ends and the data
% from CRSP begins
DBbreakyear = 1960;
% TQbreakyear: FY 1976, to indicate the Transition Quarter (TQ) between FY
% 1976 and FY 1977
TQbreakyear = 1976;
% TIPSbreakyear: FY 1997, from which data on TIPS bonds begin
TIPSbreakyear = 1997;
% endyear: Latest fiscal year. For now, analysis ends at FY 2022
endyear = 2022;

% Import Data on Inflation and Inflation Expectations
cd ../Data/
InflData = readtable('Inflation.xlsx',sheet="data");
Inflation = table2array(InflData);
Inflation = Inflation(1:end,1:end);

year = Inflation(:,1);
pi_gdp_original = Inflation(:,2);
pi_gnp = Inflation(:,3);
pi_gdp = zeros(length(year),1);
pi_gdp(1:6,1) = pi_gnp(1:6,1);
pi_gdp(7:end,1) = pi_gdp_original(7:end,1);
pi_cpi = Inflation(:,4);
pi_exp_short_gdp = Inflation(:,5);
pi_exp_short_cpi = Inflation(:,6);
pi_exp_long_gdp = Inflation(:,7); %valid only from 1968 onwards Figure A.8

% we can get rid of pi_gnp_FRED 
pi_gnp_FRED = Inflation(:,8);   % not used anymore; can delete
pi_exp_short_pce = Inflation(:,9);   %comes from own procedure Table A.1, Figure A.7
pi_exp_short_hp = Inflation(:,10); %comes from own procedure Table A.1, Figure A.8
pi_exp_long_predict = Inflation(:,11); %comes from own procedure Table A.1, Figure A.9
exp_long = Inflation(:,12); %comes from own procedure Table A.1, Figure 3, Figure 5

% Creating Short-Term Expectations Vector
% Nth element of this vector is the Nth fiscal year since the beginning of
% the sample (FY 1942)
% (FY: N + 1942 - 1)
% So, each value for fiscal year FY is E_{FY-1}[\pi_{FY}]

%One-Year GDP deflator inflation expectation
%comes from own procedure (see Figure A.6) before 1970, SPF data from 1970
pi_exp_short = zeros(length(year),1);
for t = (1:1:length(year))
    fy = t + startyear - 1;
    if ((fy >= 1947) & (fy <= 1969)) == 1 %GDP deflator forecast error same as CPI error 
        pi_exp_short(t,1) = pi_gdp(t+1,1) + (pi_exp_short_cpi(t,1) - pi_cpi(t+1,1));
    elseif fy >= 1970 %SPF data
        pi_exp_short(t,1) = pi_exp_short_gdp(t,1);
    end
end

% Equation (A.12): Computing increment k_t for annual inflation
% expectations

pi_exp2 = zeros(length(year),10);
pi_incr = (exp_long - pi_exp_short)/3; %Equation (A.12)

% Equation (A.9, A.10): Computing 10-year paths of inflation expectations 
% for each year, starting from expyear (1951) to the endyear (2022)

for j = (1:1:10)
    if j < 5
        pi_exp2(:,j) = pi_exp_short + (j-1)*pi_incr;
    else
        pi_exp2(:,j) = pi_exp_short + 4*pi_incr;
    end
end

% Overwriting inflation expectations using the quarterly procedure for FY
% 1972 to 1976 (see code in "ExpQ.m") to account for the Transition Quarter

% Recreating larger table of inflation expectations from "pi_exp1" matrix
% Row t-j: Inflation expectation (forecast) made at year t-j
% Column t: Inflation expectation of year t

pi_exp = zeros(length(year),length(year)+10);
pi_exp_graph = zeros(length(year),length(year)+10);

for t = (1:1:length(year))
    if t >= expyear-startyear+1
        pi_exp(t,t+1:t+10) = pi_exp2(t,1:10);
        pi_exp(t,t+11:end) = pi_exp(t,t+10);
        pi_exp_graph(t,t+1:t+10) = pi_exp2(t,1:10);
    end
end

% Replace inflation expectation paths from quarterly procedure 
% for Fiscal Years 1972 to 1976 over graph of expectations

pi_exp_7276_graph = pi_exp1_a_graph(2:end,2:end);
pi_exp_graph = pi_exp_graph(1:length(year),1:length(year));
pi_exp_graph = pi_exp_graph';
pi_exp_graph(pi_exp_graph == 0) = NaN;

pi_exp_graph_Q = pi_exp_graph;
pi_exp_graph_Q(32:45, 31:35) = pi_exp_7276_graph;

pi_exp_Q = pi_exp;
pi_exp_Q(1971-startyear+2:1975-startyear+2, 1972-startyear+2:1985-startyear+2) = pi_exp_7276_graph';
pi_exp_Q(isnan(pi_exp_Q)) = 0;

% Adjusting to obtain non-annualized expected inflation rate for TQ
pi_exp_Q(:,TQbreakyear-startyear+2) = ((1 + pi_exp_Q(:,TQbreakyear-startyear+2)/100).^(1/4) - 1) * 100;

% Extending inflation expectations
for t = (1971-startyear+2:1:1975-startyear+2)
    for j = (8:1:endyear-startyear+10-t)
        pi_exp_Q(t,t+j) = pi_exp_Q(t,t+7);
    end
end

% Up until here, inflation expectations matrix (pi_exp_Q) is for 
% rows t-j from 1942 to 2021
% columns t from 1942 to 2031
% In other words, a (2022-1942+2) x (2032-1942+2) = 82 x 92 matrix
% Truncate that matrix to 82 x 82 matrix, with t-j and t from 1942 to 2022

pi_exp_Q_path = pi_exp_Q(1:length(year),1:length(year));

% Actual inflation time series into square matrix

pi_actual = zeros(length(year));
pi_actual_graph = zeros(length(year),length(year)+10);

for t = (1:1:length(year))
    if t >= expyear-startyear+1
        for j = (t:1:length(year)-1)
            pi_actual(t,j+1) = pi_gdp(j+1,1);
            if (j >= t) && (j <= t+9)
                pi_actual_graph(t,j+1) = pi_actual(t,j+1);
            end
        end
    end
end

pi_actual_graph = pi_actual_graph(1:length(year),1:length(year));
pi_actual_graph = pi_actual_graph';

% Equation (6) for t-1-j \geq 1952 
% Arrays for listing the path of inflation expectation forecast errors at
% each Fiscal Year
pi_error_Q = pi_actual - pi_exp_Q_path;
pi_error_graph_Q = pi_actual_graph - pi_exp_graph_Q;
pi_error_graph_Q(pi_error_graph_Q == 0) = NaN;

year(isnan(year)) = 1976.5;

save ('../Results/Exp.mat');

cd ../Code