function [hour]...              %%%% Суммарное число часов для автомобиля
    = Spectr_nagr(...
    L_0,...                     %%%% Суммарный пробег в км
    u_tr,...                    %%%% Передаточные числа в трансмисии
    u_kp,...                    %%%% Передаточные числа в КП
    u_rk,...                    %%%% Передаточные числа в РК      
    u_before,...                %%%% Передаточные числа от колёс до агрегата
    kpd_before ,...             %%%% КПД от колёс до агрегата
    kpd_tr,...                  %%%% Общий кпд в трансмиссии
    V_max,...                   %%%% Максимальная скорость
    r0,...                      %%%% Статический радиус колеса (можно и более точные)
    m_avt,...                   %%%% Полная масса автомобиля
    m_priz,...                  %%%% Масса прицепа
    m_os,...                    %%%% Масса на ведущих осях суммарная
    fi_asfalt,...                 %%%% Коэфиициент сцепления для опорной поверхности
    koef_srednei_skorosti,...   %%%% Отношение средней скорости к максимлаьной (0,6...0,65)
    M_max,...                   %%%% Максимальный крутящий момент на двигателе
    asim,...                    %%%% Если распределени нормальное 1
    c_x,...                     %%%% Коэффициент обтекаемости
    A,...                       %%%% Площадь лобовой проекции автомобиля
    p_psi,...                   %%%% Удельная сила тяги обусловленная сопротивлением дороги
    k_din,...                   %%%% Коэффициент динамичности
    tetta,...                   %%%% Коэффициент учитывающий увеличение крут момента из-за циркул
    k_a,...                    %%%% Коэффициент затрачиваемой удельной силы на разгон
    lambda,...                  %%%% Доля крутящего момента передаваемого валом
    sigma_lgp_real...          %%%% Коэффициент формы
    )

global g ro 







%%%% Переводим матрицу передаточных чисел в нужный формат
if size(u_tr,2) > size(u_tr,1)
 u_tr = u_tr';
    u_kp = u_kp';
end
    
% % % % %  
if length(u_rk)>=2
L_real = [0.95*L_0, 0.05*L_0];
else
L_real = [L_0];
end

% % % % %  Вычисление относительных пробегов автомобиля на каждой передачи
if size(u_rk,2) == 1
    otnositelni_probeg(1,:) = relative_runs_f(V_max, u_tr(:,1), asim)
else
    otnositelni_probeg(1,:) =...
         relative_runs_f(V_max, u_tr(:,1), 0);
    otnositelni_probeg(2,:) =...
         relative_runs_f(V_max, u_tr(:,2), 0);
end

% % % % %  Скорректированные относительные пробеги автомобиля
p_kv = [];
if size(u_rk,2) == 1
% % % % %  Нахождение удельной силы тяги на колёсах при высших передачах
p_kv =  (min(u_tr,[], 'all')* M_max * kpd_tr)/(m_avt+m_priz)/g/r0

% % % % %  Коэффициент тяги учитывающий влияение тягловых
Koef_korrekt_t = 0.711 + 0.032/p_kv

otnositelni_probeg = otnositelni_probeg * Koef_korrekt_t

otnositelni_probeg(length(otnositelni_probeg)+1) = ...
    1 - sum(otnositelni_probeg)

else
% % % % %  Нахождение удельной силы тяги на колёсах при высших передачах
p_kv(1,1) =  min(u_tr(1,:),[], 'all')* M_max * kpd_tr/(m_avt+m_priz)/g/r0;
p_kv(1,2) =  min(u_tr(2,:),[], 'all')* M_max * kpd_tr/(m_avt+m_priz)/g/r0;
% % % % %  Коэффициент тяги учитывающий влияение тягловых
Koef_korrekt_t(1,1) = 0.711 + 0.032/p_kv(1,1);
Koef_korrekt_t(1,2) = 0.711 + 0.032/p_kv(1,2);

otnositelni_probeg = otnositelni_probeg .* Koef_korrekt_t';

Pustota = size(otnositelni_probeg(1,:),2);
% % % % %  Относительные пробеги на высшей передаче
otnositelni_probeg(1, Pustota+1) = ...
    0.95 * (1 - sum(otnositelni_probeg(1,:)));
% % % % %  Относительные пробеги на низшей передаче
otnositelni_probeg(2, Pustota+1) = ...
    0.05 * (1 - sum(otnositelni_probeg(2,:)));
end

%%

% % % % %  Предельная удельную сила тяги обусловленной сцеплением вед колёс
p_fi = m_os * fi_asfalt / m_avt;

% % % % %  мометом двигателя 
p_dv = u_tr(:,1)* M_max * kpd_tr/m_avt/g/r0;

p_ki = min(p_dv, p_fi);

% % % % %  Средние значения удельных сил тяги сопротивления воздуха
speed = V_max *koef_srednei_skorosti * min(u_tr(u_tr>0.99)) * g_vel_f(u_tr);

