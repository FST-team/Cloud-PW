function [P_block] = PBlock(pi_0, m , rho)
%PBLOCK Summary of this function goes here
%   Detailed explanation goes here
P_block = (pi_0*(rho*m)^m)/(factorial(m)*(1-rho));
end

