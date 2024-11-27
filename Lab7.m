% Задаем варианты изделий лёгкой промышленности
products = {'Деревянная мебель', 'Текстиль', 'Косметика', 'Бумажные изделия', 'Обувь', 'Одежда'};
n = length(products);

% Эффективность
matrix_effectiveness = [1,   1/2, 2,   3,   3,   4;
                       2,   1,   3,   4,   2,   2;
                       1/2, 1/3, 1,   2,   1,   2;
                       1/3, 1/4, 1/2, 1,   1/3, 1/4;
                       1/3, 1/2, 1,   3,   1,   3;
                       1/4, 1/2, 1/2, 4,   1/3, 1];

% Безопасность применения
matrix_safety = [1,   3,   4,   2,   5,   3;
                1/3,  1,   2,   2,   4,   1;
                1/4, 1/2,  1,   2,   3,   1/2;
                1/2, 1/2, 1/2, 1,   1/2, 1/3;
                1/5, 1/4, 1/3, 2,   1,   1/4;
                1/3, 1,   2,   3,   4,   1];

% Ценовая доступность
matrix_price = [1,   1/2, 2,   3,   4,   5;
               2,   1,   3,   2,   3,   4;
               1/2, 1/3, 1,   1/2, 1/3, 1/2;
               1/3, 1/2, 2,   1,   1/2, 1/4;
               1/4, 1/3, 3,   2,   1,   2;
               1/5, 1/4, 2,   4,   1/2, 1];

% Компоненты (натуральные ингредиенты)
matrix_components = [1,   2,   3,   4,   5,   6;
                    1/2,  1,   2,   3,   4,   5;
                    1/3, 1/2,  1,   2,   3,   4;
                    1/4, 1/3, 1/2,  1,   2,   3;
                    1/5, 1/4, 1/3, 1/2,  1,   2;
                    1/6, 1/5, 1/4, 1/3, 1/2,  1];

% Качество и размер упаковки
matrix_packaging = [1,   2,   3,   4,   5,   1;
                   1/2,  1,   2,   3,   4,  1/2;
                   1/3, 1/2,  1,   2,   3,  1/3;
                   1/4, 1/3, 1/2,  1,   2,  1/4;
                   1/5, 1/4, 1/3, 1/2,  1,  1/5;
                    1,   2,   3,   4,   5,   1];

% Отзывы пользователей 
matrix_reviews = [1,   2,   3,   4,   5,   2;
                 1/2,  1,   2,  1/3,  1/2,  1/4;
                 1/3, 1/2,  1,  1/3,  1,  1/5;
                 1/4,  3,   2,   1,   4,  1/2;
                 1/5, 1/2,  1,  1/4,  1,  1/3;
                 1/2,  2,   3,   2,   1,   1];

weights_effectiveness = calculate_weights(matrix_effectiveness);
weights_safety = calculate_weights(matrix_safety);
weights_price = calculate_weights(matrix_price);
weights_components = calculate_weights(matrix_components);
weights_packaging = calculate_weights(matrix_packaging);
weights_reviews = calculate_weights(matrix_reviews);

disp('Эффективность:'); disp(weights_effectiveness);
disp('Безопасность:'); disp(weights_safety);
disp('Ценовая доступность:'); disp(weights_price);
disp('Компоненты:'); disp(weights_components);
disp('Качество и размер упаковки:'); disp(weights_packaging);
disp('Отзывы:'); disp(weights_reviews);

% Расчет итоговых оценок
final_scores = zeros(n, 1); 
for i = 1:n
    final_scores(i) = weights_effectiveness(i) + ...
                       weights_safety(i) - ...
                       weights_price(i) + ...
                       weights_components(i) + ...
                       weights_packaging(i) + ...
                       weights_reviews(i);
end

normalized_final_scores = final_scores / sum(final_scores);

[max_score, best] = max(normalized_final_scores);

% Вывод результата
fprintf('Лучший продукт: %s с весом: %.4f\n', products{best}, max_score);

% Построение графика
figure;
bar(normalized_final_scores);
xlabel('Изделия лёгкой промышленности'); 
ylabel('Итоговый вес');
title('Итоговые оценки изделий лёгкой промышленности');
xticklabels(products);
grid on;

% Функция для вычисления весов из матрицы парных сравнений
function [normalized_weights] = calculate_weights(matrix)
    n = size(matrix, 1);
    row_products = prod(matrix, 2);
    row_n_products = nthroot(row_products, n);
    total_sum = sum(row_n_products);
    normalized_weights = row_n_products / total_sum;
end
