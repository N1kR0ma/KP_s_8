% Air resistance strength
function P_w = Wozdux_2(v,c_x, A )
global ro
P_w = c_x * A * ro * ( v .* v ) / 2;
end

