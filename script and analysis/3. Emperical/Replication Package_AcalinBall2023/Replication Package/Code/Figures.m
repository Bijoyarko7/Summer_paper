% "Did the U.S. really grow its way out of its WWII debt?"
% by Julien Acalin and Laurence Ball

% Step 4: Code for Reproducing Graphs in Main Text and Appendix
% by Kyung Woong Koh
% June 15, 2023

% [**] I have revised the order of charts in Appendix and have added 
% Figure A11 to Results in Excel file


load('../Results/Counterfactuals.mat');

colororder('default');
set(gcf,'Position',[100 100 900 540])
set(groot,'defaultLineLineWidth',2.0)

% Color order for RMS graphs
RMScolors = [0.5 0.5 0.5; 0.6 0.6 0.6; 0.7 0.7 0.7; 0.8 0.8 0.8; 0.9 0.9 0.9];

year_noTQ = [year(1:TQbreakyear-startyear+1); year(TQbreakyear-startyear+3:end)];
    
% Figure 1: Federal Debt Held by the Public as a Percent of GDP
% [**] Generally simplified code on generating data used in each figure.
% See line below for example of Fig1_data [**]
Fig1_data = DYratio_actual_OMB([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end]);
plot(year_noTQ, Fig1_data);
%legend('Federal Debt Held by the Public (%GDP)','Location','Southoutside')
xlim([startyear endyear])
ylim([0 120])
colororder('default')
saveas(gcf,'../Figures/Figure1.png');

% Figure 2: Primary Balance as a Percent of GDP
pbYratio_actual = 100*rdivide(PB_actual,GDP_actual);
Fig2_data = pbYratio_actual([1:TQbreakyear-startyear+5+1,TQbreakyear-startyear+5+3:end]);
plot(year_noTQ, Fig2_data);
yline(0,'-k');
%legend('Primary Surplus(%GDP)','Location','Southoutside')
xlim([startyear+5 endyear])
ylim([-15 10])
colororder('default')
saveas(gcf,'../Figures/Figure2.png');

% Figure 3: Actual and Expected Inflation Expectations
pi_gdp_original_noTQ = [pi_gdp_original(1:TQbreakyear-startyear+1); pi_gdp_original(TQbreakyear-startyear+3:end)];
pi_exp_short_graph_noTQ = [pi_exp_short(1:TQbreakyear-startyear+1); pi_exp_short(TQbreakyear-startyear+3:end)];
exp_long_noTQ = [exp_long(1:TQbreakyear-startyear+1); exp_long(TQbreakyear-startyear+3:end)];
pi_exp_10y_graph_noTQ = [pi_exp_Q(1:TQbreakyear-startyear+1,end); pi_exp_Q(TQbreakyear-startyear+3:end,end)];

pi_exp_short_graph_noTQ(pi_exp_short_graph_noTQ == 0) = nan;
pi_exp_10y_graph_noTQ(pi_exp_10y_graph_noTQ == 0) = nan;

pi_exp_short_graph_noTQ2 = [pi_exp_short_graph_noTQ(2:end); nan(1,1)];
pi_exp_10y_graph_noTQ2 = [pi_exp_10y_graph_noTQ(11:end); nan(10,1)];

pi_exp_short_graph_noTQ2_alt = [nan(1,1); pi_exp_short_graph_noTQ(1:end-1)];
pi_exp_10y_graph_noTQ2_alt = [nan(10,1); pi_exp_10y_graph_noTQ(1:end-10)];

pi_gdp_original_noTQ3 = pi_gdp_original_noTQ(1951-startyear+1:end,1);

year_noTQ3 = year_noTQ(1951-startyear+1:end,1);
pi_exp_short_graph_noTQ3_alt = pi_exp_short_graph_noTQ2_alt(1951-startyear+1:end,1);
pi_exp_10y_graph_noTQ3_alt = pi_exp_10y_graph_noTQ2_alt(1951-startyear+1:end,1);

clear pi_exp_short_graph_noTQ2 pi_exp_10y_graph_noTQ2 ...
    pi_exp_short_graph_noTQ2_alt pi_exp_10y_graph_noTQ2_alt;

