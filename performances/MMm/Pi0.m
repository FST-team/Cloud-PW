function [pi_0] = Pi0(m,rho)
%PI0 Summary of this function goes here
%   Detailed explanation goes here
pi_0 = 0;
for i = 0:(m-1)
    pi_0 = pi_0 + (((m*rho)^i)/factorial(i));
end

pi_0 = 1/(pi_0 + (((m*rho)^m)/factorial(m))*(1/(1-rho)));
end

