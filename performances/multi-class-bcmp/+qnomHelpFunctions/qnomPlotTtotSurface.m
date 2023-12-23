function [T_tot_experiments, lambda_ext_pcscf_class1_experiments, lambda_ext_pcscf_class2_experiments] = qnomPlotTtotSurface(P, S, m_vector, T_limit)
  arguments
    P (2,:,2,:) double
    S (2,:) double
    m_vector (:,1) double
    T_limit (1) double
  end

  %Definizione del numero di classi e di nodi della rete
  C = 2;
  K = length(S(end,:));

  % Calcolo del tempo di risposta complessio del servizio per le due classi
  T_tot_func = @(Q, lambda_ext_vector) qnomHelpFunctions.qnomTtot(Q, lambda_ext_vector);

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
  legend('Classe 1', 'Classe 2', 'Upper Bound ($E[T] = 200ms$)','Interpreter','latex');
  xlabel('\lambda_{1(1)} [req/s]');
  ylabel('\lambda_{1(2)} [req/s]');
  zlabel('E[T] [sec]');
  %xlim(xlim_vector);
  zlim([0 T_limit]);
end
