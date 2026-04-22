function [x_down, x_up] = Limited_graf(x_massiv, bar);

if bar ==   0

minimal     =   min( x_massiv ,[], 'all', 'omitnan');

maximum     =   max( x_massiv ,[], 'all', 'omitnan'); 

tall = ( maximum - minimal ) /50; 

x_down  =   minimal - tall; 

x_up    =   maximum + tall;  

end

if bar ==  1

minimal     =   min( x_massiv ,[], 'all', 'omitnan');

maximum     =   max( x_massiv ,[], 'all', 'omitnan'); 

tall = ( maximum - minimal ) /50; 

x_down  =   0 - tall; 

x_up    =   maximum + tall;  

end


end
