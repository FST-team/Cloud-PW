%% Definizione dei parametri
% Definizione dei parametri del tempo medio di servizion
mean_service_time_pcscf_class1 = 1.1*10^-3;
mean_service_time_scscf_class1 = 7.2*10^-3;
mean_service_time_icscf_class1 = 4.1*10^-2;
mean_service_time_hss_class1 = 4.6*10^-3;


% Definizione dei parametri del tasso degli arrivi esterni per il P-CSCF
lambda_ext_pcscf_class1 = 100;

% Definizione del numero di server per nodo
m_pcscf = 1;
m_scscf = 1;
m_icscf = 5;
m_hss = 1;

K = 4; % Numero di nodi
C = 1; % Numero di classi

T_limit = 200*10^-3; % Tempo di session setup limite

%-------------------------------------------------------------------------------
%% Definizione della matrice di probabilità di routing
P = zeros(C,K,C,K);

P(1,:,1,:) = [0 1 0 0; 0 0 1 0; 0 0 0 1; 0 0 0 0];


%-------------------------------------------------------------------------------
%% Definizione dei vettori necessari per svolgere le operazioni
% Definizione del vettore dei server
m_vector = [m_pcscf m_scscf m_icscf m_hss];

% Definizione del vettore lambda_ext
lambda_ext_matrix = zeros(C,K);
lambda_ext_matrix(1,1) = lambda_ext_pcscf_class1;

% Definizione della matrice dei tempi di servizi medi
S = zeros(C,K);

S(:,1) = [mean_service_time_pcscf_class1];
S(:,2) = [mean_service_time_scscf_class1];
S(:,3) = [mean_service_time_icscf_class1];
S(:,4) = [mean_service_time_hss_class1];

% Calcolo del vettore di visite per una rete multi-class open
V = qnomvisits(P, lambda_ext_matrix);

%-------------------------------------------------------------------------------
% Calcolo del tempo di risposta complessio del servizio per le due classi

[U,R,Q,X] = qnom(sum(lambda_ext_matrix), S, V, m_vector);

T_tot = sum(Q,2)./sum(lambda_ext_matrix)



