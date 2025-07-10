% "Did the U.S. really grow out of its World War II debt?"
% by Julien Acalin and Laurence Ball

% Step 1a: Code for Calculating Inflation Expectations using the 
% Quarterly Implementation for Fiscal Years 1972 to 1976
% by Kyung Woong Koh
% June 12, 2023

% Computing path of inflation expectations using quarterly procedure for
% Fiscal Years 1972-1976
% See Appendix A.3 for full details on computation

% Importing Quarterly GDP Price Deflator Inflation Expectations Data (SPF)
Data = readtable('../Data/Inflation.xlsx',sheet="data_quarterly2");
InflationQ = table2array(Data);
InflationQ = InflationQ(4:end,:);

time = InflationQ(:,1);
year = InflationQ(:,2);
quarter = InflationQ(:,3);
pgdp = InflationQ(:,4);
pgdp_bp = InflationQ(:,5);
pgdp_1q = InflationQ(:,6);
pgdp_2q = InflationQ(:,7);
pgdp_3q = InflationQ(:,8);
pgdp_4q = InflationQ(:,9);
pi_exp_long_gdp = InflationQ(:,10);

% Computing GDP deflator inflation rate \pi^{GDP}
pi_gdp = zeros(length(time),1);
for j = (5:1:length(time))
        pi_gdp(j) = (pgdp(j,1) / pgdp(j-4,1) - 1) * 100;
end

% Computing 1-quarter to 4-quarter ahead quarterly annualized inflation expectations
% i.e. Compute E_{\tau}[\pi_{\tau + j}] for j = 1, ..., 4 (quarters)
pi_exp_gdp_q = zeros(length(time),4);
for j = (5:1:length(time))    
    pi_exp_gdp_q(j,1) = ( (pgdp_1q(j,1) / pgdp_bp(j,1))^(4) - 1) * 100;
    pi_exp_gdp_q(j,2) = ( (pgdp_2q(j,1) / pgdp_1q(j,1))^(4) - 1) * 100;
    pi_exp_gdp_q(j,3) = ( (pgdp_3q(j,1) / pgdp_2q(j,1))^(4) - 1) * 100;
    pi_exp_gdp_q(j,4) = ( (pgdp_4q(j,1) / pgdp_3q(j,1))^(4) - 1) * 100;    
end

% Computing quarterly annualized increment (k_{\tau} in Appendix A.3)
% Note: pi_exp_long_gdp is annualized long-term inflation expectation
% from FRB/US Model
% Equation (A.16)
pi_incr_q = zeros(length(time),1);
for j = (5:1:length(time))
    pi_incr_q(j,1) = (1/456) * (40 * pi_exp_long_gdp(j,1) - pi_exp_gdp_q(j,1) - pi_exp_gdp_q(j,2) - pi_exp_gdp_q(j,3) - 37 * pi_exp_gdp_q(j,4));
end

% Computing 10-year paths of inflation expectations for each of Fiscal
% Years 1972-1976
% Equations (A.13) (A.14)
pi_exp1 = zeros(length(time),40);

for j = (1:1:41)
    for q = (5:1:length(time))
        if j <= 4
            %Use SPF data for first 4 quarters
            pi_exp1(q,j) = pi_exp_gdp_q(q,j);
        elseif ((j >= 5) & (j <= 20)) == 1
            %Use linear increment up to 20 quarters ahead (A.13)
            pi_exp1(q,j) = pi_exp_gdp_q(q,4) + (j-4)*pi_incr_q(q,1);
        else
            %Stay constant after 20 quarters (A.14)
            pi_exp1(q,j) = pi_exp1(q,20);
        end
    end
end

% Matrix Inflation expectation made in a given quarter for 
% inflation in a given quarter
pi_exp1_graph = NaN(59,19);
pi_exp1_graph(1,2:end) = [1972:0.25:1976.25];
pi_exp1_graph(2:end,1) = [[1972.25:0.25:1976.25] [1976.5] [1976.75:0.25:1986.5]]';
for j = (1:1:18)
    pi_exp1_graph(j+1:j+41,j+1) = pi_exp1(j+4,1:41)';
end

% Equations (A.17, A.18): Computing expectation in FY for cumulated
% inflation across 4 quarters of FY
% t is the number of quarters since 1971Q4 inclusive (at which the expectation is
% made). ex) t=3: 1972Q2, t=19: 1976Q2
% For FYs 1972 to 1976, inflation expectations are made only at the 2nd
% calendar quarter (i.e. end of FY)

%Equation (A.17)
pi_exp1_a = zeros(5,10);

for t = 3:4:19
    % i is the number of quarters since 1972Q1 (for inflation in quarter i).
    % i takes the values from t to t+39, or up to 40 quarters since t
    for i = t:t+40
        % expectations for inflation at Transitional Quarter (1976Q3)
        if i == 19
            pi_exp1_a((t+1)/4,(i-t+4)/4) = pi_exp1_graph(i,t);
        % expectations for inflation in FYs that end in Q2 (i.e. up to FY 1976)
        elseif i<19 && mod(i,4)==2
            pi_exp1_a((t+1)/4,(i-t+1)/4) = (((1+pi_exp1_graph(i,t)/100) * (1+pi_exp1_graph(i-1,t)/100) * (1+pi_exp1_graph(i-2,t)/100) * (1+pi_exp1_graph(i-3,t)/100))^(1/4) - 1) * 100;
        % expectations for inflation in FYs that end in Q3 (i.e. starting from FY 1977)
        elseif i>19 && mod(i,4)==3
            pi_exp1_a((t+1)/4,(i-t+4)/4) = (((1+pi_exp1_graph(i,t)/100) * (1+pi_exp1_graph(i-1,t)/100) * (1+pi_exp1_graph(i-2,t)/100) * (1+pi_exp1_graph(i-3,t)/100))^(1/4) - 1) * 100;
        end
    end
end

% Matrix Inflation expectation made in a given FY for 
% inflation in a given FY
pi_exp1_a_graph = NaN(15,6);
pi_exp1_a_graph(1,2:end) = [1972:1:1976];
pi_exp1_a_graph(2:end,1) = [[1973:1:1976] [1976.5] [1977:1:1985]]';
for j = (1:1:5)
    pi_exp1_a_graph(j+1:j+10,j+1) = pi_exp1_a(j,1:10)';
end

save ('../Results/ExpQ.mat');

cd ../Code