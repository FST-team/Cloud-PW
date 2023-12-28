function [k_vector, T_tot] = qnosGetWorkingConfigurationV2(P, lambda, S, T_tot_limit, k_vector_init)

  n_nodes = length(P(1,:));
  k_vector = k_vector_init;
  T_tot = +Inf;

  while (T_tot > T_tot_limit)

    try

      V = qnosvisits(P,lambda);
      [U, R, Q, X] = qnos(lambda(1), S, V, k_vector);
      T_tot = (1/lambda(1)) * sum(Q);

      if (T_tot > T_tot_limit)

        delta_cn = [];
        delta_Tn = [];

        for ii = 1:n_nodes
          temp_k = k_vector;
          temp_k(ii) = temp_k(ii) +1;
          [U, R, Q, X] = qnos(lambda(1), S, V, temp_k);
          delta_Tn(ii) = ((1/lambda(1)) * sum(Q)) - T_tot;
        endfor

        [min_delta_Tn, n] = min(delta_Tn)

        k_vector(n) = k_vector(n) + 1

      endif

    catch err

      lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
      k_vector(lastNumber) = k_vector(lastNumber) + 1;

    end_try_catch

  endwhile

end
