function [F,Fw,Fww,intF] = FF(aF,x)

global xmin xmax

N = size(aF,1);

m = (xmax-xmin)/2; % x == m*g + b
b = (xmax+xmin)/2;

w0 = (x-b)/m; %grid for collocation

[T0,T1,T2] = chebypol(w0,N-1);

F  = T0*aF;
if nargout>1
    Fw = (1/m)*(T1*aF);
    Fww = (1/m^2)*(T2*aF);
    if nargout>3
        idx = -(1+(-1).^(2:N-1))./((2:N-1).^2-1);
        intF = .5*[2 0 idx]*aF;
    end
end

end