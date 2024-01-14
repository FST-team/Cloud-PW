function qnosPlotTtot(P, max_lambda, min_lambda, S, V, k, title_str)

  lambdas = linspace(min_lambda, max_lambda, max_lambda-min_lambda);

  for i = 1:(max_lambda-min_lambda)
    [U, R, Q, X] = qnos(lambdas(i), S, V, k);
    T_values(i) = (1/lambdas(i)) * sum(Q);
  end

  figure;
  plot(lambdas, T_values, '-o');
  xlabel('\lambda_{ext} [s^{-1}]');
  ylabel('E[T] [s]');
  title(title_str);

end
