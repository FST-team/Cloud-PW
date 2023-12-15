%% Definizione dei parametri
% Definizione dei parametri del tempo medio di servizion
mean_service_time_pcscf_class1 = 1.1*10^-3;
mean_service_time_scscf_class1 = 7.2*10^-3;
mean_service_time_icscf_class1 = 4.1*10^-2;
mean_service_time_hss_class1 = 4.6*10^-3;

mean_service_time_pcscf_class2 = mean_service_time_pcscf_class1 * 10;
mean_service_time_scscf_class2 = mean_service_time_scscf_class1 * 10;
mean_service_time_icscf_class2 = mean_service_time_icscf_class1 * 10;
mean_service_time_hss_class2 = mean_service_time_hss_class1 * 10;

% Definizione dei parametri del tasso degli arrivi esterni per il P-CSCF
lambda_ext_pcscf_class1 = 100;
lambda_ext_pcscf_class2 = 100;

% Definizione del numero di server per nodo
m_pcscf = 1;
m_scscf = 4;
m_icscf = 15;
m_hss = 3;

K = 4; % Numero di nodi
C = 2; % Numero di classi

T_limit = 200*10^-3; % Tempo di session setup limite

%-------------------------------------------------------------------------------
%% Definizione della matrice di probabilità di routing
% Si presuppone che non sia possibile effettuare il passaggio da una classe
% ad un'altra
P = zeros(C,K,C,K);

P(1,:,1,:) = [0 1 0 0; 0 0 1 0; 0 0 0 1; 0 0 0 0];
P(2,:,2,:) = P(1,:,1,:);

%-------------------------------------------------------------------------------
%% Definizione dei vettori necessari per svolgere le operazioni
% Definizione del vettore dei server
m_vector = [m_pcscf; m_scscf; m_icscf; m_hss];

% Definizione del vettore lambda_ext
lambda_ext_matrix = zeros(C,K);

lambda_ext_matrix(1,1) = lambda_ext_pcscf_class1;
lambda_ext_matrix(2,1) = lambda_ext_pcscf_class2;
lambda_ext_vector = sum(lambda_ext_matrix,2)'

% Definizione della matrice dei tempi di servizi medi
S = zeros(C,K);

S(:,1) = [mean_service_time_pcscf_class1; mean_service_time_pcscf_class2];
S(:,2) = [mean_service_time_scscf_class1; mean_service_time_scscf_class2];
S(:,3) = [mean_service_time_icscf_class1; mean_service_time_icscf_class2];
S(:,4) = [mean_service_time_hss_class1; mean_service_time_hss_class2];

% Calcolo del vettore di visite per una rete multi-class open
V = qnomvisits(P, lambda_ext_matrix);

%-------------------------------------------------------------------------------
% Calcolo del tempo di risposta complessio del servizio per le due classi
T_tot_func = @(Q, lambda_ext_vector) sum(Q,2)./lambda_ext_vector;

%-------------------------------------------------------------------------------
%%Plot del grafico del tempo complessivo al variare di lambda_ext_pcscf_class2
% e lambda_ext_pcscf_class1

% Definizione delle strutture d'appoggio
lambda_ext_pcscf_class1_experiments = 10:10:100;
lambda_ext_pcscf_class2_experiments = 10:10:100;
lambda_ext_pcscf_class1_num_experiments = length(lambda_ext_pcscf_class1_experiments);
lambda_ext_pcscf_class2_num_experiments = length(lambda_ext_pcscf_class2_experiments);

lambda_ext_vector_experiments = zeros(lambda_ext_pcscf_class1_num_experiments, ...
  lambda_ext_pcscf_class2_num_experiments, C);
T_tot_experiments = zeros(lambda_ext_pcscf_class1_num_experiments, ...
  lambda_ext_pcscf_class2_num_experiments, C);

% Esecuzione degli esperimenti
for ii=1:lambda_ext_pcscf_class1_num_experiments
  for jj=1:lambda_ext_pcscf_class2_num_experiments

    % Definizione del nuovo vettore di lambda
    lambda_ext_pcscf_class1_current_experiment = lambda_ext_pcscf_class1_experiments(ii);
    lambda_ext_pcscf_class2_current_experiment = lambda_ext_pcscf_class2_experiments(jj);

    lambda_ext_matrix_current_experiment = zeros(C,K);
    lambda_ext_matrix_current_experiment(1,1) = lambda_ext_pcscf_class1_current_experiment;
    lambda_ext_matrix_current_experiment(2,1) = lambda_ext_pcscf_class2_current_experiment;
    lambda_ext_vector_experiments(ii,jj,:) = sum(lambda_ext_matrix_current_experiment,2)';

    %Calcolo del vettore delle visite
    V = qnomvisits(P, lambda_ext_matrix_current_experiment);


    % Analisi della coda
    try
      [U,R,Q,X] = qnom(squeeze(lambda_ext_vector_experiments(ii,jj,:)), S, V, m_vector);

      % Calcolo dei tempi complessivi per classe
      T_tot_experiments(ii,jj,:) = T_tot_func(Q, squeeze(lambda_ext_vector_experiments(ii,jj,:)));
    catch
      T_tot_experiments(ii,jj,:) = [NaN, NaN];
    end_try_catch

  endfor
endfor

% Plot del grafico
upper_bound_surface = T_limit * ones(lambda_ext_pcscf_class1_num_experiments, lambda_ext_pcscf_class2_num_experiments);

figure(1);
surf(lambda_ext_pcscf_class1_experiments, lambda_ext_pcscf_class2_experiments, T_tot_experiments(:,:,1));
hold on;
surf(lambda_ext_pcscf_class1_experiments, lambda_ext_pcscf_class2_experiments, T_tot_experiments(:,:,2));
surf(lambda_ext_pcscf_class1_experiments, lambda_ext_pcscf_class2_experiments, ...
  upper_bound_surface, 'FaceAlpha', 0.5);
hold off;

titletext = strcat('Tempo medio complessivo al variare di \lambda_{1(1)} e \lambda_{1(2)} (Configurazione m = [');
for ii=1:K
  titletext = strcat(titletext, num2str(m_vector(ii)), ',');
end
titletext = strcat(titletext, '])');

title(titletext);
legend('Classe 1', 'Classe 2', 'Upper Bound (E[T] = 200ms)');
xlabel('\lambda_{1(1)} [req/s]');
ylabel('\lambda_{1(2)} [req/s]');
zlabel('E[T] [sec]');
xlim(xlim_vector);
