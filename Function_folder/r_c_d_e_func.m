function [r_c] = r_c_d_e_func(D_e)
D_e = D_e *10^3;
switch true
    case D_e > 127 && D_e <165.1
        r_c = 76.2;
    case D_e > 165.1 && D_e < 215.9
        r_c = 95.25;
   case D_e > 203.2 && D_e < 279.4
        r_c = 114.3;
    case D_e > 226.7 && D_e < 381
        r_c = 152.4;
    case D_e > 368.3 && D_e < 482.6
        r_c = 203.2;
    case D_e < 127 | D_e > 482.6
        disp('Колесо или слишком большое или слишком малое')
        D_e
end

r_c = r_c/10^3;

end

