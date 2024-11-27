% Задаем ранги критериев
ranks = [1, 2, 3, 4, 5, 6];
n = length(ranks);

% Матрица парных сравнений для мощности
matrix_power = [1,   3,   6,  4,  2,   5,  
               1/3,  1,  1/3, 5, 1/2, 1/2, 
               1/6,  3,   1,  6, 1/4, 1/2,  
               1/4, 1/5, 1/6, 1, 1/2, 1/3, 
               1/2,  2,   4,  2,  1,   5, 
               1/5,  2,   2,  3, 1/5,  1];

% Матрица парных сравнений для крутящего момента
matrix_torque = [1,   2,   3,   2,   1,   3;
                1/2,  1,  1/3, 1/2, 1/4, 1/3; 
                1/3,  3,   1,   2,  1/5, 1/2;  
                1/2,  2,  1/2,  1,  1/2, 1/3; 
                 1,   4,   5,   2,   1,   5; 
                1/3,  3,   2,   3,  1/5,  1
];

% Матрица парных сравнений для массы (меньшая масса предпочтительнее)
matrix_mass = [1,   3,   4,   2,   2,   5;
              1/3,  1,  1/2, 1/4, 1/2, 1/3; 
              1/4,  2,   1,  1/3, 1/2, 1/2;  
              1/2,  4,   3,   1,   1,   2; 
              1/2,  2,   2,   1,   1,   4; 
              1/5,  3,   2,  1/2, 1/4,  1
];

% Вычисление весов для каждой альтернативы
weights_power = calculate_weights(matrix_power);
weights_torque = calculate_weights(matrix_torque);
weights_mass = calculate_weights(matrix_mass);
disp('Мощность:'); disp(weights_power);
disp('Крутящий момент:'); disp(weights_torque);
disp('Масса:'); disp(weights_mass);

final_scores = zeros(n, 1);
for i = 1 : n
    final_scores(i) = ...
        weights_power(i) + ... 
        weights_torque(i) + ... 
        weights_mass(i);
end

disp("Оценка каждого двигателя:"); disp(final_scores);

[max_score, best] = max(final_scores);
fprintf('Оптимальный вариант: Двигатель %d с весом: %.4f\n', best, max_score);

figure;
bar(final_scores);
xlabel('Варианты двигателей');
ylabel('Итоговый вес');
title('Итоговые веса вариантов двигателей');
xticklabels({'Двигатель 1', 'Двигатель 2', 'Двигатель 3', 'Двигатель 4', 'Двигатель 5', 'Двигатель 6'});
grid on;

% Функция для вычисления весов из матрицы парных сравнений
function [normalized_weights] = calculate_weights(matrix)
    n = size(matrix, 1);
    row_products = prod(matrix, 2);
    row_n_products = nthroot(row_products, n);
    total_sum = sum(row_n_products);
    normalized_weights = row_n_products / total_sum;
end

