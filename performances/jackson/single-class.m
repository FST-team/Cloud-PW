%% Jackson for a single-class open network

% routing matrix
P = [0 1 0 0;
     0 0 1 0;
     0 0 0 1;
     0 0 0 0];

% lambda vector 100 req/s
lambda = [100 0 0 0];

% mean number of visists
V = qnosvisits(P,lambda);

k = [1 1 5 1]; % k at node 3 must be at least 5
S = [0.0011, 0.0072, 0.041, 0.0046];

[U, R, Q, X] = qnos(lambda(1), S, V, k);

display("Total avg. chain time:")
T = (1/lambda(1))*sum(Q)

%% TRAFFIC LOAD CONDITION ANALYSIS

% LOW - MEDIUM TRAFFIC (20-40)

T_values = [];

min_lambda = 20;
max_lambda = 40;

lambdas = linspace(min_lambda, max_lambda, max_lambda-min_lambda);

for i = 1:(max_lambda-min_lambda)
  [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  T_values(i) = (1/lambdas(i)) * sum(Q);
end

figure;
plot(lambdas, T_values, '-o');
xlabel('Traffic load (\lambda)');
ylabel('Total Average Chain Time (T)');
title('Low-medium traffic load');

% MEDIUM - HIGH TRAFFIC (60-80)

T_values = [];

min_lambda = 60;
max_lambda = 80;

lambdas = linspace(min_lambda, max_lambda, max_lambda-min_lambda);

for i = 1:(max_lambda-min_lambda)
  [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  T_values(i) = (1/lambdas(i)) * sum(Q);
end

figure;
plot(lambdas, T_values, '-o');
xlabel('Traffic load (\lambda)');
ylabel('Total Average Chain Time (T)');
title('Medium-high traffic load');

% LOW - MEDIUM TRAFFIC (20-40) OPTIMIZED CONFIGURATION
k = [1 1 1 1];

min_lambda = 20;
max_lambda = 40;

lambdas = linspace(min_lambda, max_lambda, max_lambda-min_lambda);

for i = 1:(max_lambda-min_lambda)
  try
    [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  catch err
    lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
    k(lastNumber) = k(lastNumber) + 1;
  end_try_catch

end

k

for i = 1:(max_lambda-min_lambda)
  [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  T_values(i) = (1/lambdas(i)) * sum(Q);
end

figure;
plot(lambdas, T_values, '-o');
xlabel('Traffic load (\lambda)');
ylabel('Total Average Chain Time (T)');
title('Low-medium traffic load with opt. conf.');


% MEDIUM - HIGH TRAFFIC (60-80) OPTIMIZED CONFIGURATION
k = [1 1 1 1];

min_lambda = 60;
max_lambda = 80;

lambdas = linspace(min_lambda, max_lambda, max_lambda-min_lambda);

for i = 1:(max_lambda-min_lambda)
  try
    [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  catch err
    lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
    k(lastNumber) = k(lastNumber) + 1;
  end_try_catch

end

k

for i = 1:(max_lambda-min_lambda)
  [U, R, Q, X] = qnos(lambdas(i), S, V, k);
  T_values(i) = (1/lambdas(i)) * sum(Q);
end

figure;
plot(lambdas, T_values, '-o');
xlabel('Traffic load (\lambda)');
ylabel('Total Average Chain Time (T)');
title('Medium-high traffic load');


