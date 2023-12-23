function [k_vector, T_tot] = qnosGetWorkingConfiguration(P, lambda, S, T_tot_limit, k_vector_init)

  n_nodes = length(P(1,:));
  k_vector = k_vector_init;
  T_tot = +Inf;

  while (T_tot > T_tot_limit)

    try

      V = qnosvisits(P,lambda);
      [U, R, Q, X] = qnos(lambda(1), S, V, k_vector);
      T_tot = (1/lambda(1)) * sum(Q);

      if (T_tot > T_tot_limit)

        % retrieve the node with the maximum load factor
        maxU, maxU_index = max(U);

        % increase the node with the maximum load factor
        k_vector(maxU_index) = k_vector(maxU_index) + 1;

      endif

    catch err

      lastNumber = sscanf(err.message, 'Processing capacity exceeded at center %d');
      k_vector(lastNumber) = k_vector(lastNumber) + 1;

    end_try_catch

  endwhile

end
