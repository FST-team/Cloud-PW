% Funzione per il calcolo del tempo medio di risposta in una rete di code single-class
% Input: matrice di routing(P), lambda esterno(array), numero di server(m), tempi di servizio(S)
% Output: tempo medio di risposta(T)

function T = calculateT(P, lambda, m, S)
    V = qnosvisits(P, lambda);

    lambda_ex = sum(lambda);

    [U, R, Q, X] = qnos(lambda_ex, S, V, m);


    T = (1/lambda_ex)*sum(Q);

end
