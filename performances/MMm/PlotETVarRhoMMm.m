function [rho_values,E_N_values,E_T_values,E_W_values] = PlotETVarRhoMMm(m,lambda,mu)
%PLOTETVARLAMBDAMMM Summary of this function goes here
%   Detailed explanation goes here
rho_values = linspace(0.1, 1, 10);  

E_N_values = zeros(size(rho_values));
E_T_values = zeros(size(rho_values));
E_W_values = zeros(size(rho_values));

for i = 1:length(rho_values)

    rho = rho_values(i);

    pi_0 =  Pi0(m,rho);
    P_block = PBlock(pi_0, m, rho);
    
    E_NQ = ExpectedNumberOfRequestsInQueue(P_block, rho);
    E_W = ExpectedWaitingTimeMMm(E_NQ, lambda);
    E_T = ExpectedResponseTimeMMm(E_W, mu);
    E_N = ExpectedNumberOfRequestsMMm(lambda, E_T);

    E_W_values(i) = E_W;
    E_T_values(i) = E_T;
    E_N_values(i) = E_N;

end
end

