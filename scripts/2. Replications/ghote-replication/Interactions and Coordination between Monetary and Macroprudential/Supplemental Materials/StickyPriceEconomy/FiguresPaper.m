%% STICKY PRICE ECONOMY WITHOUT MACRO-PRUDENTIAL POLICY: FIGURES
% This code generates Figures 5 and 6 in the paper.
 
clear; clc; close all;  

tic 

%% INPUTS

% Parameters 
load parameters.mat
load frictionless.mat

% Equilibria 
load NeutralMonetaryPolicyFigure.mat
load SociallyOptimalMonetaryPolicyFigure.mat

% Grid
xmin = 18; xmax = 96; xgrid = [.03 .45]; q_EE = 0.7359;
[V,xL_ss] = min(abs(mu_x_L)); [V,xE_ss] = min(abs(mu_x_E)); x_L = x_E;

%% COMMON PROPERTIES FOR FIGURES, AXES, LINES, AND LABELS

% Figures
width  = 5.75;                % Width in inches 
height = 1.50*width;          % Height in inches
p1     = 0;
p2     = 0;

% Plots
ws = 0.320; % Width in inches 
hs = 0.085; % Height in inches

% Axes
alw = 1;         % AxesLineWidth 
fsz = 10;        % Fontsize
lc  = [0 0   1];      % Color Axes (left)
rc  = [0.0 0.3 0.0];  % Color Axes (right)
la  = [1.0 0.0 1.0];  % Color lambda

% Lines
lw  = 1;        % LineWidth 
msz = 8;        % MarkerSize 

% Labels
fszl = 10;                  % Fontsize
tpos = [-0.26 1.14 1.10];   % Title Position
xtt   = [0.05:0.10:0.3 x(x_L-1) 0.35:0.10:0.5];         %xtick
xll   = {'0.05','0.15','0.25','','0.35','0.45','0.50'}; %label

%% FIGURE 5 --- SOCIALLY OPTIMAL MONETARY POLICY (SoMo) IN THE FINANCIALLY UNREGULATED ECONOMY 
figure(5);

set(gcf,'Name','Socially Optimal Monetary Policy (SoMo) in the Financially Unregulated Economy','Color','White',...
    'Units','inches','Position',[0 0 width height]);

subplot(2,2,2)

plot(x(xmin:xmax),log(l_E(xmin:xmax)/l_F),'Color',lc,'LineStyle','-' ,'LineWidth',lw); ylim([-0.015 0.01]);
hold on
plot(x(xmin:xmax),log(l_L(xmin:xmax)/l_F),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on 
line([x(x_L-1) x(x_L-1)],ylim,'LineStyle','--','Color',lc,'LineWidth',lw);
xlim(xgrid);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',-0.02:0.005:0.01,...
    'YTickLabels',{'-0.02','','-0.01','','0.00','','0.01'},'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel B. Employment Gap');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$ln(l/l_E)$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,1)

plot(x(xmin:xmax),pi_E(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw); ylim([-0.03 0.02]) %ylim([pi_E(xmax) pi_E(xmin)])
hold on 
plot(x(xmin:xmax),pi_L(xmin:xmax),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(x_L-1) x(x_L-1)],[-0.03 0.01],'LineStyle','--','Color',lc,'LineWidth',1);
hold on
x1 = 0.98*x(x_L-1); y1 = 0.016; str1 = '$$\bar{\eta}$$';
text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',lc);
xlim(xgrid);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',-0.03:0.01:0.02,...
    'YTickLabels',{'','-0.02','','0.00','','0.02'},'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel A. Inflation Rate');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$E[\pi|\eta]$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

legend('SoMo','LF','Location','Southwest','Orientation','Horizontal')
legpos = get(legend,'Position'); set(legend,'Position',[0.1*legpos(1) 0.53*legpos(2) legpos(3) legpos(4)],'Box','on');


subplot(2,2,3)

