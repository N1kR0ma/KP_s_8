% % % % Calculation of rolling resistance force
function P_f = Soprotivlenie(alpha,v,m)
    global k_f f g 

        f_a = f * (1 + k_f * v.*v);
        f_0 = f_a.*cos(alpha) + sin(alpha);
        P_f = f_0 * m * g;

end
