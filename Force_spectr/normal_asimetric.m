function N = normal_asimetric(v, a)
x = 0:max(v)
if a==0
    mu = 0.6 * max(v);
    sigma  = mu /3;
    N = cdf('Normal',x, mu, 2);
    else
    mu = 0.8 * max(v);
    sigma  = mu /3;
    N = cdf('Normal',x, mu, sigma)
    end
%  - OwenT((x-mu)/sigma, a);
figure
hold on
plot(x_0, l_3)
plot(x_0, l_2)

figure
hold on
plot(x_0, l_4)
plot(x_0, l_5)



function T = OwenT(h, a)
    integrand = @(x) exp(-0.5 * h^2 * (1 + x.^2)) ./ (1 + x.^2);
    T = (1 / (2 * pi)) * integral(integrand, 0, a);
end

end