Fig3_data = [pi_gdp_original_noTQ3 pi_exp_short_graph_noTQ3_alt pi_exp_10y_graph_noTQ3_alt];
plot(year_noTQ3(2:end), Fig3_data(2:end,1), "-")
hold on
plot(year_noTQ3(2:end), Fig3_data(2:end,2), ":")
plot(year_noTQ3(2:end), Fig3_data(2:end,3), ":")
hold off
xlim([expyear endyear])
lgd = legend('\pi_t: GDP Deflator Inflation Rate', 'E_{t-1}[\pi_t]: Inflation Expected 1-Year Ago', 'E_{t-10}[\pi_t]: Inflation Expected 10-Years Ago','Location','Southoutside');
fontsize(lgd,12,'points')
colororder('default')
saveas(gcf,'../Figures/Figure3.png');

% Figure 4: Reverse Maturity Structure of Public Debt
% [**] The variable has been renamed RMS here [**]
Fig4_data = RMS([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
area(year_noTQ, Fig4_data);
xlim([startyear endyear])
ylim([0,1])
legend('0','1','[2;5]','[6;10]','>10','Location','southoutside','Orientation','horizontal')
colororder(RMScolors)
saveas(gcf,'../Figures/Figure4.png');

% Figure 5: Short-Term and Long-Term Inflation Expectations Time Series
Fig5_data = [pi_exp_short exp_long];
Fig5_data = Fig5_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
plot(year_noTQ, Fig5_data)
lgd = legend('E_{t}[\pi_{t+1}]: Expected inflation over the next year', 'E_{t}[\pi^{10}]: Expected inflation over the next ten years','Location','Southoutside');
fontsize(lgd,12,'points')
xlim([expyear-1 endyear])
colororder('default')
saveas(gcf,'../Figures/Figure5.png');

% Figure 6: Term Structure of Inflation Expectations
Fig6_data = pi_exp_graph_Q(:,[10:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end]);
Fig6_data = Fig6_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
plot(year_noTQ, Fig6_data)
xlim([expyear endyear])
colororder('default')
saveas(gcf,'../Figures/Figure6.png');

% Figure 7: Debt over GDP Paths - Counterfactual Scenarios

% [**] Remove code concerning booleans here as we don't use them anymore [**]
% if (rpeg_boolean == false) && (nopeg_boolean == false)
    Fig7_data = [DYratio_actual_OMB DYratio_hat_ZeroPB DYratio_hat_NDRR DYratio_hat_NDRR_ZeroPB];
    Fig7_data = Fig7_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
    plot(year_noTQ, Fig7_data(:,2),":");
    hold on
    plot(year_noTQ, Fig7_data(:,3),"--");
    plot(year_noTQ, Fig7_data(:,4),"-");
    plot(year_noTQ, Fig7_data(:,1),"-");
    hold off
    lgd = legend('Counterfactual: Primary balance scenario', 'Counterfactual: Adjusted interest rate scenario', 'Counterfactual: Combined scenario', 'Actual history', 'Location','Southoutside');
    fontsize(lgd,12,'points')
    xlim([startyear endyear])
    ylim([0 140])
    colororder(	[0.9290, 0.6940, 0.1250; 0.9290, 0.6940, 0.1250; 0.8500, 0.3250, 0.0980; 0, 0.4470, 0.7410])
    saveas(gcf,'../Figures/Figure7.png');
% else
%     Fig7_data = [DYratio_actual_OMB DYratio_hat_ZeroPB DYratio_hat_NDRR DYratio_hat_NDRR_ZeroPB ];
%     Fig7_data = Fig7_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
% end

% Figure 8: Effective Interest Rate Differential
Fig8_data = xw_sum_ALL(1947-startyear+1:1974-startyear+1);
plot(year(6:33), Fig8_data);
xlim([1947 1974])
%legend('x_t','Location','Southoutside')
colororder('default')
saveas(gcf,'../Figures/Figure8.png');

% Load Interest Rate Data for Figure A.1
X = readtable('../Data/Input_Counterfactual.xlsx',sheet="Interest",VariableNamingRule='preserve');
X = table2array(X);
X(36,:) = []; % Removes TQ

% Figure A.1: Aggregate Interest Rate, Net Interest Rate, and Proxy Aggregate Interest Rate
FigA1_data = [X(:,4) X(:,3) X(:,2)];
plot(year_noTQ, FigA1_data)
lgd = legend('Aggregate Interest Rate, 1962-2022', 'Aggregate Interest Rate, 1947-1961', 'Rate based on Net Interest', 'Location','Southoutside');
fontsize(lgd,12,'points')
xlim([1947 endyear])
colororder('default')
saveas(gcf,'../Figures/FigureA1.png');

% Figure A.2: Reverse Maturity Structure of Marketable Public Debt, 1942-1960
FigA2_data = RMS_M(1:DBbreakyear-startyear+1,:);
area(year(1:DBbreakyear-startyear+1,1), FigA2_data);
xlim([startyear DBbreakyear])
ylim([0,1])
legend('0','1','[2;5]','[6;10]','>10','Location','southoutside','Orientation','horizontal')
colororder(RMScolors)
saveas(gcf,'../Figures/FigureA2.png');

% Figure A.3: Reverse Maturity Structure of Non-Marketable Public Debt, 1942-1960
FigA3_data = RMS_NM(1:DBbreakyear-startyear+1,:);
area(year(1:DBbreakyear-startyear+1,1), FigA3_data);
xlim([startyear DBbreakyear])
ylim([0,1])
legend('0','1','[2;5]','[6;10]','>10','Location','southoutside','Orientation','horizontal')
colororder(RMScolors)
saveas(gcf,'../Figures/FigureA3.png');

% Figure A.4: Non-Marketable Debt as a Share of Total Debt (%)
FigA4_data = [100*(1-m)];
plot(year, FigA4_data);
%legend('Marketable (Hall)(%Debt)', 'Non-Marketable (Hall)(%Debt)','Location','Southoutside')
xlim([startyear endyear])
ylim([0 40])
colororder('default')
saveas(gcf,'../Figures/FigureA4.png');

% Figure A.5: GDP Deflator and CPI Inflation Expectation Errors, 1970-1998
FigA5_data = [pi_gdp(2:end) - pi_exp_short(1:end-1), pi_cpi(2:end) - pi_exp_short_cpi(1:end-1)];
FigA5_data = [year_noTQ FigA5_data];
FigA5_data = [FigA5_data([29:34,36:58],:)];
plot(FigA5_data(:,1), FigA5_data(:,2:end))
xlim([1970 1998])
lgd = legend('GDP Deflator Inflation', 'CPI Inflation','Location','Southoutside');
fontsize(lgd,12,'points')
colororder('default')
saveas(gcf,'../Figures/FigureA5.png');

% Figure A.6: GDP Deflator and PCE Inflation Rates
FigA6_data = [pi_gdp_original pi_exp_short_pce];
FigA6_data = FigA6_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
plot(year_noTQ, FigA6_data)
xlim([1947 endyear])
lgd = legend('GDP Deflator Inflation ', 'PCE Deflator Inflation ', 'Location','Southoutside');
fontsize(lgd,12,'points')
colororder('default')
saveas(gcf,'../Figures/FigureA6.png');

% Figure A.7: Short-term, Smoothed Short-term, and Long-term Inflation Expectations
pi_exp_long = pi_exp_long_gdp;
pi_exp_long(1:26,1) = NaN;
FigA7_data = [pi_exp_short pi_exp_long pi_exp_short_hp];
FigA7_data = FigA7_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
plot(year_noTQ, FigA7_data)
%legend('ST expectation (Data) $\mathbb{E}}_{t}[\pi_{t+1}]$', 'ST expectation (HP) $\tilde{\mathbb{E}}_{t}[\pi_{t+1}]$','LT expectation (Data) $\E_t[\pi^{10}]$','Location','Southoutside')
lgd = legend('Short-term ','Long-term', 'Smoothed short-term','Location','Southoutside');
fontsize(lgd,12,'points')
xlim([expyear-1 endyear])
colororder('default')
saveas(gcf,'../Figures/FigureA7.png');

% Figure A.8: Actual and Fitted Long-term Inflation Expectations
pi_exp_long = pi_exp_long_gdp;
pi_exp_long(1:26,1) = NaN;
FigA8_data = [pi_exp_long pi_exp_long_predict];
FigA8_data = FigA8_data([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
plot(year_noTQ, FigA8_data)
%legend('ST expectation (Data) $\mathbb{E}}_{t}[\pi_{t+1}]$', 'LT expectation (Data) $\E_t[\pi^{10}]$', 'ST expectation (HP) $\hat{\E}_t[\pi^{10}$]]','Location','Southoutside')
lgd = legend('Actual ', 'Fitted','Location','Southoutside');
fontsize(lgd,12,'points')
xlim([expyear-1 endyear])
colororder('default')
saveas(gcf,'../Figures/FigureA8.png');

% Figure A.9: Residual in the Debt Dynamics Equation (% GDP)
residual_gdp = residual ./ GDP_actual .* 100;
FigA9_data = residual_gdp([1:TQbreakyear-startyear+1, TQbreakyear-startyear+3:end], :);
plot(year_noTQ, FigA9_data)
%legend('Residual', 'Location','Southoutside')
xlim([1947 endyear])
colororder('default')
saveas(gcf,'../Figures/FigureA9.png');

% [**] Switched codes for Figures A.10 and A.11, as intended in appendix [**]

% Load Data for Figure A.10
Data_epsilon = readtable('../Data/Input_Counterfactual.xlsx',sheet="epsilon",VariableNamingRule='preserve');
Data_epsilon = table2array(Data_epsilon);
DYratio_hat_NDRR_ZeroPB_data = DYratio_hat_NDRR_ZeroPB([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
DYratio_hat_NDRR_ZeroPB_ZeroE_data = DYratio_hat_NDRR_ZeroPB_ZeroE([1:TQbreakyear-startyear+1,TQbreakyear-startyear+3:end],:);
FigA10_data = [Data_epsilon(:,2) DYratio_hat_NDRR_ZeroPB_data Data_epsilon(:,3) DYratio_hat_NDRR_ZeroPB_ZeroE_data];

% Figure A.10: Debt over GDP Paths - Counterfactual Scenarios with epsilon=0

plot(Data_epsilon(:,1), Data_epsilon(:,2),"-");
hold on
plot(Data_epsilon(:,1), DYratio_hat_NDRR_ZeroPB_data,"-");
plot(Data_epsilon(:,1), Data_epsilon(:,3),"--");
plot(Data_epsilon(:,1), DYratio_hat_NDRR_ZeroPB_ZeroE_data,"--");
hold off
lgd = legend('Actual history', 'Combined scenario', 'Actual history with \epsilon=0', 'Combined scenario with \epsilon=0', 'Location','Southoutside');
fontsize(lgd,12,'points')
xlim([1942 2022])
ylim([0 140])
colororder(	[0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980])
saveas(gcf,'../Figures/FigureA10.png');

% Figure A.11: Debt/GDP with Zero Primary Balance and Alternative 
% Measures of Interest Rates, 1979 - 2022
FigA11_data = Data_Blanchard(1:39,2:4);
plot(year(39:77),FigA11_data)
lgd = legend('Blanchard (2019) Pre-Tax Interest Rate','Blanchard (2019) After-Tax Interest Rate ','Actual Interest Rates Paid by the Treasury','Location','Southoutside');
fontsize(lgd,12,'points')
xlim([1979 2017])
colororder('default')
saveas(gcf,'../Figures/FigureA11.png');




% Generates tables for data in Figures 1-8 and A1-A10
Fig1_table = array2table([year_noTQ Fig1_data],'VariableNames',...
    {'Year','Federal Debt Held by the Public (%GDP)'});
Fig2_table = array2table([year_noTQ Fig2_data],'VariableNames',...
    {'Year','Primary Surplus/GDP'});
Fig3_table = array2table([year_noTQ3 Fig3_data],'VariableNames',...
    {'Year','GDP Deflator Inflation Rate','Inflation Expected 1-Year Ago',...
    'Inflation Expected 10-Years Ago'});
Fig4_table = array2table([year_noTQ Fig4_data],'VariableNames',...
    {'Year','0','1','[2;5]','[6;10]','>10'});
Fig5_table = array2table([year_noTQ Fig5_data],'VariableNames',...
    {'Year','ST expectation', 'LT expectation'});
Fig6_table = array2table([year_noTQ Fig6_data],'VariableNames',...
    {'Year','1951','1952','1953','1954','1955','1956','1957',...
    '1958','1959','1960','1961','1962','1963','1964','1965',...
    '1966','1967','1968','1969','1970','1971','1972','1973',...
    '1974','1975','1976','1977','1978','1979','1980','1981',...
    '1982','1983','1984','1985','1986','1987','1988','1989',...
    '1990','1991','1992','1993','1994','1995','1996','1997',...
    '1998','1999','2000','2001','2002','2003','2004','2005',...
    '2006','2007','2008','2009','2010','2011','2012','2013',...
    '2014','2015','2016','2017','2018','2019','2020','2021','2022'});

% [**] Removed reference to 'divindex' for Fig7_table [**]

Fig7_table = array2table([year_noTQ Fig7_data],'VariableNames',...
    {'Year','Federal Debt Held by the Public (%GDP)',...
    'Counterfactual: Primary Balance = 0 since 1947', ...
    'Counterfactual: No Interest Rate Distortions', ...
    'No Interest Rate Distortions & Primary Balance = 0 since 1947'});
Fig8_table = array2table([year(6:33) Fig8_data],...
    'VariableNames',{'Year','x_t'});

% [**] Fixed names of columns in FigA1_table [**]
FigA1_table = array2table([year_noTQ FigA1_data],...
    'VariableNames',{'Year','Aggregate Interest Rate, 1962-2022',...
    'Aggregate Interest Rate, 1947-1961','Rate based on Net Interest'});
FigA2_table = array2table([year(1:DBbreakyear-startyear+1,1) FigA2_data], ...
    'VariableNames',{'Year','0','1','[2;5]','[6;10]','>10'});
FigA3_table = array2table([year(1:DBbreakyear-startyear+1,1) FigA3_data], ...
    'VariableNames',{'Year','0','1','[2;5]','[6;10]','>10'});
FigA4_table = array2table([year FigA4_data],...
    'VariableNames',{'Year','Non-Marketable (Hall)(%Debt)'});
FigA5_table = array2table(FigA5_data, ...
    'VariableNames',{'Year','GDP Deflator Inflation', 'CPI Inflation'});
FigA6_table = array2table([year_noTQ FigA6_data],...
    'VariableNames',{'Year','GDP Deflator Inflation', 'PCE Inflation'});
FigA7_table = array2table([year_noTQ FigA7_data],...
    'VariableNames',{'Year','Short-term','Long-term',...
    'Smoothed short-term'});
FigA8_table = array2table([year_noTQ FigA8_data],...
    'VariableNames',{'Year','Actual', 'Fitted'});
FigA9_table = array2table([year_noTQ FigA9_data],...
    'VariableNames',{'Year','Residual'});
% [**] Switched codes for Figures A.10 and A.11, as intended in appendix [**]
FigA10_table = array2table([Data_epsilon(:,1) FigA10_data],...
    'VariableNames',{'Year','Actual history', 'Combined scenario', ...
    'Actual history with epsilon=0', 'Combined scenario with epsilon=0'});
FigA11_table = array2table([year(39:77) FigA11_data],...
    'VariableNames',{'Year','Blanchard (2019) Pre-Tax Interest Rate',...
    'Blanchard (2019) After-Tax Interest Rate',...
    'Actual Interest Rates Paid by the Treasury'});



% Writes data for all figures 1-10 and A1-A10 into "Figures.xlsx"
% [**] Deletes old 'Figures.xlsx' file every time, 
% then rewrite the new version of the file [**]

filename = '../Results/Figures.xlsx';
delete '../Results/Figures.xlsx';
writetable(Fig1_table,filename,'Sheet','Figure1')
writetable(Fig2_table,filename,'Sheet','Figure2')
writetable(Fig3_table,filename,'Sheet','Figure3')
writetable(Fig4_table,filename,'Sheet','Figure4')
writetable(Fig5_table,filename,'Sheet','Figure5')
writetable(Fig6_table,filename,'Sheet','Figure6')
writetable(Fig7_table,filename,'Sheet','Figure7')
writetable(Fig8_table,filename,'Sheet','Figure8')

writetable(FigA1_table,filename,'Sheet','FigureA1')
writetable(FigA2_table,filename,'Sheet','FigureA2')
writetable(FigA3_table,filename,'Sheet','FigureA3')
writetable(FigA4_table,filename,'Sheet','FigureA4')
writetable(FigA5_table,filename,'Sheet','FigureA5')
writetable(FigA6_table,filename,'Sheet','FigureA6')
writetable(FigA7_table,filename,'Sheet','FigureA7')
writetable(FigA8_table,filename,'Sheet','FigureA8')
writetable(FigA9_table,filename,'Sheet','FigureA9')
writetable(FigA10_table,filename,'Sheet','FigureA10')
writetable(FigA11_table,filename,'Sheet','FigureA11')
