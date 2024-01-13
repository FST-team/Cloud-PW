% Definizione della matrice di probabilità di routing
P = [0 1 0 0; 0 0 1 0; 0 0 0 1; 0 0 0 0];

% Numero di container iniziale per ogni nodo
m_initial = [1 1 5 1];

% Tempi medi di servizio per ogni nodo
S = [0.0011 0.0072 0.041 0.0046];

% Tasso di arrivo al primo nodo
lambda = [100 0 0 0];

%Requisito di prestazione
T_lim = 0.2;

%Calcolo del numero di visite medio per nodo
V = qnosvisits(P, lambda);

%Calcolo delle metriche di prestazione del sistema
[U, R, Q, X] = qnos(lambda(1), S, V, m_initial);

T0 = (1/lambda(1)) * sum(Q);

% Inizializzazione dei vettori per il grafico
num_container = 0:1:6;  % Inizia da 0 per includere T0
T_values = zeros(size(num_container));

% Grafico del tempo medio di risposta al variare del numero di container
figure;

m_updated = m_initial;

for idx = 1:length(num_container)
    % Aumenta di un server alla volta il nodo più carico
    [~, idx_max_U] = max(U);
    m_updated(idx_max_U) = m_updated(idx_max_U) + 1;
    m_updated

    % Calcola le metriche di prestazione
    [U, R, Q, X] = qnos(lambda(1), S, V, m_updated);
    T_values(idx) = (1/lambda(1)) * sum(Q)

    % Visualizza il valore U per il nodo più carico
    disp(['Numero di container per il nodo più carico (', num2str(idx_max_U), '): ', num2str(m_updated(idx_max_U))]);
end

% Grafico del tempo medio di risposta al variare del numero di container
plot(num_container, [T0, T_values(1:6)], 'o-');
xlabel('Numero di container aggiunti complessivamente');
ylabel('E[T]');
title('Andamento di E[T] al variare del numero di container');