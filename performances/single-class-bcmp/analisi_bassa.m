clear all
clc

%Analisi al variare di k con tasso di arrivo basso (20)

% Definizione della matrice di probabilità di routing
P = [0 1 0 0; 0 0 1 0; 0 0 0 1; 0 0 0 0];

% Numero di server iniziale per ogni nodo
m_initial = [1 1 1 1];

% Tempi medi di servizio per ogni nodo
S = [0.0011 0.0072 0.041 0.0046];

% Tasso di arrivo al primo nodo
lambda = [20 0 0 0];

%Requisito di prestazione
T_lim = 0.2;

%Calcolo del numero di visite medio per nodo
V = qnosvisits(P, lambda);

%Calcolo delle metriche di prestazione del sistema
[U, R, Q, X] = qnos(lambda(1), S, V, m_initial);

T0 = (1/lambda(1)) * sum(Q);

% Inizializzazione dei vettori per il grafico
num_servers = 0:1:6;  % Inizia da 0 per includere T0
T_values = zeros(size(num_servers));

% Grafico del tempo medio di risposta al variare del numero di server
figure;
hold on;

m_updated = m_initial;

for idx = 1:length(num_servers)
    % Aumenta di un server alla volta il nodo più carico
    [~, idx_max_U] = max(U);
    m_updated(idx_max_U) = m_updated(idx_max_U) + 1;
    m_updated

    % Calcola le metriche di prestazione
    [U, R, Q, X] = qnos(lambda(1), S, V, m_updated);
    T_values(idx) = (1/lambda(1)) * sum(Q)

    % Visualizza il valore U per il nodo più carico
    disp(['Numero di server per il nodo più carico (', num2str(idx_max_U), '): ', num2str(m_updated(idx_max_U))]);
end

% Grafico del tempo medio di risposta al variare del numero di server
plot(num_servers, [T0, T_values(1:6)], 'o-');
xlabel('Numero di server aggiunti');
ylabel('Tempo medio di risposta (T)');
title('Variazione di T al variare del numero di server');


% Aggiungi una linea orizzontale per il limite superiore
line([num_servers(1), num_servers(end)], [T_lim, T_lim], 'Color', 'r', 'LineStyle', '--', 'DisplayName', 'Limite superiore');

hold off;
