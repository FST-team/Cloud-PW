function [NQ] = ExpectedNumberOfRequestsInQueue(P_block,rho)
%EXPECTEDNUMBEROFREQUESTSINQUEUE Summary of this function goes here
%   Detailed explanation goes here
NQ = P_block * (rho / (1 - rho));
end

