function [T_tot_experiments, lambda_ext_pcscf_class2_experiments] = qnomPlotTtotCurveFixedLambdaExtClass1(P, S, m_vector, T_limit, lambda_ext_pcscf_class1)
  arguments
    P (2,:,2,:) double
    S (2,:) double
    m_vector (:,1) double
    T_limit (1) double
    lambda_ext_pcscf_class1 (1) double
  end

  %Definizione del numero di classi e di nodi della rete
  C = 2;
  K = length(S(end,:));

  % Definizione dei vettori di supporto
  lambda_ext_pcscf_class2_experiments = 10:1:100;
  lambda_ext_pcscf_class2_num_experiments = length(lambda_ext_pcscf_class2_experiments);

  lambda_ext_vector_experiments = zeros(lambda_ext_pcscf_class2_num_experiments, C);
  T_tot_experiments = zeros(lambda_ext_pcscf_class2_num_experiments, C);

  for ii=1:lambda_ext_pcscf_class2_num_experiments

    % Definizione del nuovo vettore di lambda_ext
    lambda_ext_pcscf_class2_current_experiment = lambda_ext_pcscf_class2_experiments(ii);

    lambda_ext_matrix_current_experiment = zeros(C,K);
    lambda_ext_matrix_current_experiment(1,1) = lambda_ext_pcscf_class1;
    lambda_ext_matrix_current_experiment(2,1) = lambda_ext_pcscf_class2_current_experiment;
    lambda_ext_vector_experiments(ii,:) = sum(lambda_ext_matrix_current_experiment,2)';

    % Calcolo del vettore delle visite
    V = qnomvisits(P, lambda_ext_matrix_current_experiment);

    % Analisi della coda
    try
      [U,R,Q,X] = qnom(lambda_ext_vector_experiments(ii,:), S, V, m_vector);

      % Calcolo dei tempi complessivi per classe
      T_tot_experiments(ii,:) = qnomHelpFunctions.qnomTtot(Q, lambda_ext_vector_experiments(ii,:)');
    catch
      T_tot_experiments(ii,:) = [NaN, NaN];
    end_try_catch

  end

  % Plot del grafico
  figure;

  xlim_vector = [lambda_ext_pcscf_class2_experiments(1) lambda_ext_pcscf_class2_experiments(end)];

  plot(repmat(lambda_ext_pcscf_class2_experiments', 1,2), T_tot_experiments, '-o');
  hold on;
  plot(xlim_vector, [T_limit T_limit]);
  hold off;

  titletext = strcat('Tempo medio complessivo al variare di \lambda_{1(2)} con \lambda_{1(1)} = ', ...
    num2str(lambda_ext_pcscf_class1), ' (Configurazione m = [');
  for ii=1:K
    titletext = strcat(titletext, num2str(m_vector(ii)), ',');
  end
  titletext = strcat(titletext, '])');

  title(titletext);
  legend('Classe 1', 'Classe 2', 'Upper bound');
  xlabel('\lambda_{1(2)} [req/s]');
  ylabel('E[T] [s]');
  xlim(xlim_vector);
end
