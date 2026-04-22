function [Z_1, Z_2,u_r] = teeth_u_function(u, Z_1_min, Z_1_max)
%%%% Массив чисел зубьев для ведущей шестерни
Z_1_mass = Z_1_min:1:Z_1_max;
%%%% Определение числа зубьев ведомой шестерни
Z_2_mass = ceil(Z_1_mass * u);
%%%% Определение рельных передаточных чисел
u_real = Z_2_mass  ./ Z_1_mass;

i = 0;
while length(u_real) > i
   i = i + 1;
   if  (u_real(1,i) - u)/u > 3e-2
       u_real(i) = [];
       Z_1_mass(i) = [];
       Z_2_mass(i) = [];
       if i ~= 1
            i = i - 1;
       end
   end
end
Z_1  = Z_1_mass;
Z_2  = Z_2_mass;
u_r = u_real;
end

