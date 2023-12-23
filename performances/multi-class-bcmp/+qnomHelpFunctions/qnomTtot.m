function T_tot_vector = qnomTtot(Q,lambda_ext_vector)
  arguments
    Q (:,:) double
    lambda_ext_vector (1,:) double
  end
  T_tot_vector = sum(Q,2)./lambda_ext_vector;
end