plot(x(xmin:xmax),r_E(xmin:xmax)/r_F,'Color',lc,'LineStyle','-' ,'LineWidth',lw);
hold on 
plot(x(xmin:xmax),r_L(xmin:xmax)/r_F,'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(x_L-1) x(x_L-1)],[r_E(xmax)/r_F 1.22],'LineStyle','--','Color',lc,'LineWidth',lw);
xlim(xgrid); ylim([r_E(xmax)/r_F 1.22]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',1:0.05:1.2,'YTickLabel',{'1.00','1.05','1.10','1.15','1.20'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) 3.62*position(2) ws hs]);
t = title('Panel C. Rental Rate');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\omega \thinspace r_k/r_{k,E}$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,4)

factor = (l_E/l_F).^(1+psi+alpha); qq = 16.1243 + (xmin:xmax)*0;

plot(x(xmin:xmax),q_E(xmin:xmax)/((1-alpha)/rho),'Color',lc,'LineStyle','-' ,'LineWidth',lw);
hold on 
plot(x(xmin:xmax),q_L(xmin:xmax)/((1-alpha)/rho),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(x_L-1) x(x_L-1)],[qq(xmin)/((1-alpha)/rho) .84],'LineStyle','--','Color',lc,'LineWidth',1);
xlim(xgrid); ylim([qq(xmin)/((1-alpha)/rho) .84]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0.72:0.03:0.84,'YTickLabel',{'0.72','0.75','0.78','0.81','0.84'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) 3.62*position(2) ws hs]);
t = title('Panel D. Price of Physical Capital');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\omega \thinspace q/q_E$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

print('FigureE', '-dpng', '-r600'); %print FigureE.eps; % tightfig;

%% FIGURE 6 ---  AMPLIFICATION FACTOR AND INVARIANT DISTRIBUTION
figure(6);

set(gcf,'Name','Amplification Factor and Invariant Distribution','Color','White',...
    'Units','inches','Position',[0 0 width height]);

tpos = [-0.26 1.08 1.10];   % Title Position

subplot(1,2,1)

sigma_q_E = sigma_x_E./(phi_E-1); sigma_q_L = sigma_x_L./(phi_L-1); sigma_A = 1*sigma_a;

plot(x(xmin:xmax),sigma_q_E(xmin:xmax)/sigma_A,'Color',lc,'LineStyle','-' ,'LineWidth',lw);
hold on 
plot(x(xmin:xmax),sigma_q_L(xmin:xmax)/sigma_A,'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(x_L-1) x(x_L-1)],[1 1.02*max(sigma_q_L(xmin:xmax)/sigma_A)],'LineStyle','--','Color',lc,'LineWidth',1);
xlim(xgrid); ylim([1 1.02*max(sigma_q_L(xmin:xmax)/sigma_A)]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',1:0.1:1.5,'YTickLabels',{'1.00','1.10','1.20','1.30','1.40','1.50'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) 2.85*position(2) ws hs]);
t = title('Panel A. Amplification Factor');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\sigma_q \thinspace / \sigma_A$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(1,2,2)

yyaxis left
plot(x(xmin:xmax),p_x_E(xmin:xmax),'Color',lc,'LineStyle','-' ,'LineWidth',lw);
hold on 
plot(x(xmin:xmax),p_x_L(xmin:xmax),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(x_L-1) x(x_L-1)],[min(p_x_L(xmin:xmax)) .90*max(p_x_L(xmin:xmax))],'LineStyle','--','Color',lc,'LineWidth',1);
hold on
x1 = 0.98*x(x_L-1); y1 = .97*max(p_x_L(xmin:xmax)); str1 = '$$\bar{\eta}$$';
text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',lc);
hold on 
line([x(xE_ss) x(xE_ss)],[0 1.03*max(p_x_L(xmin:xmax))],'LineStyle',':','Color',lc,'LineWidth',1);
hold on 
line([x(xL_ss) x(xL_ss)],[0 1.03*max(p_x_L(xmin:xmax))],'LineStyle',':','Color',rc,'LineWidth',1);
xlim(xgrid); ylim([min(p_x_L(xmin:xmax)) 1.03*max(p_x_L(xmin:xmax))]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0:2:6,'YTickLabels',{'0.00','2.00','4.00','6.00'},...
    'YColor',[0 0 0],'XTick',[0.05 0.15 x(xL_ss) x(xE_ss) 0.25 x(x_L-1) 0.35 0.45],...
    'XTickLabels',{'0.05','0.15','','','0.25','','0.35','0.45'});
position = get(gca,'Position'); set(gca,'Position',[position(1) 2.85*position(2) ws hs]);
t = title('Panel B. Invariant Distribution');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$E[g|\eta]$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

yyaxis right
plot(x(xE_ss),0,'.','Color',lc,'MarkerSize',8)
hold on
plot(x(xL_ss),0,'.','Color',lc,'MarkerSize',8)
ylim([0 0.000001]); set(gca,'YColor',[1 1 1]);

legend('SoMo','LF','Location','Southwest','Orientation','Horizontal')
legpos = get(legend,'Position'); set(legend,'Position',[0.1*legpos(1) 0.725*legpos(2) legpos(3) legpos(4)],'Box','on');

print('FigureF', '-dpng', '-r600'); %print FigureF.eps; %  tightfig;

toc