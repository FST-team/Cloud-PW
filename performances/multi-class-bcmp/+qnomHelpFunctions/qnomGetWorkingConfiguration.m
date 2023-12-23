function m_vector = qnomGetWorkingConfiguration(P, lambda_ext_matrix, S, T_tot_limit_vector, m_vector_init)
  arguments
    P (:,:,:,:) double
    lambda_ext_matrix (:,:) double
    S (:,:)
    T_tot_limit_vector (:,1) double
    m_vector_init (:,1) double
  end
  % Recupero numero di nodi della rete
  n_nodes = length(P(1,:,1,:));

  % Calcolo del vettore dei tassi esterni
  lambda_ext_vector = sum(lambda_ext_matrix,2)';

  % Calcolo del tempo di risposta complessio del servizio per le due classi
  T_tot_func = @(Q, lambda_ext_vector) qnomHelpFunctions.qnomTtot(Q, lambda_ext_vector);

  m_vector = m_vector_init;
  T_tot_vector = [+Inf +Inf]';
  while any(T_tot_vector > T_tot_limit_vector)
    try
      % Calcolo del vettore di visite per la rete multi-class open
      V = qnomvisits(P, lambda_ext_matrix);

      % Analisi della rete
      [U,R,Q,X] = qnom(lambda_ext_vector, S, V, m_vector);

      % Calcolo del tempo medio per ogni classe
      T_tot_vector = T_tot_func(Q, lambda_ext_vector');

      % Verifica che le classi abbiano dei tempi totali medi al di sotto del
      % vincolo fornito
      if any(T_tot_vector > T_tot_limit_vector)

        % Recupero dei nodi della rete con il fattore di carico U più alto per
        % ciascuna classe ed aumento del numero di server per ogni nodo trovato
        [maxU_class1, maxU_class1_index] = max(U(1,:));
        [maxU_class2, maxU_class2_index] = max(U(2,:));

        if maxU_class1_index == maxU_class2_index
          m_vector(maxU_class1_index) = m_vector(maxU_class1_index) + 1;
        else
          m_vector(maxU_class1_index) = m_vector(maxU_class1_index) + 1;
          m_vector(maxU_class2_index) = m_vector(maxU_class2_index) + 1;
        endif
      endif


    catch err
      lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
      m_vector(lastNumber) = m_vector(lastNumber) + 1;
      T_tot_vector = [+Inf +Inf]';
    end_try_catch
    display('Nuovo vettore M:');
    m_vector
    display('Nuovo vettore dei tempi totali medi:');
    T_tot_vector
  end
end