% % % % %  Удельная сила тяги на преодоление воздушного сопротивления
p_w = Wozdux_2(speed', c_x,A) / m_avt / g

% % % % %  Средние удельные силы тягги затрачиваемые на разгон автомобиля
p_ai = k_a * (p_ki - p_psi - p_w);

% % % % %  Суммарная удельная сила тяги
p_kl = p_psi + p_w + p_ai;
 
% % % % %  Соотношение удельных сил тяги
p_ki_p_pkl = p_ki ./ p_kl;
p_ki_p_pkl = round(p_ki_p_pkl*20+2,-1)/20;


% % % % %  Таблица коэффициентов 
K_n_H(1,:) = [0.30, 0.240, 0.185, 0.138, 0.104, 0.087, 0.066...
    0.053, 0.042, 0.034, 0.027, 0.022, 0.018, 0.015, 0.012];

K_n_H(2,:) = [0.322, 0.267, 0.189, 0.129, 0.098, 0.076, 0.054...
    0.040, 0.030, 0.023, 0.018, 0.014, 0.012, 0.010, 0.008];

K_n_H(3,:) = [0.523, 0.319, 0.193, 0.118, 0.082, 0.060, 0.047...
    0.029, 0.021, 0.016, 0.012, 0.010, 0.008, 0.007, 0.006];

K_n_F(1,:) = [0.10, 0.0896, 0.0533, 0.0367, 0.027, 0.0176, 0.0123,...
    0.0088, 0.0069, 0.0047, 0.0035, 0.0025, 0.0019, 0.0014, 0.0011];

K_n_F(2,:) = [0.125, 0.0818, 0.0481, 0.0286, 0.0187, 0.0105, 0.0063,...
    0.00386, 0.00257, 0.00165, 0.00117, 0.00076,...
    0.00054, 0.00038, 0.00030];

K_n_F(3,:) = [0.0125, 0.0818, 0.039, 0.0202, 0.01 0.0051, 0.0025,...
    0.00125, 0.00059, 0.00033, 0.0002, 0.00011,...
    0.00006, 0.000034, 0.00002];

p_ki_p_pkl_0 = [1, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0,...
    6.5, 7.0, 7.5, 8.0];

sigma_lgp = [0.30, 0.25, 0.20];

for i = 1:size(sigma_lgp,2)

   if sigma_lgp_real == sigma_lgp (1,i)
        K_nF_real = interp1(p_ki_p_pkl_0, K_n_F(i,:), p_ki_p_pkl);
        K_nH_real = interp1(p_ki_p_pkl_0, K_n_H(i,:), p_ki_p_pkl);
   end

end

% % % % % Расчёт момента действующего в данном элементе трансмиссии
Torqe_real = lambda * m_avt * g * r0 * tetta * p_ki ...
    .* g_vel_f(u_before.*kpd_before) ;

% % % % %  Частота вращения вала в оборотах в минуту
n = 30/pi * u_before/r0 * speed;

% % % % %  Скорректированные нагрузки
T_max = k_din * Torqe_real;

%% Запись распределения нагрузок
fileID = fopen('Probeg.txt','w');
fprintf(fileID,'\n \n');
for i = 1:length(otnositelni_probeg) 
fprintf(fileID,'%f %f %f %f \n', otnositelni_probeg(i), Torqe_real(i), T_max(i), n(i));
end
fprintf(fileID,'\n \n');
type Probeg.txt

fclose(fileID);
i = linspace(1, length(u_kp),length(u_kp));
figure
hold on
subplot(3, 1, 1);
plot(i, Torqe_real);
xlabel('№ передачи')
ylabel('Действующий момент T_{k}, Н\cdotм')
subplot(3, 1, 2);
plot(i,n)
xlabel('№ передачи')
ylabel('Частота вращения w, об/мин' )
subplot(3, 1, 3);
plot(i,otnositelni_probeg);
xlabel('№ передачи')
ylabel('Относительный пробег \gamma')

hour = L_0 / (V_max*3.6 * koef_srednei_skorosti);

Probeg_first = zeros(length(n),4);
Probeg_first(:,1) = otnositelni_probeg;
Probeg_first(:,2) = Torqe_real;
Probeg_first(:,3) = T_max;
Probeg_first(:,4) = n;
writematrix(Probeg_first, 'Probeg_pinion.xlsx', 'WriteMode', 'replacefile');

Probeg_first = zeros(length(n),4);
Probeg_first(:,1) = otnositelni_probeg * hour;
Probeg_first(:,2) = Torqe_real;
Probeg_first(:,3) = T_max;
Probeg_first(:,4) = n;
writematrix(Probeg_first, 'Probeg_pinion_hour.xlsx', 'WriteMode', 'replacefile');

Probeg_second = zeros(length(n),4);
Probeg_second(:,1) = otnositelni_probeg;
Probeg_second(:,2) = Torqe_real * u_before;
Probeg_second(:,3) = T_max* u_before;
Probeg_second(:,4) = n/u_before;
writematrix(Probeg_second, 'Probeg_gear.xlsx', 'WriteMode', 'replacefile');

Probeg_second = zeros(length(n),4);
Probeg_second(:,1) = otnositelni_probeg * hour;
Probeg_second(:,2) = Torqe_real * u_before;
Probeg_second(:,3) = T_max* u_before;
Probeg_second(:,4) = n/u_before;
writematrix(Probeg_second, 'Probeg_gear_hour.xlsx', 'WriteMode', 'replacefile');



end

