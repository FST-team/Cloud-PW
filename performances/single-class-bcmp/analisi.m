clear
clc
close all

% Definizione della matrice di probabilità di routing
P = [0 1 0 0; 0 0 1 0; 0 0 0 1; 0 0 0 0];

% Numero di server iniziale per ogni nodo
m_initial = [1 1 5 1];

% Tempi medi di servizio per ogni nodo
S = [0.0011 0.0072 0.041 0.0046];

% Tasso di arrivo al primo nodo
lambda = [100 0 0 0];

% Calcola il tempo medio di risposta iniziale (T0)
T0 = calculateT(P, lambda, m_initial, S);

% Variare il numero di server per ogni nodo e calcolare T
num_servers = [0, 1:5];  % Aggiungi 0 al vettore per rappresentare T0
T_values = zeros(size(num_servers));

for i = 1:length(num_servers)
    % Aumenta il numero di server per ogni nodo
    m_updated = m_initial
    m_updated(3) = m_initial(3) + num_servers(i);

    % Calcola il tempo medio di risposta
    T_values(i) = calculateT(P, lambda, m_updated, S);
end

% Grafico del tempo medio di risposta al variare del numero di server
plot(num_servers, T_values, 'o-');
xlabel('Numero di server aggiunti per ogni nodo');
ylabel('Tempo medio di risposta (T)');
title('Variazione di T al variare del numero di server per ogni nodo');
legend('Tempo medio di risposta', 'Location', 'Best');



