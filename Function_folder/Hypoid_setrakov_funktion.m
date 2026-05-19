% pogr = 1e-3;
% N_kol = 41;
% n_sh = 10;
% 
% F = 31.75e-3;
% hypoid_ex = 38.1e-3;
% D_e2 = 209.55e-3;
% r_c = 114.3e-3;
% betta_1 = 50*pi/180;
% type = 'l';

function [] = Hypoid_setrakov_funktion(...
    N_kol,...       %%%% Число зубьев колеса
    n_sh,...        %%%% Число зубьев шестерня
    F,...           %%%% Ширина ширина
    hypoid_ex,...   %%%% Гипоидное смещение
    D_e2,...        %%%% Внешний делительный диаметр
    r_c,...         %%%% Радиус резцовой головки 
    type,...        %%%% Тип автомобиля 'l'/'g' (влияет на угол зацепления)
    betta_1,...     %%%% Желаемый угол наклона шестерни
    pogr)          %%%% Требования степени сходимости для итерационной части       
format long

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Определение параметров ЗК по методике сетракова    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% Определение передаточного числа
u = N_kol/n_sh;
%%%%%%% Создание пустых массивов
test = zeros(142,3);
Etta = zeros(4,1);
r_c_dot = zeros(4,1);
Delta_r_c = zeros(4,1);
%%%%%%% Название для файла с параметрами
Name = num2str(N_kol) + "_" + num2str(n_sh) +"_"...
    + num2str(D_e2/N_kol*1e3) + ".txt";

%%%%%%% Смена названия
Psi_p_0 = betta_1;

%%%% Входные данные для сверки

u = N_kol/n_sh;

%%% Первичные параметры получаемые в результате расчёта

%%% Непосредственно методика сетракова
%%%%
% test(9) = tan(Psi_p_0); disp_t(test,9)

%%%%% Приблилительное определение угла делительного колеса
Delta_del_l = acot(1.2*u^(-1));
% test(10) = cot(Delta_del_l); disp_t(test,10);
% test(11) = sin(Delta_del_l); disp_t(test,11);

%%%%%  радиус делительной окружности в центре ширины венца
R_g = (D_e2 - F * sin(Delta_del_l))/2;
% disp_k(R_g,3)

%%%%% Какой-то угол пока хз какой
Epsilon_l_dot = asin(hypoid_ex * sin(Delta_del_l) / R_g);
% test(13) = sin(Epsilon_l_dot); disp_t(test,13);
% test(14) = cos(Epsilon_l_dot); disp_t(test,14)

%%%%% Неименнованный параметр
P15 = cos(Epsilon_l_dot) + tan(Psi_p_0) * sin(Epsilon_l_dot);
%%%%% Аналогично
P16 = u(1)^(-1) * R_g;
%%%%% Пока хз
R_p = (cos(Epsilon_l_dot) + tan(Psi_p_0) * sin(Epsilon_l_dot)) * (u(1)^(-1) * R_g);
%%%%% Неименнованный параметр
P18 = (R_g + u(1)^(-1) * R_p) / u(1)^(-1);
%%%%% Фактор консусности чтобы оно не зналичо
Q_1 =  0.75 * (R_g + u(1)^(-1) * R_p) / u(1)^(-1);

Delta_r_c(1) = 2;
i = 1;

%%%%% Итерационная часть которая обеспечивает сходимость
%%%%% Некий угол варьирующий параметры передачи
while Delta_r_c(i)-1 > pogr
   if Delta_r_c(i) == 2
       disp('Первый проход')
   else
       i = i+1;
   end
%%%% Основная варьируемая часть
    %%%% Часть для обновления значений внутри цикла
 switch true
     case i == 1
         Etta(i) = atan(hypoid_ex/Q_1);
     case i == 2
         Etta(i) = atan(hypoid_ex/Q_1 * ( 1+0.1*sign( 1 - Delta_r_c(i-1) )));
     case i > 2
         Etta(i) = Etta(i-2) + ( ( Etta(i-1) - Etta(i-2) ) /...
             (Delta_r_c(i-1) - Delta_r_c(i-2) ) ) * (1 - Delta_r_c(i-2));
         if i > 3
            disp('Возможно что-то не так обычно число итераций 3')
            i
         end
 end
  
