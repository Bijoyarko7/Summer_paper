function [Phi, Phix, Phixx, phii, x22] = CapRequirement(x1,x2,coeff,K,u_v,x)

global lambda xmin xmax
 
N = size(x,1);

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2; 

% v and its derivatives
[v,vx,vxx] = FF(u_v,x);

% Constants
c = zeros(1,K+1);
if K > 5
    c(7:end) = coeff;
end    

c(1) = lambda*v(x1); c(2) = lambda*vx(x1)*(x(x2)-x(x1));

if K == 1   
    c(2) = 1/x(x2) - c(1);
elseif K == 3
    c(3) = 3*(1/x(x2)-c(2)-c(1)) + (x(x2)-x(x1))/x(x2)^2 + c(2);
    c(4) = -(x(x2)-x(x1))/x(x2)^2 - c(2) -2*(1/x(x2) - c(2) - c(1));
elseif K  == 5
    c(3) = .5*lambda*vxx(x1)*(x(x2)-x(x1))^2;
    A = [10 6 3; 5 4 3; 1 1 1];
    B = [(x(x2)-x(x1))^2/x(x2)^3 - c(3);-(x(x2)-x(x1))/x(x2)^2 - 2*c(3) - c(2); 1/x(x2) - c(3) - c(2) - c(1)];
    sol = linsolve(A,B);
    c(6) = sol(1); c(5) = sol(2); c(4) = sol(3);
elseif K  > 5
    c(3) = .5*lambda*vxx(x1)*(x(x2)-x(x1))^2;
    A = [10 6 3; 5 4 3; 1 1 1];
    B = [(x(x2)-x(x1))^2/x(x2)^3 - sum((6:K).*(5:K-1).*c(7:K+1)) - c(3);
        -(x(x2)-x(x1))/x(x2)^2 - sum((6:K).*c(7:K+1)) - 2*c(3) - c(2);
        1/x(x2) - sum(c(7:end)) - c(3) - c(2) - c(1)];
    sol = linsolve(A,B);
    c(6) = sol(1); c(5) = sol(2); c(4) = sol(3);
end    

% Capital requirement and its derivative
cx = (1:K).*c(2:K+1);
cxx = (2:K).*(1:K-1).*c(3:K+1);

Phi = 0*x; Phix = 0*x; Phixx = 0*x; 
for i_x = 1:N
    Phi(i_x)   = sum(c.*(x(i_x)-x(x1)).^(0:K)./(x(x2)-x(x1)).^(0:K));
    Phix(i_x)  = sum(cx.*(x(i_x)-x(x1)).^(0:K-1)./(x(x2)-x(x1)).^(1:K));
    Phixx(i_x) = sum(cxx.*(x(i_x)-x(x1)).^(0:K-2)./(x(x2)-x(x1)).^(2:K));
end

phii = min([Phi lambda*v 1./x],[],2);

% Verify that capital requirement is below the natural upper bound
if Phi(x1+1:x2-1) <= min(lambda*v(x1+1:x2-1),1./x(x1+1:x2-1))
    x22 = x2;    
else
    x22 = find(Phi(x1+1:x2-1) > min(lambda*v(x1+1:x2-1),1./x(x1+1:x2-1)),1,'first');
    x22 = x1+1+x22; 
    [Phi, Phix, Phixx, phii, x22] = CapRequirement(x1,x22,coeff,K,u_v,x);  
end 
    
end