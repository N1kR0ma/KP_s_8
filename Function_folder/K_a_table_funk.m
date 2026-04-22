function K_a = K_a_table_funk(u_real)
U = u_real;
Mass_diap = [1, 1.02, 1.04, 1.05, 1.07, 1.08, 1.10, 1.12, 1.14, 1.16, 1.18, 1.21,...
    1.23, 1.26, 1.28,1.31, 1.35, 1.38, 1.42, 1.46, 1.50,1.55 1.60,1.66,1.73,1.80,1.89...
    1.99,2.10,2.25, 2.42,2.64,2.93,3.34,4,5.32,11.08];

if U < 1
   disp('Некорректное передаточное число') 
   K_a = 1
   return
end

if U == 1 
    K_a = 0.8;
else
   for i = 1: length(Mass_diap)-1
      if (U> Mass_diap(i)) && (U<= Mass_diap(i+1))
          K_a = 0.8-0.01*i;
           break
      end
   end
end

end