% test(20) = tan(Etta(i)); 
% tan(Etta)
% disp_t(test,20);
% disp('CERF')
% test(21) = cos(Etta(i)); disp_t(test,21);
%%%%%% Неименованный параметр 22
P22 = tan(Etta(i))*cos(Etta(i));
%%%%%% Неименнованный параметр 23
P23 = hypoid_ex - R_p*tan(Etta(i))*cos(Etta(i));
% disp_k(P23,3)

%%%%%% Неизвестный угол 2
Epsilon_2 = asin((hypoid_ex - R_p*tan(Etta(i))*cos(Etta(i)))/R_g);
% test(24) = sin(Epsilon_2); disp_t(test,24);
% test(25) = tan(Epsilon_2); disp_t(test,25);

%%%%%% Юху новый неизвестный угол
Gamma_2 = atan(tan(Etta(i))*cos(Etta(i))/tan(Epsilon_2));
% test(26) = tan(Gamma_2); disp_t(test,26);
% test(27) = cos(Gamma_2); disp_t(test,27);

%%%%%% И ещё 1
Epsilon_2_dot = asin(sin(Epsilon_2)/cos(Gamma_2));
% test(28) = sin(Epsilon_2_dot); disp_t(test,28);
% test(29) = cos(Epsilon_2_dot); disp_t(test,29);

%%%%%%% Угол спирали колеса
Psi_P_2 = atan( (cos(Epsilon_l_dot) + tan(Psi_p_0) * sin(Epsilon_l_dot)...
    - cos(Epsilon_2_dot))/sin(Epsilon_2_dot) );
% test(30) = tan(Psi_P_2); disp_t(test,30);

%%%%%%%% Неименнованный параметр
P31 = sin(Epsilon_2_dot) * (tan(Psi_p_0) - tan(Psi_P_2));

%%%%%%%% Неименованный параметр
P32 = u^(-1)*P31;

%%%%%%%% Неизвестный угол шестерни
Epsilon_1 = asin( sin(Epsilon_2) - (tan(Etta(i))*cos(Etta(i))) * u^(-1) *....
    ( sin(Epsilon_2_dot) * ( tan(Psi_p_0) - tan(Psi_P_2) ) ) );
% test(33) = sin(Epsilon_1); disp_t(test,33);
% test(34) = tan(Epsilon_1); disp_t(test,34);

%%%%%%%% Неизвестный угол шестерни
Gamma_1 = atan( tan(Etta(i))*cos(Etta(i)) / tan(Epsilon_1) );
% test(35) = tan(Gamma_1); disp_t(test,35);
% test(36,:) = degrees2dms(Gamma_1*180/pi);
% fprintf('Параметр №36 =  %f %f %f \n',test(36,:))
% test(37) = cos(Gamma_1); disp_t(test,37);

%%%%%%%%% Неизвестнный угол шестерни 1
Epsilon_1_dot = asin( sin(Epsilon_1) / cos(Gamma_1) );
% test(38,:) = sin(Epsilon_1_dot); disp_t(test,38);
% test(39,:) = degrees2dms(Epsilon_1_dot*180/pi);
% fprintf('Параметр №36 =  %f %f %f \n',test(39,:));
% test(40,:) = cos(Epsilon_1_dot); disp_t(test,40);

%%%%%%%%% Скорректированный спирали шестерни в среднем сечении
Psi_P_1 = atan( ( (cos(Epsilon_l_dot) + tan(Psi_p_0) * sin(Epsilon_l_dot)) +...
    ( sin(Epsilon_2_dot) * (tan(Psi_p_0) - tan(Psi_P_2)) ) - ...
   cos(Epsilon_1_dot) ) / sin(Epsilon_1_dot) );
% test(41,:) = tan(Psi_P_1 ); disp_t(test,41);
% test(42,:) = degrees2dms(Psi_P_1*180/pi);
% fprintf('Параметр №42 =  %f %f %f \n',test(42,:));
% test(43,:) = cos(Psi_P_1); disp_t(test,43);

%%%%%%%%%% Угол спирали колеса в среднем сечении
Psi_G_1 = Psi_P_1 - Epsilon_1_dot;
% test(44,:) = degrees2dms(Psi_G_1*180/pi);
% fprintf('Параметр №44 =  %f %f %f \n',test(44,:));
% test(45,:) = cos(Psi_G_1 ); disp_t(test,45);
% test(46,:) = tan(Psi_G_1 ); disp_t(test,46);

