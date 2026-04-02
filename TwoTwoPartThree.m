%% 3. Диаграмма для пункта 3: Xкз = 3*Xкз
% Номинальные параметры из основного расчёта
Mmax_nom = Mmax;     
sk_nom   = sk;       
a_nom    = a;

% НОВЫЕ параметры при Xкз = 3*Xкз
x_kz_new = 3 * x_kz;        % ХКЗ увеличивается в 3 раза
r1_new   = r1;              % r1 остаётся прежним
r2_pr_new = r2_pr;          % r2' остаётся прежним (приведение не меняется)

% Пересчёт критического скольжения
sk_new = r2_pr_new / sqrt(r1_new^2 + x_kz_new^2);

% Коэффициент a новый
a_new = r1_new / r2_pr_new;

% Новый максимальный момент (уменьшается!)
Mmax_new = (m * U_ph^2) / (2 * omega0 * (r1_new + sqrt(r1_new^2 + x_kz_new^2)));

% Номинальный момент (при том же s_nom)
s_nom = (n0 - n_nom) / n0;
M_nom_new = (2 * Mmax_new * (1 + a_new * sk_new)) / ...
            (s_nom/sk_new + sk_new/s_nom + 2 * a_new * sk_new);

% Характеристики
M_nom = (2 * Mmax_nom * (1 + a_nom * sk_nom)) ./ ...
        (s./sk_nom + sk_nom./s + 2 * a_nom * sk_nom);

M_new = (2 * Mmax_new * (1 + a_new * sk_new)) ./ ...
        (s./sk_new + sk_new./s + 2 * a_new * sk_new);

n_mech_1 = n0 * (1 - s);
n_mech_2 = n0 * (1 - s);    % n0 не меняется!

% Характерные точки
n_Mmax_new = n0 * (1 - sk_new);
n_nom_new = n0 * (1 - s_nom);

%% График
figure('Color','w','Position',[150 150 900 600]);
hold on; grid on; grid minor;

plot(M_nom, n_mech_1, 'LineWidth', 2.0, 'Color', [0 0.45 0.74], ...
    'DisplayName', 'Исходная характеристика');

plot(M_new, n_mech_2, 'LineWidth', 2.0, 'Color', [0.85 0.33 0.10], ...
    'DisplayName', 'X_{кз} = 3X_{кз}');

% Точки максимума
plot(Mmax_nom, n0*(1-sk_nom), 'ro', 'MarkerFaceColor', 'r', ...
    'DisplayName', 'M_{max} (исх.)', 'MarkerSize', 8);
plot(Mmax_new, n_Mmax_new, 'rs', 'MarkerFaceColor', [0.85 0.33 0.10], ...
    'DisplayName', 'M_{max} (новое)', 'MarkerSize', 8);

% Номинальные точки
plot(M_nom_pt, n_nom, 'ks', 'MarkerFaceColor', 'k', ...
    'DisplayName', 'M_{ном} (исх.)', 'MarkerSize', 8);
plot(M_nom_new, n_nom_new, 'k^', 'MarkerFaceColor', 'k', ...
    'DisplayName', 'M_{ном} (новое)', 'MarkerSize', 8);

xlabel('Момент M, Н·м', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Скорость n, об/мин', 'FontSize', 11, 'FontWeight', 'bold');
title('Механические характеристики АД при X_{кз} = 3X_{кз}', 'FontSize', 12);
legend('Location','best');
line([0 0], [min(n_mech_1) max(n_mech_1)], 'Color','k','LineWidth',1);

% Вывод расчётных параметров
fprintf('\n--- При Xкз = 3*Xкз ---\n');
fprintf('Xкз_нов = %.4f Ом\n', x_kz_new);
fprintf('sk_нов  = %.4f (было %.4f)\n', sk_new, sk);
fprintf('a_нов   = %.4f (было %.4f)\n', a_new, a);
fprintf('Mmax_нов= %.1f Н·м (было %.1f)\n', Mmax_new, Mmax);
fprintf('Mном_нов= %.1f Н·м (было %.1f)\n', M_nom_new, M_nom_pt);