% Исходные данные
matr = [0.30, 0.25, 0.25, 0.1;
        0.4, 0.30, 0.30, 0.4;
        0.1, 0.40, 0.15, 0.4;
        0.2, 0.15, 0.30, 0.1];

% Матрица рангов
[num_objects, num_experts] = size(matr);
ranks_matrix = zeros(num_objects, num_experts);

% Проходимся по каждому столбцу
for i = 1 : num_experts
    column = matr(:, i);

    % Сортируем оценки по убыванию и сохраняем индексы
    [sorted_scores, sort_idx] = sort(column, 'descend');

    % Создаем массив рангов
    ranks = zeros(num_objects, 1);
    current_rank = 1;
    prev_score = inf;

    for j = 1 : num_objects
        idx = sort_idx(j);
        score = sorted_scores(j);
        
        % Если текущий счет отличается от предыдущего, обновляем ранг
        if score < prev_score
            current_rank = j;
        end

        % Присываиваем ранг
        ranks(idx) = current_rank;

        % Обновление предыдущего счета
        prev_score = score;
    end

    % Если оценки одинаковы
    unique_scores = unique(sorted_scores);
    for k = 1 : length(unique_scores)
        score = unique_scores(k);
        idxs = find(sorted_scores == score);
        avg_rank = mean(idxs);
        ranks(sort_idx(idxs)) = round(avg_rank * 10) / 10;
    end

    % Заполнение соответствующего столбца в матрице рангов
    ranks_matrix(:, i) = ranks;
end

for j = 1: num_experts
    column = ranks_matrix(:, j);
    [sorted_column, sort_idx] = sort(column, 'ascend');
    sorted_ranks_matrix(:, j) = sorted_column;
end

% Суммирование рангов по строкам
sum_ranks = sum(sorted_ranks_matrix, 2);

avg_sum_ranks = mean(sum_ranks);

otklon = sum_ranks - avg_sum_ranks;
total_otklon = sum(otklon);

T_i = 0;
unique_ranks = unique(ranks_matrix(:));
for i = 1 : length(unique_ranks)
    rank_group = ranks_matrix(ranks_matrix == unique_ranks(i));
    T_i = T_i + (length(rank_group)) ^ 3;
end

n = num_objects;
m = num_experts;

W = 12 * total_otklon^2 / (n^2 * (m^3 - m) - n * T_i);

fprintf('Исходная матрица оценок:\n');
disp(matr);
fprintf('Матрица рангов:\n');
disp(sorted_ranks_matrix);
fprintf('Сумма по каждой строке в матрице рангов:\n')
disp(sum_ranks);
fprintf('Среднее арифметическое суммы рангов по всем объектам:\n')
disp(avg_sum_ranks);
fprintf('Расчет отклонения суммы рангов по j - объекту оценивания от среднего значения:\n')
disp(otklon);
fprintf('Total_otklon:');
disp(total_otklon);
fprintf('Расчетный показатель T_i:\n')
disp(T_i);
fprintf('Коэффициент конкордации W:\n')
disp(W);
if W >= 0.755
    consensus_level = 'Достаточная';
else
    consensus_level = 'Недостаточная';
end

fprintf('Уровень согласованности мнений экспертов: %s\n', consensus_level);