function [A_tot, x_vector] = readValuesFromCSVAndEvaluateAvailability(filepath, configuration, parameter_string, unit_string, reference_index,limit)
    arguments
        filepath string
        configuration (3,1) double
        parameter_string string
        unit_string string
        reference_index double
        limit double = 0.99999
    end

    % Leggi file CSV e salva dati in una matrice
    matrix = readmatrix(filepath);

    % Estrazione dei vettori colonne delle disponibilità singole e calcolo
    % della disponibilità della catena
    x_vector = matrix(:,1);

    A_IH_vector = matrix(:,end);
    A_IH_redundant_vector = arrayfun(@(x) RBD.RBDRedundant(x,configuration(3)), A_IH_vector);
    if size(matrix,2) == 3
        A_PS_vector = matrix(:,2);
        A_P_redundant_vector = arrayfun(@(x) RBD.RBDRedundant(x,configuration(1)), A_PS_vector);
        A_S_redundant_vector = arrayfun(@(x) RBD.RBDRedundant(x,configuration(2)), A_PS_vector);
    elseif size(matrix,2) == 4
        A_P_vector = matrix(:,2);
        A_S_vector = matrix(:,3);
        A_P_redundant_vector = arrayfun(@(x) RBD.RBDRedundant(x,configuration(1)), A_P_vector);
        A_S_redundant_vector = arrayfun(@(x) RBD.RBDRedundant(x,configuration(2)), A_S_vector);
    else
        error('Numero di colonne non valido');
    end

    % Calcolo della serie
    A_tot = arrayfun(@(row) RBD.RBDSeries(A_IH_redundant_vector(row), A_P_redundant_vector(row), A_S_redundant_vector(row)), 1:length(x_vector));

    % Plot del grafico
    titletext = strcat("Sensitivity analysis for ", parameter_string);

    figure;
    plot(x_vector, A_tot, 'o-');
    hold on;
    plot([x_vector(1) x_vector(end)], [limit limit], 'y--');
    plot(x_vector(reference_index), A_tot(reference_index), 'ro');
    hold off;
    title(titletext, 'Interpreter','latex');
    legend({"$A_{\mathrm{IMS}}$", "Limit"}, 'Interpreter', 'latex');
    xlim([x_vector(1) x_vector(end)]);
    ylabel('$A_{\mathrm{IMS}}$', 'Interpreter', 'latex');
    xlabel(strcat(parameter_string, " [", unit_string, "]"), 'Interpreter','latex');
end