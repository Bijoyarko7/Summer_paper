%% FLEXIBLE PRICE ECONOMY: FIGURES
% This code generates Figures 1 to 4 in the paper.
  
clear; clc; close all; 

tic 

%% INPUTS

% Parameters 
load parameters.mat
load frictionless.mat

% Equilibria 
load LaissezFaireFigure.mat
load FinanciallyRegulatedFigure.mat 

% Grid
xmin = 18; xmax = 96; xgrid = [.02 .50]; xH = 83;
[V,xL_ss] = min(abs(mu_x_L)); [V,xE_ss] = min(abs(mu_x_E));

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
tpos = [-0.26 1.14 1.08];   % Title Position
xtt   = [0.05:0.10:0.3 x(x_L-1) 0.35:0.10:0.5];         %xtick
xll   = {'0.05','0.15','0.25','','0.35','0.45','0.50'}; %label

%% FIGURE 1 --- MARKOV EQUILIBRIUM AS A FUNCTION OF INTERMEDIARY WEALTH SHARE (LAISSEZ-FAIRE ECONOMY)
figure(1);

set(gcf,'Name','Markov Equilibrium as a Function of Intermediary Wealth Share (Laissez-faire Economy)','Color','White','Units','inches','Position',[0 0 width height])

subplot(2,2,1)

plot(x(xmin:xmax),lambda*v_L(xmin:xmax),'Color',la,'LineStyle','-','Marker','o','LineWidth',1);
hold on
plot(x(xmin:xmax),phi_L(xmin:xmax)     ,'Color',lc,'LineStyle','-','LineWidth',lw);
hold on
x1 = .44; y1 = 3.10; str1 = '$$\lambda v$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',la)
hold on
x1 = 0.98*x(x_L-1); y1 = 3.9; str1 = '$$\bar{\eta}$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color','r')
hold on 
line([x(x_L-1) x(x_L-1)],[2 3.76],'Color','r','LineStyle','--','LineWidth',1);
xlim(xgrid); ylim([2 4]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',2:0.5:4,'YTickLabel',{'2.00','2.50','3.00','3.50','4.00'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel A. Leverage Multiple');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\phi$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,2)

