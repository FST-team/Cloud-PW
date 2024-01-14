%% Jackson for a single-class open network

% routing matrix
P = [0 1 0 0;
     0 0 1 0;
     0 0 0 1;
     0 0 0 0];

% lambda vector 100 req/s
lambda = [100 0 0 0];
k = [1 1 1 1];
S = [0.0011, 0.0072, 0.041, 0.0046];
T_max = 0.2;

[k, T] = qnosHelpFunctions.qnosGetWorkingConfigurationV2(P, lambda, S, T_max, k)
k = [1 1 1 1];
[k, T] = qnosHelpFunctions.qnosGetWorkingConfiguration(P, lambda, S, T_max, k)
display("Total avg. chain time:")
T

%% TRAFFIC LOAD CONDITION ANALYSIS

V = qnosvisits(P,lambda);

% LOW - MEDIUM TRAFFIC (20-40)

min_lambda = 20;
max_lambda = 40;
qnosHelpFunctions.qnosPlotTtot(P, max_lambda, min_lambda, S, V, k, 'Low-medium traffic load');

% MEDIUM - HIGH TRAFFIC (60-80)

min_lambda = 60;
max_lambda = 80;
qnosHelpFunctions.qnosPlotTtot(P, max_lambda, min_lambda, S, V, k, 'Medium-high traffic load');

% LOW - MEDIUM TRAFFIC (20-40) OPTIMIZED CONFIGURATION
min_lambda = 20;
max_lambda = 40;
k = [1 1 1 1];
[k, T] = qnosHelpFunctions.qnosGetWorkingConfiguration(P, [max_lambda 0 0 0], S, T_max, k)
qnosHelpFunctions.qnosPlotTtot(P, max_lambda, min_lambda, S, V, k, 'Low-medium traffic load');

% MEDIUM - HIGH TRAFFIC (60-80) OPTIMIZED CONFIGURATION
min_lambda = 60;
max_lambda = 80;
k = [1 1 1 1];
[k, T] = qnosHelpFunctions.qnosGetWorkingConfiguration(P, [max_lambda 0 0 0], S, T_max, k)
qnosHelpFunctions.qnosPlotTtot(P, max_lambda, min_lambda, S, V, k, 'Medium-high traffic load');


