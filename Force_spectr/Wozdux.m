
% Air resistance strength
function P_w = Wozdux(v)
global c_x A ro
P_w = c_x * A * ro * ( v.* v ) / 2;
end