%%%%%%%%%% Скорректированный делительный угол колеса
Delta_1 = acot(tan(Etta(i)) / sin(Epsilon_1));
% test(47,:) = cot(Delta_1 ); disp_t(test,47);
% test(48,:) = degrees2dms(Delta_1*180/pi);
% fprintf('Параметр №48=  %f %f %f \n',test(48,:))
% test(49,:) = sin(Delta_1 ); disp_t(test,49);
% test(50,:) = cos(Delta_1 ); disp_t(test,50);

%%%%%%%%%%% Неименованный пункт
P51 = (R_p + ( R_g...
* (u^(-1) * ( sin(Epsilon_2_dot) * (tan(Psi_p_0) - tan(Psi_P_2) ) ) ) ) )...
/ cos(Gamma_1);
% disp_k(P51,3)

P52 = R_g / cos(Delta_1 );
% disp_k(P52,3)

P53 = P51 + P52;
% disp_k(P53,3)

P54 = (R_g * cos(Psi_G_1 ) ) / sin(Delta_1 );
% disp_k(P54,3)

P55 = cos(Psi_P_1) * P51 / tan(Gamma_1);
% disp_k(P55,3)

%%%%%%%%%%% Новый неизвестный угол
Fi_01 = atan( (-1) * (tan(Psi_P_1 )*P55 - tan(Psi_G_1 )*P54) / P53);
% test(56,:) = -tan(Fi_01); disp_t(test,56);
% test(57,:) = degrees2dms(-Fi_01*180/pi);
% fprintf('Параметр №57=  %f %f %f \n',test(57,:))
% test(58,:) = cos(Fi_01);disp_t(test,58);

%%%%%%%%%%% Неименовыннай пункт
P59 = tan(Psi_P_1 ) * (-1) * tan(Fi_01) / P51 /1e3;
P60 = tan(Psi_G_1 ) * (-1) * tan(Fi_01) / P52 / 1e3;
P61 = P54 * P55 * 1e6;

%%%%%% Не сходятся числа
P62 = (P54 - P55) / P61 *1e3;

%%%%%% 
P63 = P59 + P60 + P62;

%%%%%%
P64 = (tan(Psi_P_1 ) - tan(Psi_G_1 ) ) /P63 /1e3;

%%%%%% Расчётный радиус резцовой головки
r_c_dot(i) = P64 / cos(Fi_01);
Delta_r_c(i) = r_c / r_c_dot(i);
%%%%%% Проверка соотношения радисов головок
if abs(Delta_r_c(i)-1) > 3/100
   disp('Расчётный радиус недостаточно близок требуется ещё 1 итерация') 
    (Delta_r_c(i)-1) *100;
    Delta_r_c(i);
else
    disp('Расчётный радиус достаточно близок к выбранному')
    (Delta_r_c(i)-1) *100;
    Delta_r_c(i);
end

end
Etta_f = Etta(i);
r_c_dot_f = r_c_dot(i);
%% Часть финальная для колеса
P67 = tan(Epsilon_1)^2/(1+ tan(Epsilon_1)^2);
P68 = (1+tan(Epsilon_1)^2)^(1/2);
P69 = u^(-1) * (1+tan(Epsilon_1)^2)^(1/2);
P70 = sin(Delta_1 ) * P51;
Z = R_g * cot(Delta_1) - P70;
A = R_g  / sin(Delta_1);
A0 = 0.5 * D_e2  / sin(Delta_1);
P74 = A0  - A;
%%%% Коэффициент полной высоты зуба
switch true
    case n_sh == 6
        K_ab = 3.5;
    case n_sh == 7
        K_ab = 3.6;
    case n_sh == 8
        K_ab = 3.7;
    case n_sh >= 9
        K_ab = 3.8;
end
%%%%% Полная высота зуба
h = K_ab * R_g *  cos(Psi_G_1) / N_kol;
P76 = R_g* tan(Psi_G_1 ) / r_c;
P77 = sin(Delta_1) / cos(Psi_G_1) - P76;
switch true
    case type == 'g'
        Fi_l = 45 * pi / 180;  
    case type == 'l'
        Fi_l = 42.5 * pi / 180;
end

