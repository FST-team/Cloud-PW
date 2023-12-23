clear all
clc

% Definizione della matrice di probabilità di routing
P = [ 0 1 0 0 ; 0 0 1 0; 0 0 0 1; 0 0 0 0];

%Numero di server per ogni nodo
m = [1 1 5 1];

%Tempi medi di servizio per ogni nodo
S = [0.0011 0.0072 0.041 0.0046];

%Tassi di arrivo ad ogni nodo
lambda = [100 0 0 0 ];

%Calcolo del numero di visite medio per nodo
V = qnosvisits(P, lambda);

%Calcolo delle metriche di prestazione del sistema
[U, R, Q, X] = qnos(lambda(1), S, V, m);


%Per analizzare il carico dei nodi usare i fattori di carico
display("Fattori di carico")
U;

% Calcolo del tempo medio totale utilizzando il Teorema di Little
display("Total avg. time:")
T = (1/lambda(1))*sum(Q)


