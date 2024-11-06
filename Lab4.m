% Задаем ранги критериев
criteria = {'Качество зерна', 'Цена зерна', 'Транспортные расходы', 'Форма оплаты', 'Минимальная партия', 'Надежность поставки'};
ranks = [2, 1, 4, 5, 3, 6];

% Создание матрицы парных сравнений
n_criteria = length(criteria);
pair_matrix = ones(n_criteria);

for i = 1:n_criteria
    for j = i+1:n_criteria
        pair_matrix(i,j) = ranks(i) / ranks(j);
        pair_matrix(j,i) = ranks(j) / ranks(i);
    end
end

pair_matrix;

row_products = prod(pair_matrix, 2);
row_n_products = nthroot(row_products, n_criteria);
total_sum = sum(row_n_products);
normalized_weights = row_n_products / total_sum;

disp('Нахождение цен альтернатив: ');
for i = 1:size(row_n_products, 1)
    fprintf('C%d: %.4f\n', i, row_n_products(i));
end

fprintf('\nСумма цен альтернатив: %.4f\n\n', total_sum);

disp('Нахождение весов альтернатив:');
for i = 1:size(normalized_weights, 1)
    fprintf('%s: %.4f\n', criteria{i}, normalized_weights(i));
end

figure;
plot(normalized_weights); 
set(gca, 'XTick', 1:n_criteria, 'XTickLabel', criteria);
xlabel('Критерии');
ylabel('Нормализованный вес');
title('Нормализованные веса критериев');
grid on;
