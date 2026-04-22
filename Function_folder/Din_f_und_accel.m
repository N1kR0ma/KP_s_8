function [accel, Din_f, v] = ...
    Din_f_und_accel(u_tr, h_tr, kch, delta, DVS_1_torqe, m, Name)
global g r0 f

%%
close all

%% Установка некоторых настроек графиков по умолчанию

% % % % % Change default axes fonts.
set(groot,'DefaultAxesFontName', 'Times New Roman');
set(groot,'DefaultAxesFontSize', 30);

% % % % % Change default text fonts.
set(groot,'DefaultTextFontname', 'Times New Roman');
set(groot,'DefaultTextFontSize', 30);

set(groot,'defaultFigureColor','w');

% % % % % Настройка линий графика

% Define custom color
customColors = [...
         0    0    0
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840...
];

% Set the custom color order
set(gca, 'ColorOrder', customColors);

set(0,'DefaultAxesColorOrder', customColors);

colororder(customColors)

set(groot,'defaultLineLineWidth',2);

set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');


set(groot,'defaultFigurePosition', [0, 0, 1500, 1500]);

%% Посторение графиков динамического фактора

% % % % %   Вычисление тягловой силы на колёсах
P_k  = DVS_1_torqe(:,2).*kch.*h_tr*u_tr./r0;
% % % % %   Вычисление скорости автомобиля в зависимости от частоты

% % % % %   вращения колечатого вала
v = DVS_1_torqe(:,1).*r0./u_tr;

% % % % %   Сила сопротивления воздуха соответствующая скорости 
P_w = Wozdux(v);

% % % % %   Вычисление динамического фактора 
Din_f               =   (P_k  -  P_w) / (m*g);

% % % % %   Вычисление силы сопротивления качению на ровной дороге
P_f = Soprotivlenie(0,v,m);

% % % % %   Вычисление коэффициента сопротивления качению итогового
f_1 = P_f / m / g;

% % % % %   Вычисление ускорения 
accel = (Din_f-f_1)*g./(delta);

% % % % %   Данные для построения силы сопротивления
v_full = linspace(min(v,[],'all'),max(v,[],'all'),500);

f_full = Soprotivlenie(0,v_full,m) /m /g;

Name_1 = [Name, ' динамический фактор'];

%Графики дин фактора и ускорения
title_str   =   string('w');
figure;

hold on;
xlabel('Скорость движения автомобиля, V км/ч'); 
ylabel('Динамический фактор , D')

for schetchik_din_utr =   1:length(u_tr);

plot(v(:,schetchik_din_utr)*3.6,Din_f(:,schetchik_din_utr),'-',...
'color',[rand rand rand]);

title_str1 =   strcat("D_{",num2str(schetchik_din_utr),'}');
title_str(schetchik_din_utr,1)   =  string(title_str1);
end

plot(v_full*3.6,f_full,'--',...
'color',[rand rand rand], 'LineWidth', 2);

% title_str(schetchik_din_utr+1,1)   =  'P_f';

legend(title_str(:,1),'FontSize',20,'NumColumns',2);


[x_down, x_up] = Limited_graf(v*3.6, 0);
xlim( [x_down, x_up] );

[y_down, y_up] = Limited_graf(Din_f, 0);
ylim( [y_down, y_up] );

saveas(gcf, Name_1, 'png');

title(Name_1);

title_str   =   string('w');

Name_2      =   [Name, ' ускорение автомобиля'];

figure;
for schetchik_din_utr =   1:length(u_tr);
grid on;
hold on;
xlabel('Скорость движения автомобиля, V(t) м/с'); 
ylabel('Ускорение автомобиля, а м/с^2')

plot(v(:,schetchik_din_utr)*3.6,accel(:,schetchik_din_utr), ...
'-', 'color',[rand rand rand]);

title_str1 =   strcat("a_{",num2str(schetchik_din_utr),'}');

title_str(schetchik_din_utr,1)   =  string(title_str1);

end;

[x_down, x_up] = Limited_graf(v*3.6, 0);
xlim( [x_down, x_up] );

[y_down, y_up] = Limited_graf(accel, 0);
ylim( [y_down, y_up] );

legend(title_str(:,1),'FontSize',20,'NumColumns',2);

saveas(gcf, Name_2, 'png');

title(Name_2);

end