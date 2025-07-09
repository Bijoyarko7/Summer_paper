function p_x = invdist(x,mu_x,sigma_x)

% Invariant density function
integrand = zeros(size(x,1),1);
integral  = zeros(size(x,1),1);

for i_x = 1:size(x,1)    
    if i_x == 1
        integrand(i_x) = (2*x(i_x)*mu_x(i_x)/(x(i_x)*sigma_x(i_x))^2)*x(i_x);
        integral(i_x)  = integrand(i_x);       
    else    
        integrand(i_x) = (2*x(i_x)*mu_x(i_x)/(x(i_x)*sigma_x(i_x))^2)*(x(i_x)-x(i_x-1));  
        integral(i_x)  = sum(integrand(1:i_x)); 
    end          
end   

p = exp(integral - max(integral))./(x.*sigma_x).^2;
 
int = zeros(size(x,1),1);
for i_x = 1:size(x,1)
    if i_x == 1 && p(i_x) > 0
        int(i_x) = p(i_x)*x(i_x);
    elseif i_x > 1  && p(i_x) > 0
        int(i_x) = p(i_x)*(x(i_x)-x(i_x-1));
    end
end

p_x = p/sum(int);

end