% test(78,:) = degrees2dms(Fi_l*180/pi);
% fprintf('Параметр №78=  %f %f %f \n',test(78,:))
test(79,:) = sin(Fi_l); 
% disp_t(test,79);
test(81,:) = cos(Fi_l/2);
% disp_t(test,81);
test(82,:) = tan(Fi_l/2);
% disp_t(test,82);
P83 = P77 / tan(Fi_l/2);
%%%%% Сумма углов ножек  зубьев для  2х ст обкатки
Delta_s = 10560 * P83 / N_kol /60^2 /3 * pi;
% test(93,:) = degrees2dms(Delta_s*180/pi);
% fprintf('Параметр №93=  %f %f %f \n',test(93,:))
%%%% Определение коэффициента высоты головки зуба
if n_sh >= 21
   switch true
       case u^(-1) > 0.9 &&u^(-1) <= 1
           K_a = 0.5    
       case u^(-1) > 0.8 &&  u^(-1) <= 0.9
           K_a = 0.45
       case u^(-1) > 0.7 &&  u^(-1) <= 0.8
           K_a = 0.425
       case u^(-1) > 0.6 &&  u^(-1) <= 0.7
           K_a = 0.4
       case u^(-1) > 0.5 &&  u^(-1) <= 0.6
           K_a = 0.375
       case u^(-1) > 0.4 &&  u^(-1) <= 0.5
           K_a = 0.350;
       case u^(-1) > 0.3 &&  u^(-1) <= 0.4
           K_a = 0.325;
       case u^(-1) <0.3
           K_a = 0.3;
   end
else
       switch true
       case n_sh == 6
           K_a = 0.110
       case n_sh == 7
           K_a = 0.130
       case n_sh == 8
           K_a = 0.150
       case n_sh >= 9 
           K_a = 0.170;
       end
       K_a = K_a*2.1;
end

K_b = 1.125 - K_a;
a_G = h * K_a;
b_G = h * K_b +0.051/1e3;
%%%% Угол головки зуба колеса
alpha_G = Delta_s * K_a;
% test(87,:) = degrees2dms(alpha_G*180/pi);
% fprintf('Параметр №91=  %f %f %f \n',test(87,:))
P90 = sin(alpha_G);
%%%%% Угол ножки зуба колеса
Delta_G = Delta_s  - alpha_G;
% test(91,:) = degrees2dms(Delta_G*180/pi);
% fprintf('Параметр №91=  %f %f %f \n',test(91,:))
%%%%% 
P92 = sin(Delta_G);
%%%%% Высота головки зуба колеса
a_0_G = a_G + P74 * P90;
%%%%% Высота ножки зуба шестерни
b_0_G = b_G + P74 * P92;
%%%%% Радиальный зазор
c = 0.125 * h + 0.051/1e3;
%%%%% Полная рабочая высота зуба
h_t_G = a_0_G + b_0_G;
%%%%% Рабочая высота зуба
h_0 = h_t_G - c;
%%%%% Угол конуса выступов
Delta_0 = Delta_1 + alpha_G;
% test(98,:) = degrees2dms(Delta_0*180/pi);
% fprintf('Параметр №98=  %f %f %f \n',test(98,:))
%%%%%
P99 = sin(Delta_0);
P100 = cos(Delta_0);

%  fprintf('Параметр №48=  %f %f %f \n',degrees2dms(Delta_1*180/pi));
%  fprintf('Параметр №91=  %f %f %f \n',degrees2dms(Delta_G*180/pi)); 
%% Получение параметров шестерни
Delta_R = Delta_1 - Delta_G;
% test(101,:) = degrees2dms(Delta_R*180/pi);
% fprintf('Параметр №57=  %f %f %f \n',test(101,:))

P102 = sin(Delta_R);
P103 = cos(Delta_R);
P104 = cot(Delta_R);
D_0 = a_0_G * cos(Delta_1) * 2 +  D_e2;
% disp_k(D_0,3)

P106 = P70 + P74 * cos(Delta_1);
%%%%
X_0 = P106 - a_0_G * sin(Delta_1);

P108 = (A * sin(alpha_G) - a_G) / sin(Delta_0);
P109 = (A * sin(Delta_G) - b_G) / sin(Delta_R);

%%%
Z_0 = Z - P108;
Z_R = Z + P109;

%%%%
P112 = R_g + P70*cot(Delta_R);
Epsilon = asin(hypoid_ex /P112);
% test(114,:) = cos(Epsilon); disp_t(test,114);
%%%%
gamma_0 = asin(cos(Delta_R)*cos(Epsilon));
% test(116,:) = sin(gamma_0); disp_t(test,116);
% test(117,:) = degrees2dms(gamma_0*180/pi);
% fprintf('Параметр №117=  %f %f %f \n',test(117,:))
P118 = cos(gamma_0);
P119 = tan(gamma_0);

