%% Evaluate the performance (T) of the following single class queueing network
% NB: add MMm folder to path

lambda1 = 100; 

mu1 = 1/0.0011;
mu2 = 1/0.0072;
mu3 = 1/0.041;
mu4 = 1/0.0046;

p12 = 1;
p23 = 1;
p34 = 1;

tot_nodes = 4;

%% Step 1. Compute the arrival rates.
syms lambda2 lambda3 lambda4

% Let's write the traffic's equations
eq2 = lambda2 == lambda1*p12;
eq3 = lambda3 == lambda2*p23;
eq4 = lambda4 == lambda3*p34;

[l2, l3, l4] = solve([eq2, eq3, eq4], [lambda2, lambda3, lambda4])

%% Step 2. Compute the metrics for each node.

lambdas = [lambda1, double(l2), double(l3), double(l4)]
mus = [mu1, mu2, mu3, mu4]
ms = [1,1,5,1];
rhos = zeros(1,tot_nodes);
N = zeros(1,tot_nodes);
T = zeros(1,tot_nodes);

for i = 1:tot_nodes
    rho = TrafficIntensityMMm(lambdas(i), mus(i), ms(i));
    rhos(i) = rho;
    T(i) = ExpectedResponseTimeMMm(ExpectedWaitingTimeMMm(ExpectedNumberOfRequestsInQueue(PBlock(Pi0(ms(i),rho),ms(i),rho),rho),lambdas(i)),mus(i));
    N(i) = ExpectedNumberOfRequestsMMm(lambdas(i), T(i));
    
end

rhos
N
T

%% Step 3. Compute the overall expected response time (overall performance).

responseTime = 0;
for i = 1:tot_nodes
    responseTime =  responseTime + N(i);
end

responseTime = responseTime * 1/lambda1