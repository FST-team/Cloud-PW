# Jackson for a single-class open netowrk

# routing matrix
P = [0 1 0 0;
     0 0 1 0;
     0 0 0 1;
     0 0 0 0];

# lambda vector 100 req/s
lambda = [100 0 0 0];

# mean number of visists
V = qnosvisits(P,lambda);

k = [1 1 5 1]; # k at node 3 must be at least 5
S = [0.0011, 0.0072, 0.041, 0.0046];

[U, R, Q, X] = qnos(lambda(1), S, V, k);

display("Total avg. chain time:")
T = (1/lambda(1))*sum(Q)

# we have to reach 200 ms -> 0.2 s
# 0.1035 s is the result

% TRAFFIC LOAD CONDITION ANALYSIS

T_values = [];
rho_values = [];

max_lambda = 0.5 * (k .* (1 ./ S));
max_lambda = ceil(max_lambda(1));

lambdas = linspace(1, max_lambda, max_lambda);

for i = 1:max_lambda(1)
  try
    [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  catch err
    lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
    k(lastNumber) = k(lastNumber) + 1;
  end_try_catch

end

k

for i = 1:max_lambda
  [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  T_values(i) = (1/lambdas(i)) * sum(Q);
  res = lambdas(i) * (1 ./ (k .* (1 ./ S)));
  rho_values(i) = res(1);
end

figure;
plot(rho_values, T_values, '-o');
xlabel('Traffic Intensity (\rho)');
ylabel('Total Average Chain Time (T)');
title('Traffic Load Condition Analysis');

T_values = [];
rho_values = [];
max_lambda = 1 * (k .* (1 ./ S));

lambdas = linspace(1, max_lambda(1), max_lambda(1));

for i = 1:max_lambda(1)
  try
    [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  catch err
    lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
    k(lastNumber) = k(lastNumber) + 1;
  end_try_catch

end

for i = 1:max_lambda(1)
  [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  T_values(i) = (1/lambdas(i)) * sum(Q);
  res = lambdas(i) * (1 ./ (k .* (1 ./ S)));
  rho_values(i) = res(1)+0.5;
end

k

figure;
plot(rho_values(1, :), T_values, '-o');
xlabel('Traffic Intensity (\rho)');
ylabel('Total Average Chain Time (T)');
title('Traffic Load Condition Analysis');

