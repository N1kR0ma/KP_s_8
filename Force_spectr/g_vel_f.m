
function g_vel = g_vel_f(a)
    if size(a,1) < size(a,2)
          g_vel = ones(1, length(a)) ./ a; 
    else
          g_vel = ones(length(a), 1) ./ a; 
    end
    end