plot(x(xmin:xmax),a_L(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
line([x(x_L-1) x(x_L-1)],[a_L(xmin) 1],'LineStyle','--','Color','r','LineWidth',1);
xlim(xgrid); ylim([a_L(xmin) 1]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0.76:0.06:1,'YTickLabel',{'0.76','0.82','0.88','0.94','1.00'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel B. Financing to Firms');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$a$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,3)

r_L = (1-alpha)*y_F*a_L.^-alpha;

plot(x(xmin:xmax),r_L(xmin:xmax)/r_L(xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
line([x(x_L-1) x(x_L-1)],[r_L(xmax)/r_L(xmax) 1.2],'LineStyle','--','Color','r','LineWidth',1);
xlim(xgrid); ylim([1 1.2]); 

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',1:0.05:1.2,'YTickLabel',{'1.00','1.05','1.10','1.15','1.20'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) 3.7*position(2) ws hs]);
t = title('Panel C. Rental Rate');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$r_k/r_{k,E}$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,4)

plot(x(xmin:xmax),q_L(xmin:xmax)/((1-alpha)/rho),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
line([x(x_L-1) x(x_L-1)],[q_E(xmin)/((1-alpha)/rho) .84],'LineStyle','--','Color','r','LineWidth',1);
xlim(xgrid); ylim([.72 .84]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0.72:0.03:0.84,'YTickLabel',{'0.72','0.75','0.78','0.81','0.84'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) 3.7*position(2) ws hs]);
t = title('Panel D. Price of Physical Capital');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$q/q_E$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

print('FigureA', '-dpng', '-r600'); %print FigureA.eps; %tightfig;

%% EQUILIBRIUM DYNAMICS (LAISSEZ-FAIRE ECONOMY)
figure(2);

set(gcf,'Name','Equilibrium Dynamics (Laissez-faire Economy)','Color','White','Units','inches','Position',[0 0 width height])

subplot(1,2,1)

yyaxis left
plot(x(xmin:xmax),mu_x_L(xmin:xmax).*x(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
ylabel('$$\mu_{\eta} \thinspace \eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
xlim(xgrid); ylim([mu_x_L(xmax).*x(xmax) 0.01]); %ylim([mu_x_L(xmax).*x(xmax) mu_x_L(xmin).*x(xmin)]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','on','TickDir', 'out', 'TickLength', [.02 .02],'YTick',-0.02:0.01:0.01,'YTickLabels',{'-0.02','-0.01','0.00','0.01'},'YColor',lc);

yyaxis right
bar(x(xmin:xmax),p_x_L(xmin:xmax),'BarWidth',1.5,'FaceColor',rc','EdgeColor',rc,'FaceAlpha',.5); ylim([0 8])
hold on
plot(x(xL_ss),0,'w.','MarkerSize',20)
hold on
plot(x(xL_ss),0,'.','Color',rc,'MarkerSize',8)
hold on
line([x(xL_ss) x(xL_ss)],[0 7.00],'LineStyle','--','Color',rc,'LineWidth',1);
x1 = 0.97*x(xL_ss); y1 = 7.6; str1 = '$$\eta_{ss}$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',rc)
hold on
line([x(x_L-1) x(x_L-1)],[0 7.00],'LineStyle','--','Color','r','LineWidth',1);
x1 = 0.98*x(x_L-1); y1 = 7.6; str1 = '$$\bar{\eta}$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color','r')
%ylabel('$$g$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0:2:8,'YTickLabels',{''},'YColor',rc,...
    'XTick',[0.05 0.15 x(xL_ss) 0.25 x(x_L-1) 0.35:0.10:0.5],'XTickLabels',{'0.05','0.15','','0.25','','0.35','0.45','0.50'});
position = get(gca,'Position'); set(gca,'Position',[position(1) 2.85*position(2) ws hs]);
t = title('Panel A. {\color[rgb]{0 0 1}Drift Process}');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(1,2,2); 

yyaxis left
plot(x(xmin:xmax),sigma_x_L(xmin:xmax).*x(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
line([x(x_L-1) x(x_L-1)],[min(sigma_x_L(xmin:xmax).*x(xmin:xmax)) 0.07],'LineStyle','--','Color','r','LineWidth',1);
ylabel('$$\sigma_{\eta} \thinspace \eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
xlim(xgrid); ylim([min(sigma_x_L(xmin:xmax).*x(xmin:xmax)) 0.07]); %ylim([min(sigma_x_L(xmin:xmax).*x(xmin:xmax)) 1.03*max(sigma_x_L(xmin:xmax).*x(xmin:xmax))]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','on','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0.01:0.02:0.07,'YColor',lc);

yyaxis right
bar(x(xmin:xmax),p_x_L(xmin:xmax),'BarWidth',1.5,'FaceColor',rc','EdgeColor',rc,'FaceAlpha',.5); ylim([0 8])
hold on
plot(x(xL_ss),0,'w.','MarkerSize',20)
hold on
plot(x(xL_ss),0,'.','Color',rc,'MarkerSize',8)
line([x(xL_ss) x(xL_ss)],[0 10],'LineStyle','--','Color',rc,'LineWidth',1);
ylabel('$$g$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0:2:8,'YColor',rc,...
    'XTick',[0.05 0.15 x(xL_ss) 0.25 x(x_L-1) 0.35:0.10:0.5],'XTickLabels',{'0.05','0.15','','0.25','','0.35','0.45','0.50'});
position = get(gca,'Position'); set(gca,'Position',[position(1) 2.85*position(2) ws hs]);
t = title('Panel B. {\color[rgb]{0 0 1}Diffusion Process}');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

print('FigureB', '-dpng', '-r600'); %print FigureB.eps; %tightfig;

%% FIGURE 3 --- SOCIALLY OPTIMAL MACRO-PRUDENTIAL POLICY (SoMa) AND INTERMEDIARY LEVERAGE
figure(3);

set(gcf,'Name','Socially Optimal Macro-prudential Policy (SoMa) and Intermediary Leverage','Color','White','Units','inches','Position',[0 0 width height]);

[V,xB] = min(abs(lambda*v_E.*x-1));

xtt   = [0.05 0.15 x(xL) 0.25 x(xB) 0.35 x(xH) 0.45];         %xtick
xll   = {'0.05','0.15','','0.25','','0.35','','0.45'};        %label
xgrid = [.03 .45];

subplot(1,2,2)

plot(x(xmin:xmax),phi_E(xmin:xmax),'Color',lc,'LineStyle','-' ,'LineWidth',lw);
hold on
plot(x(xmin:xmax),phi_L(xmin:xmax),'Color',rc,'LineStyle','-.','LineWidth',lw); ylim([2.25 3.65]);
hold on 
line([x(xL) x(xL)],ylim,'LineStyle','--','Color',lc ,'LineWidth',1);
hold on 
line([x(xH) x(xH)],ylim,'LineStyle','--','Color',lc ,'LineWidth',1);
hold on 
%line([x(xB) x(xB)],ylim,'LineStyle','--','Color','r','LineWidth',1);
xlim(xgrid);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',2:0.5:4,'YTickLabel',{'2.00','2.50','3.00','3.50','4.00'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel B. Leverage Multiple');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',[tpos(1) 0.96*tpos(2) 0.96*tpos(3)]);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\phi$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(1,2,1)

Delta_E = 0*x; Delta_L = 0*x;

Delta_E(xL:xH)  = abs( ( Phi(xL:xH) - min(lambda*v_E(xL:xH),1./x(xL:xH)) ) )...
    ./ ( ( Phi(xL:xH) + min(lambda*v_E(xL:xH),1./x(xL:xH)) ) / 2 ) * 100;

plot(x(xmin:xmax),Delta_E(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
plot(x(xmin:xmax),Delta_L(xmin:xmax),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
x1 = 0.98*x(xL); y1 = 6.6; str1 = '$$\eta_L$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',lc);
hold on
x1 = 0.98*x(xH); y1 = 6.6; str1 = '$$\eta_H$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',lc);
hold on
x1 = 0.98*x(xB); y1 = 6.6; str1 = '$$\bar{\eta}$$'; text(x1,y1,str1,'Interpreter','latex','FontName','Times New Roman','FontSize',fszl,'Color',lc)
hold on
line([x(xL) x(xL)],[0 6],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xH) x(xH)],[0 6],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xB) x(xB)],[0 6],'LineStyle',':','Color',lc,'LineWidth',1);
xlim(xgrid); ylim([min(Delta_E) 7]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0:2:6,'YTickLabels',{'0.00','2.00','4.00','6.00'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel A. Macro-prudential Policy');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',[tpos(1) 0.96*tpos(2) 0.96*tpos(3)]);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\Delta \%$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

%legend('SoMa','LF','Location','Northwest','Orientation','Vertical');
%legpos = get(legend,'Position'); set(legend,'Units','normalized','Position',[0.88*legpos(1) 0.94*legpos(2) legpos(3) legpos(4)],'Box','on'); 

legend('SoMa','LF','Location','Northwest','Orientation','Horizontal');
legpos = get(legend,'Position'); set(legend,'Units','normalized','Position',[0.37*legpos(1) 0.22*legpos(2) legpos(3) legpos(4)],'Box','on'); 

print('FigureC', '-dpng', '-r600'); %print FigureC.eps; %tightfig;

%% FIGURE 4 --- COSTS AND BENEFITS OF MACRO-PRUDENTIAL POLICY
figure(4);

set(gcf,'Name','Costs and Benefits of Macro-prudential Policy','Color','White','Units','inches','Position',[0 0 width height]);

subplot(2,2,1)

plot(x(xmin:xmax),a_E(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
plot(x(xmin:xmax),a_L(xmin:xmax),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(xL) x(xL)],[a_L(xmin) 1],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xH) x(xH)],[a_L(xmin) 1],'LineStyle','--','Color',lc,'LineWidth',1);
xlim(xgrid); ylim([.73 1]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0.76:0.06:1,'YTickLabel',{'0.76','0.82','0.88','0.94','1.00'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel A. Financing to Firms');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$a$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,2)

plot(x(xmin:xmax),q_E(xmin:xmax)/((1-alpha)/rho),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
plot(x(xmin:xmax),q_L(xmin:xmax)/((1-alpha)/rho),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(xL) x(xL)],[q_E(xmin)/((1-alpha)/rho) .84],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xH) x(xH)],[q_E(xmin)/((1-alpha)/rho) .84],'LineStyle','--','Color',lc,'LineWidth',1);
xlim(xgrid); ylim([.72 .84]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0.72:0.03:0.84,'YTickLabel',{'0.72','0.75','0.78','0.81','0.84'},...
    'XTick',xtt,'XTickLabels',xll);

position = get(gca,'Position'); set(gca,'Position',[position(1) position(2) ws hs]);
t = title('Panel B. Price of Physical Capital');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$q/q_E$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,3)

sigma_q_E = sigma_x_E./(phi_E-1); sigma_q_L = sigma_x_L./(phi_L-1); sigma_A = 1*sigma_a;

plot(x(xmin:xmax),sigma_q_E(xmin:xmax)/sigma_A,'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
plot(x(xmin:xmax),sigma_q_L(xmin:xmax)/sigma_A,'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(xL) x(xL)],[1 1.02*max(sigma_q_L(xmin:xmax)/sigma_A)],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xH) x(xH)],[1 1.02*max(sigma_q_L(xmin:xmax)/sigma_A)],'LineStyle','--','Color',lc,'LineWidth',1);
xlim(xgrid); ylim([1 1.02*max(sigma_q_L(xmin:xmax)/sigma_A)]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',1:0.1:1.5,'YTickLabels',{'1.00','1.10','1.20','1.30','1.40','1.50'},...
    'XTick',xtt,'XTickLabels',xll);
position = get(gca,'Position'); set(gca,'Position',[position(1) 3.7*position(2) ws hs]);
t = title('Panel C. Amplification Factor');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$\sigma_q \thinspace / \sigma_A$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

subplot(2,2,4)

yyaxis left
plot(x(xmin:xmax),p_x_E(xmin:xmax),'Color',lc,'LineStyle','-','LineWidth',lw);
hold on 
plot(x(xmin:xmax),p_x_L(xmin:xmax),'Color',rc,'LineStyle','-.','LineWidth',lw);
hold on
line([x(xL) x(xL)],[0 1.03*max(p_x_L(xmin:xmax))],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xH) x(xH)],[0 1.03*max(p_x_L(xmin:xmax))],'LineStyle','--','Color',lc,'LineWidth',1);
hold on 
line([x(xE_ss) x(xE_ss)],[0 1.03*max(p_x_L(xmin:xmax))],'LineStyle',':','Color',lc,'LineWidth',1);
hold on 
line([x(xL_ss) x(xL_ss)],[0 1.03*max(p_x_L(xmin:xmax))],'LineStyle',':','Color',rc,'LineWidth',1);
xlim(xgrid); ylim([0 1.03*max(p_x_L(xmin:xmax))]);

set(gca,'Units','normalized','FontUnits','points','FontWeight','normal','FontSize',fsz,'FontName','Times New Roman','LineWidth', alw,...
    'Box', 'off','YGrid','off','TickDir', 'out', 'TickLength', [.02 .02],'YTick',0:2:6,'YTickLabels',{'0.00','2.00','4.00','6.00'},...
    'YColor',[0 0 0],'XTick',[0.05 0.15 x(xL_ss) x(xE_ss) x(xL) 0.25 x(xB) 0.35 x(xH) 0.45],...
    'XTickLabels',{'0.05','0.15','','','','0.25','','0.35','','0.45'});

position = get(gca,'Position'); set(gca,'Position',[position(1) 3.7*position(2) ws hs]);
t = title('Panel D. Invariant Distribution');
set(t,'units','normalized','FontName','Times New Roman','Fontweight','normal','FontSize',fszl,'horizontalAlignment','left','position',tpos);
xlabel('Wealth share $$\eta$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);
ylabel('$$g$$','Interpreter','latex','FontName','Times New Roman','FontSize',fszl);

yyaxis right
plot(x(xE_ss),0,'.','Color',lc,'MarkerSize',8)
hold on
plot(x(xL_ss),0,'.','Color',lc,'MarkerSize',8)
ylim([0 0.000001]); set(gca,'YColor',[1 1 1]);

%legend('SoMa','LF','Location','Northwest','Orientation','Vertical');
%legpos = get(legend,'Position'); set(legend,'Units','normalized','Position',[0.88*legpos(1) 0.94*legpos(2) legpos(3) legpos(4)],'Box','on'); 

legend('SoMa','LF','Location','Northwest','Orientation','Horizontal');
legpos = get(legend,'Position'); set(legend,'Units','normalized','Position',[0.1*legpos(1) 0.73*legpos(2) legpos(3) legpos(4)],'Box','on'); 

print('FigureD', '-dpng', '-r600'); %print FigureD.eps; %tightfig;

toc