P120 = (P102*Z_R + c)/P103;

G_0 = (hypoid_ex * sin(Epsilon) - P120) /cos(Epsilon);

P122 = P69 * cot(Delta_1);
P123 = (cot(Delta_1)^2 - P122) / (1+P122);
P124 = (1 + P123 * P67)/cos(Epsilon);
P125 = P102 * P124;
P126 = R_g - cos(Delta_1) * (h + a_G);
%%%%
B = cos(Epsilon)*P126 + P74*P125;

P128 = h * (1-u^(-1));
P129 = B - P125*F;

B_0_dot = B + sin(Epsilon)*P128;

B_0 = ceil(B_0_dot/(0.127/1e3)) * (0.127/1e3);

B_l_dot = P129 - sin(Epsilon)*P128;
B_l = ceil(B_l_dot/(0.127/1e3)) * (0.127/1e3);

P134 = G_0 + B_0;

d_0 = P119 * P134*2;

P136 = P70 * cos(Delta_0) / sin(Delta_0) + R_g;

Epsilon_0 = asin(hypoid_ex / P136);
% degrees2dms(Epsilon_0*180/pi)
% test(137,:) = degrees2dms(Epsilon_0*180/pi);
% fprintf('Параметр №137=  %f %f %f \n',test(137,:))

P140 = (sin(Delta_0) * Z_0 + c) / cos(Delta_0);
G_R = (hypoid_ex * sin(Epsilon_0) - P140)/ cos(Epsilon_0);

gamma_R = asin(cos(Delta_0)*cos(Epsilon_0));
% degrees2dms(gamma_R*180/pi)
% test(143,:) = degrees2dms(gamma_R*180/pi);
% fprintf('Параметр №137=  %f %f %f \n',test(143,:))
%%%%% Модуль внешний торцевой для колеса
m_et = D_e2 / N_kol;

B_min_mass = [0.025, 0.051, 0.102, 0.152, 0.203, 0.305, 0.508];
B_max_mass = [0.076,  0.102, 0.152, 0.203, 0.279, 0.460, 0.762];
m_e_mass = [1.270, 2.540, 4.233, 6.350, 8.466, 12.7, 25.4];

if m_et < min(m_e_mass )
   B_min =  0.025;
   B_max = 0.076;
else
    B_min = inteterp1(m_e_mass, B_min_mass, m_et );
    B_max = inteterp1(m_e_mass, B_max_mass, m_et );
end
    
P148 = sin(alpha_G) + sin(Delta_G);
P149 = h_t_G - F*P148;
A_l = A0 - F;

%%%% Определение рабочей высоты шестерни P224, 225
delta_dot = gamma_0 - gamma_R;
% degrees2dms(delta_dot*180/pi)
h_t_P = P134 * sin(delta_dot) / P118 - sin(gamma_R) *(G_R - G_0);
%%%%% Предполагаемая глубина цементованного слоя по модулю
[Cement] = cement_modul_f(m_et*1e3)

%% Часть с выводом нужных параметров в файл
%  Проверяем, существует ли файл, и если да — удаляем его
if exist(Name, 'file')
    delete(Name);
end
diary(Name);
fprintf('------Параметры гипоидной передачи------------ \n');
fprintf('---Все параметры если не указано отдельно в мм---- \n');
fprintf('----------------------Ведущая -------- Ведомая \n');
fprintf('\n-------------ИСХОДНОЗАДАННЫЕ ПАРАМЕТРЫ-------- \n \n');

%%%%% 1. Открываем файл на запись (или создаем новый)


%%%%% 2. Выводим данные, используя идентификатор файла (fileID)
fprintf('Число зубьев \t\t\t %.3f  %.3f \n',...
    n_sh , N_kol);

%%%%% 
fprintf('Торцевой модуль  \t\t %.3s \t %.4f\n колеса \n',...
    "---",  m_et*1e3);
%%%%% 
fprintf('Глубина цементованного слоя  \t\t %.3s \t %.4f\n колеса \n',...
    "---",  Cement);

%%%%% 
fprintf('Гипоидное смещение \t\t %.3s \t %.4f\n',...
    "---",  hypoid_ex*1e3);

