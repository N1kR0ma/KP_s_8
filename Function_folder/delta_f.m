% % % % Calculation delta

function delta = delta_f(u_tr, h_tr, m)
global J_dv n_0 J_kol r0
   delta = 1 + (J_dv * u_tr .* u_tr  * h_tr + n_0 * J_kol) / (m*r0*r0);
end
