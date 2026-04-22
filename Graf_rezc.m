% % % % % Очистка рабочей области
clear all
%%
close all
%%
clear Command Window display
%% Установка некоторых настроек графиков по умолчанию
% Change default axes fonts.
set(groot,'DefaultAxesFontName', 'Times New Roman');
set(groot,'DefaultAxesFontSize', 14);
% Change default text fonts.
set(groot,'DefaultTextFontname', 'Times New Roman');
set(groot,'DefaultTextFontSize', 14);
set(groot,'defaultFigureColor','w');
set(groot,'defaultLineLineWidth',3);
set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');
set(groot,'defaultFigurePosition', [0, 0, 1500, 1500]);
%%

l = 5;
proc = ctranspose(linspace(0.10, 0.15, l));

D_e_1 = linspace(127, 165.1, l);
D_e_2 = linspace(165.1,215.9, l);
D_e_3 = linspace(203.2,279.4, l);
D_e_4 = linspace(226.7,381, l);
D_e_5 = linspace(368.3,482.6, l);

r_c_1 = [76.2 95.25 114.3 152.4 203.2];

G_D_1 = proc * D_e_1    /r_c_1(1);
G_D_2 = proc * D_e_2   /r_c_1(2);
G_D_3 = proc * D_e_3   /r_c_1(3);
G_D_4 = proc * D_e_4   /r_c_1(4);
G_D_5 = proc * D_e_5   /r_c_1(5);

X = linspace(127, 482.6, l);
Y = linspace(min(proc), max(proc), l);
Z = ones(l,l)*1/3;

figure


surf(proc, D_e_1, G_D_1)
hold on
surf(proc, D_e_2, G_D_2)
surf(proc, D_e_3, G_D_3)
surf(proc, D_e_4, G_D_4)
surf(proc, D_e_5, G_D_5)
surf(Y, X, Z);

% figure
% for i = 1:length(proc)
%     
% hold on
% surf(D_e_1, G_D_1(i,:), proc)
% surf(D_e_2,G_D_2(i,:), proc)
% surf(D_e_3, G_D_3(i,:), proc)
% surf(D_e_4, G_D_4(i,:), proc)
% surf(D_e_5, G_D_5(i,:), proc)
% 
% end