%%%%% 
fprintf('Ширина зк \t\t\t %.3s \t %.3f \n',...
    "---",  F*1e3);

%%%%% 
fprintf('Направление спирали\t\t %.3s \t %.10s \n',...
    "---",  "Не заданно");

%%%%% 
fprintf('Средний нормальный  \t\t %.3s \t %.4f \n угол зацепления \n',...
    "---",  Fi_l*180/pi/2);

%%%%% 
fprintf('Диаметр резцовой  \t\t %.3s \t %.4f\n головки  \n',...
    "---",  r_c_dot_f*1e3);

fprintf('\n-----Парметры получаемые в результате расчёта-------- \n \n');
 
%%%%% 
fprintf('Диаметр делительной \t\t %.3s \t %.4f \n',...
    "---",  D_e2*1e3);

%%%%% 
fprintf('Высота головки  \t \t %.4f \t %.4f\n зуба торец \n',...
    (h_0-a_0_G )*1e3,  a_0_G*1e3);

%%%%% 
fprintf('Высота ножки  \t \t\t %.4f  \t %.4f\n зуба торец \n',...
    ((h_t_P)-(h_0-a_0_G))*1e3,  b_0_G*1e3);

%%%%% 
fprintf('Высота головки  \t \t %.4f \t %.4f\n зуба центр \n',...
    (b_G-c)*1e3,  a_G*1e3);

%%%%% 
fprintf('Высота ножки  \t \t\t %.4f  \t %.4f\n зуба центр \n',...
    (a_G+c)*1e3,  b_G*1e3);

%%%%% 
fprintf('Зазор радиал  \t \t\t %.4f  \t %.4f\n зуба центр \n',...
    c*1e3,  c*1e3);

%%%%% 
fprintf('Рабочая высота  \t \t %.3f \t %.4f\n зуба торец \n',...
   (h_t_P-c)*1e3,  h_0*1e3);

%%%%% 
fprintf('Полная высота  \t\t\t %.4f \t %.4f\n зуба торец \n',...
     h_t_P*1e3,  h_t_G*1e3);

%%%%% 
fprintf('Диметр окружности \t \t %.3f %.4f\n вершин торец \n',...
    d_0*1e3,  D_0*1e3);

%%%%% 
fprintf('Расстояние от верш \t\t  %.4s %.4f\nделительного конуса до оси сопряжённой шестерни\n \n',...
    "---",  Z_0*1e3);

%%%%% 
fprintf('Расстояние от верш \t\t  %.4f %.4f\nкон впадин до оси сопряжённой шестерни\n\n',...
    G_0*1e3,  Z_R*1e3);


%%%%% 
fprintf('Расстояние от наруж \t\t  %.4f %.4f\n кромки венца до оси сопряжённой шестерни\n\n',...
   B_0*1e3,  X_0*1e3);

%%%%% 
fprintf('Расстояние от внутренней \t %.4f  %.4s\n кромки венца до оси сопряжённой шестерни\n\n',...
   B_l*1e3,  "---");

%%%%% 
fprintf('Угол делительного \t\t  %.4s %.4f\n конуса\n',...
   "---",  Delta_1*180/pi);

%%%%% 
fprintf('Угол конуса выступов \t\t  %.4f %.4f\n',...
   gamma_0*180/pi,  Delta_0*180/pi);

%%%%% 
fprintf('Угол конуса впадин \t\t  %.4f %.4f\n',...
   gamma_R*180/pi,  Delta_R*180/pi);

%%%%% 
fprintf('Угол спирали \t\t\t  %.4f %.4f\n в среднем сечении \n',...
   Psi_P_1*180/pi,  Psi_G_1*180/pi);

%%%%% 
fprintf('Длина образующей \t\t\t  %.4f %.4f\n делительного конуса\n',...
   A0*1e3,  A0*1e3);

%%%%% 
fprintf('Допуски \t\t\t  %.4f %.4f \n',...
   B_min,  B_max);

% 3. Закрываем файл (обязательно, иначе данные могут потеряться)
diary off;

% function [] = disp_t(t,n)
% fprintf('Парамтер № %d равен %f \n',n,t(n))
% end
% 
% function [] = disp_k(t,k)
% fprintf('Парамтер № %d равен %f \n',k,t*10^(k))
% end
move_file_to_named_folder(Name, "Hypoid_setrakov_funktion_variant")
end